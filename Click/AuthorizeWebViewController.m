//
//  AuthorizeWebViewController.m
//  Click
//
//  Created by Suraj on 18/12/14.
//  Copyright (c) 2014 Suraj. All rights reserved.
//

#import "AuthorizeWebViewController.h"
#import "FlickrKit.h"

@interface AuthorizeWebViewController () {
    __weak IBOutlet UIWebView *webViewAuth;
}
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@end

@implementation AuthorizeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Authentication";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // This must be defined in your Info.plist
    // See FlickrKitDemo-Info.plist
    // Flickr will call this back. Ensure you configure your flickr app as a web app
    NSString *callbackURLString = @"click://auth";
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                [webViewAuth loadRequest:urlRequest];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.authOp cancel];
    [super viewWillDisappear:animated];
}

#pragma mark - Web View


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //If they click NO DONT AUTHORIZE, this is where it takes you by default... maybe take them to my own web site, or show something else
    
    NSURL *url = [request URL];
    
    // If it's the callback url, then lets trigger that
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    
    return YES;
    
}
@end
