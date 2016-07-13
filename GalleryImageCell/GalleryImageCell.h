//
//  GalleryImageCell.h
//  VideoReady
//
//  Created by Ashu on 02/07/16.
//  Copyright © 2016 Intelligrape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VRContentModel;

@interface GalleryImageCell : UICollectionViewCell

-(void)configureView:(VRContentModel *)contentModel;

@end
