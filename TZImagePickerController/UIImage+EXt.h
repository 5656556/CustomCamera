//
//  UIImage+EXt.h
//  TZImagePickerController
//
//  Created by Rey on 2019/9/26.
//  Copyright © 2019 谭真. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EXt)
- (UIImage*)imageWaterMarkWithString:(NSArray*)arr startPoint:(CGPoint)sPoint;

@end

NS_ASSUME_NONNULL_END
