//
//  DashboardViewController.m
//  Click
//
//  Created by Suraj on 19/12/14.
//  Copyright (c) 2014 Suraj. All rights reserved.
//

#import "DashboardViewController.h"
#import "FlickrKit.h"

@interface DashboardViewController () <UISearchBarDelegate> {
    __weak IBOutlet UICollectionView *collectionViewPhotos;
    __weak IBOutlet UISearchBar *searchBarFlickr;
    __weak IBOutlet UIBarButtonItem *barBtnUploadPhoto;
    NSMutableArray *mutArrPhotos;
}

- (IBAction)navigateToUploadPhotoScreen:(id)sender;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Photos";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)navigateToUploadPhotoScreen:(id)sender {
    
}

#pragma UICollectionView - Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mutArrPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PhotoCellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    UIImageView *imgViewAlbumCoverPhoto = (UIImageView *)[cell viewWithTag:1];
    [imgViewAlbumCoverPhoto setImage:[UIImage imageNamed:@"loading.png"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[mutArrPhotos objectAtIndex:indexPath.row]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        [imgViewAlbumCoverPhoto setImage:image];        
    }];
    
    UIView *viewTransparencyLayer = (UIView *)[cell viewWithTag:2];
    [viewTransparencyLayer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    
    UILabel *lblAlbumTitle = (UILabel *)[cell viewWithTag:3];
    //[lblAlbumTitle setText:photoAlbumListJSONParser.strAlbumTitle];
    
    return cell;
}

#pragma UICollectionView - Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected photo index: %li",(long)indexPath.row);
}

#pragma - UISearchbBar Delegate Methods
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchPhotosOnFlickr];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchPhotosOnFlickr];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


-(void)searchPhotosOnFlickr {
    if ([searchBarFlickr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        // No text to search
        return;
    }
    [searchBarFlickr endEditing:YES];
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = searchBarFlickr.text;
    search.per_page = @"15";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                mutArrPhotos = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:photoDictionary];
                    [mutArrPhotos addObject:url];
                }
                
                if ([mutArrPhotos count] > 0) {
                    [collectionViewPhotos reloadData];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

@end
