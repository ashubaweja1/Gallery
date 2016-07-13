//
//  SelectedImagesGalleryViewController.m
//  VideoReady
//
//  Created by Ashu on 02/07/16.
//  Copyright © 2016 Intelligrape. All rights reserved.
//

#import "VideoReady-Swift.h"
#import "SelectedImagesGalleryViewController.h"
#import "GalleryImageCell.h"


#define GALLERYCELLIDENTIFIER @"GALLERYCELL"


@interface SelectedImagesGalleryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    __weak IBOutlet UICollectionView *galleryCollectionView;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UITextField *titleLabel;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UILabel *imageTitleLabel;
    __weak IBOutlet UILabel *imageDescriptionLabel;
    
    NSArray *imagesModelArray;
    BOOL istapped;
    BOOL isInitialSetup;
    int selectedImageIndex;
}

@end

@implementation SelectedImagesGalleryViewController


//****************************************************************************************
#pragma mark-
#pragma-mark Intializer Methods
//****************************************************************************************

- (id) initWithArray:(NSArray *)array withSelectedIndex:(int)selectedIndex
{
    self = [super initWithNibName:@"SelectedImagesGalleryViewController" bundle:nil];
    if (self) {
        imagesModelArray=[[NSArray alloc]initWithArray:array];
        selectedImageIndex = selectedIndex;
        isInitialSetup = true;
    }
    return  self;
}


//**********************************************************************************************************
#pragma mark-
#pragma-mark View LifeCylce Methods
//**********************************************************************************************************

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    galleryCollectionView.delegate=self;
    galleryCollectionView.dataSource=self;
    [galleryCollectionView registerClass:[GalleryImageCell class] forCellWithReuseIdentifier:GALLERYCELLIDENTIFIER];
     galleryCollectionView.bounces=NO;
    galleryCollectionView.backgroundColor=[UIColor blackColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
    [self.view addGestureRecognizer:gestureRecognizer];
    titleLabel.text=[NSString stringWithFormat:@"%d/%lu",1,(unsigned long)[imagesModelArray count]];
    [self showImageDetails];
    istapped=YES;
    topView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
    bottomView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    
    if (isInitialSetup) {
        CGFloat galleryOffsetX = ([UIScreen mainScreen].bounds.size.width + 10) * selectedImageIndex;
        [galleryCollectionView setContentOffset:CGPointMake(galleryOffsetX, 0.0) animated:NO];
    }
}


//*******************************************************************************************
#pragma mark-
#pragma-mark Button Action Methods
//*******************************************************************************************

- (IBAction)popGalleryView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    VRImageModel *imageModel = [imagesModelArray[selectedImageIndex] imageModel];
    [Utility shareContent:self shareUrl:imageModel.imageShareUrl shareMessage:imageModel.imageTitle];
}

//*******************************************************************************************
#pragma mark-
#pragma-mark Collection View Methods
//*******************************************************************************************

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [imagesModelArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:GALLERYCELLIDENTIFIER forIndexPath:indexPath];
    [cell configureView:imagesModelArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width + 10, [UIScreen mainScreen].bounds.size.height);
}


//*******************************************************************************************
#pragma mark-
#pragma-mark Scroll View Methods
//*******************************************************************************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    float x=scrollView.contentOffset.x;
    int index=(int)x/([UIScreen mainScreen].bounds.size.width + 10);
    titleLabel.text=[NSString stringWithFormat:@"%d/%lu",index+1,(unsigned long)[imagesModelArray count]];
    
    selectedImageIndex = index;
    [self showImageDetails];
}


//*******************************************************************************************
#pragma mark-
#pragma-mark Private Methods
//*******************************************************************************************

-(void)tapHandler
{
    if(istapped){
        istapped = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [topView setHidden:YES];
        [bottomView setHidden:YES];

    }else{
        istapped= YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [topView setHidden:NO];
        [bottomView setHidden:NO];
    }
}

- (void)showImageDetails {
    VRImageModel *imageModel = [imagesModelArray[selectedImageIndex] imageModel];
    
    [imageTitleLabel setText:imageModel.imageTitle];
    [imageDescriptionLabel setText:imageModel.imageDescription];
}

@end
