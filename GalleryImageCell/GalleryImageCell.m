//
//  GalleryImageCell.m
//  VideoReady
//
//  Created by Ashu on 02/07/16.
//  Copyright © 2016 Intelligrape. All rights reserved.
//

#import "VideoReady-Swift.h"
#import "GalleryImageCell.h"


@interface GalleryImageCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    UIImageView *galleryImageView;
    UIActivityIndicatorView *indicator;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic,strong) UIScrollView *galleryScrollView;
@end

@implementation GalleryImageCell


//*******************************************************************************************
#pragma mark-
#pragma-mark Intializer Methods
//*******************************************************************************************

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        [self.contentView setBackgroundColor:[UIColor blackColor]];
        
        _galleryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth  , screenHeight)];
        [_galleryScrollView setDelegate:self];
        [_galleryScrollView setShowsHorizontalScrollIndicator:NO];
        [_galleryScrollView setShowsVerticalScrollIndicator:NO];
        [_galleryScrollView setUserInteractionEnabled:NO];
        _galleryScrollView.bounces=NO;
        [self.contentView addSubview:_galleryScrollView];
        
        galleryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [galleryImageView setContentMode:UIViewContentModeScaleAspectFit];
        [galleryImageView setBackgroundColor:[UIColor clearColor]];
        [_galleryScrollView  addSubview:galleryImageView];
        
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        [indicator setCenter:galleryImageView.center];
        [_galleryScrollView addSubview:indicator];
        
        [self addGestureToView];
    }
    return self;
}


//*******************************************************************************************
#pragma mark-
#pragma-mark Public Methods
//*******************************************************************************************

-(void)configureView:(VRContentModel *)contentModel
{
    VRImageModel * imageModel = (VRImageModel *)contentModel.imageModel;
    if(!imageModel)
        return;
    
    [self commonInit];
    
    NSString *imageUrl = imageModel.imageUrl;
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"c_fit,g_north,w_250,h_250/"
                                                   withString:@""];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"c_fill,g_north,w_250,h_250/"
                                                   withString:@""];
    if ([imageUrl rangeOfString:@".jpg"].location == NSNotFound) {
        imageUrl = [imageUrl stringByAppendingString:@".jpg"];
    }
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    [indicator startAnimating];
    __weak  UIImageView *weakImageView = galleryImageView;
    
    [weakImageView sd_setImageWithURL:url placeholderImage:nil completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl){
        
        [self changeheightAccordingToImage:weakImageView.image.size];
        [indicator stopAnimating];
        [_galleryScrollView setUserInteractionEnabled:YES];
    }];
}


//*******************************************************************************************
#pragma mark-
#pragma-mark UIScrollView Delegate Methods
//*******************************************************************************************


//- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    // Return the view that you want to zoom
//    return galleryImageView;
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    [self setNeedsLayout]; // triggers a layout update during the next update cycle
//    [self layoutIfNeeded];
//}


//*******************************************************************************************
#pragma mark-
#pragma-mark Private Methods
//*******************************************************************************************

-(void)commonInit{
    
    // Set up the minimum & maximum zoom scales
    _galleryScrollView.minimumZoomScale = 1.0;
    _galleryScrollView.maximumZoomScale = 4.0;
    [_galleryScrollView setZoomScale:_galleryScrollView.minimumZoomScale];
    _galleryScrollView.contentSize = galleryImageView.frame.size;
    
    galleryImageView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
}

-(void)addGestureToView{
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [_galleryScrollView addGestureRecognizer:doubleTapRecognizer];
    
}

-(void)changeheightAccordingToImage:(CGSize )size{
    CGFloat xScale=size.width/screenWidth;
    CGFloat yScale=size.height/screenHeight;
    
    if(xScale <=1 && yScale <=1)
    {
        galleryImageView.frame=CGRectMake(0, (screenHeight-size.height)/2, size.width, size.height);
    }
    else if (xScale >= yScale)
    {
        CGFloat height=size.height/xScale;
        galleryImageView.frame=CGRectMake(0, (screenHeight-height)/2,galleryImageView.frame.size.width, height);
    }
    else if (yScale >=xScale)
    {
        CGFloat width=size.width/yScale;
        galleryImageView.frame=CGRectMake(0, 0, width, galleryImageView.frame.size.height);
    }
    
    [galleryImageView setCenter:_galleryScrollView.center];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
//    if(_galleryScrollView.zoomScale > _galleryScrollView.minimumZoomScale)
//        [_galleryScrollView setZoomScale:_galleryScrollView.minimumZoomScale animated:YES];
//    else
//        [_galleryScrollView setZoomScale:_galleryScrollView.maximumZoomScale animated:YES];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = super.bounds.size;
    CGRect frameToCenter = galleryImageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2 - 5;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 ;
    else
        frameToCenter.origin.y = 0;
    
    galleryImageView.frame = frameToCenter;
}

@end
