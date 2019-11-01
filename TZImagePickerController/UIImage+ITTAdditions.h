//
//  UIImage(ITTAdditions).h
//
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(ITTAdditions)

- (UIImage *)imageRotatedToCorrectOrientation;
- (UIImage *)imageCroppedWithRect:(CGRect)rect;
- (UIImage *)imageFitInSize:(CGSize)viewsize;
- (UIImage *)imageScaleToFillInSize:(CGSize)viewsize;
/*
 A category on UIImage that enables you to query the color value of arbitrary
 pixels of the image.
 */
- (UIColor *)colorAtPixel:(CGPoint)point;
-(UIImage *)imageWithEdgeLashen;
-(UIImage *)imageCutWithSize:(CGSize)size0;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
