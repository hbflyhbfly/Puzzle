//
//  UIImage+Resize.h
//  Puzzle
//
//  Created by Syuuhi on 13-6-6.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

-(UIImage *)resizedImageWithSize:(CGSize)size;
-(UIImage *)cropImageFromFrame:(CGRect)frame;

@end
