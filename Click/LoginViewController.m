//
//  ViewController.m
//  Click
//
//  Created by Suraj on 17/12/14.
//  Copyright (c) 2014 Suraj. All rights reserved.
//

#import "LoginViewController.h"
#import "FlickrKit.h"
#import "AuthorizeWebViewController.h"
#import "DashboardViewController.h"

@interface LoginViewController () {
    __weak IBOutlet UIImageView *imgViewScreenBG;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UIImageView *imgViewLogo;
    UIStoryboard *storyBoard;
}
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUserInterface {
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //[self userLoggedOut];
                [self userLoggedIn:userName userID:userId];
            } else {
                [self userLoggedOut];
            }
        });		
    }];
}

#pragma mark - Auth

- (IBAction) authButtonPressed:(id)sender {
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [self userLoggedOut];
    } else {
        AuthorizeWebViewController *authorizeWebViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AuthorizeScreenStoryboardID"];
        [self.navigationController pushViewController:authorizeWebViewController animated:YES];
    }	
}

- (void) userAuthenticateCallback:(NSNotification *)notification {
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (!error) {
                [self userLoggedIn:userName userID:userId];
                // Navigate to Dashboard Screen on successfull login
                DashboardViewController *dashboardViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashboardScreenStoryboardID"];
                [self.navigationController pushViewController:dashboardViewController animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID {
    self.userID = userID;
    [btnLogin setTitle:@"Logout" forState:UIControlStateNormal];
    //self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void) userLoggedOut {
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    //self.authLabel.text = @"Login to flickr";
}



@end
