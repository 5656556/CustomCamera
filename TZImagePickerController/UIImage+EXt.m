//
//  UIImage+EXt.m
//  TZImagePickerController
//
//  Created by Rey on 2019/9/26.
//  Copyright © 2019 谭真. All rights reserved.
//

#import "UIImage+EXt.h"

//#import <AppKit/AppKit.h>


@implementation UIImage (EXt)
- (UIImage*)imageWaterMarkWithString:(NSArray*)arr startPoint:(CGPoint)position {
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointZero]; 
    //画 自己想要画的内容
    CGFloat swid = [UIScreen mainScreen].bounds.size.width;
    CGFloat eleHei = MAX(1, self.size.width/swid);
    CGFloat left = position.x*eleHei;
    CGRect rect0 = CGRectMake(left, position.y*eleHei, self.size.width-2*position.x, 26*eleHei);
    
    NSString *oStr = arr[0];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:oStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25*eleHei] range:NSMakeRange(0, 5)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*eleHei] range:NSMakeRange(5, oStr.length-5)];
    [att drawInRect:rect0];
    UIImage *image1 = [UIImage imageNamed:@"location"];
    UIImage *image2 = [UIImage imageNamed:@"person1"];
    CGFloat wid1 = 15*eleHei;
    CGFloat hei1 = image1.size.height*wid1/image1.size.width;
    
    CGFloat hei2 = image2.size.height*wid1/image2.size.width;
    CGFloat space = 7*eleHei;
    CGRect rect1 = CGRectMake(left, CGRectGetMaxY(rect0)+space, wid1, hei1);
    [image1 drawInRect:rect1];
    
    NSString *str1 = arr[1];
    [str1
     drawInRect:CGRectMake(CGRectGetMaxX(rect1)+2, rect1.origin.y+1, self.size.width-CGRectGetMaxX(rect1)-left-2, hei1)
     withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                      NSFontAttributeName:[UIFont systemFontOfSize:12*eleHei],
                      }];
    CGRect rect2 = CGRectMake(left, CGRectGetMaxY(rect1)+space-1, wid1, hei2);
    [image2 drawInRect:rect2];
    
    NSString *str2 = arr[2];
    [str2
     drawInRect:CGRectMake(CGRectGetMaxX(rect2)+2, rect2.origin.y, self.size.width-CGRectGetMaxX(rect2)-left-2, hei2)
     withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                      NSFontAttributeName:[UIFont systemFontOfSize:12*eleHei],
                      }];

    
    UIImage *waterImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    image1 = nil;
//    image2 = nil;
//    att = nil;
    return waterImg;
}

@end
