//
//  UIImage(ITTAdditions).m
//
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//1000*5 1540%5/
#import "UIImage+ITTAdditions.h"


@implementation UIImage (ITTAdditions)

- (UIImage *)imageRotatedToCorrectOrientation
{
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGSize imageSize = CGSizeMake(width, height);
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage *)imageCroppedWithRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (scale>1.0) {
        rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

- (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize
{
    CGSize viewSize = aSize;
    CGFloat scale;
    CGSize newsize;
    
    if(thisSize.width<viewSize.width && thisSize.height < viewSize.height){
        newsize = thisSize;
    }else {
        if(thisSize.width >= thisSize.height){
            scale = viewSize.width/thisSize.width;
            newsize.width = viewSize.width;
            newsize.height = thisSize.height*scale;
        }else {
            scale = viewSize.height/thisSize.height;
            newsize.height = viewSize.height;
            newsize.width = thisSize.width*scale;
        }
    }
    return newsize;
}

- (UIImage *)imageFitInSize: (CGSize) viewsize
{
    // calculate the fitted size
    CGSize size = [self fitSize:self.size inSize:viewsize];
    
    UIGraphicsBeginImageContext(size);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

-(UIImage *)imageCutWithSize:(CGSize)size0{
    
    CGSize size = [self cutSize:CGSizeMake(self.size.width*2, self.size.height*2) inSize:CGSizeMake(size0.width, size0.height)];
    
    UIGraphicsBeginImageContext(size);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    //    UIImage *lImg = [newimg imageFitInSize:size0];
    return newimg;
    //    return lImg;
}
-(CGSize)cutSize:(CGSize)size1 inSize:(CGSize)size2{
    
    CGSize resSize;
    CGFloat xishu1 = size1.width/size1.height;
    CGFloat xishu2 = size2.width/size2.height;
//    NSLog(@"最后洗漱 %f %f",xishu1,xishu2);
    if(size1.width<size2.width){
        
        if (size1.height<size2.height) {//放大
            if (xishu1>xishu2) {
                resSize.height = size2.height;
                resSize.width = size2.height*xishu1;
            } else {
                resSize.width = size2.width;
                resSize.height = size2.width/xishu1;
            }
            
        }else{//裁剪高度
            resSize.width = size2.width;
            resSize.height = size2.width/xishu1;
            
        }
        
        
    }else{
        
        if (size1.height<=size2.height) {
            resSize.height = size2.height;
            resSize.width = size2.height*xishu1;
        }else{//缩小
            if (xishu1>xishu2) {
                resSize.height = size2.height;
                resSize.width = size2.height*xishu1;
            }else{
                resSize.width = size2.width;
                resSize.height = size2.width/xishu1;
            }
        }
        
    }
    
    
    return resSize;
    
}


- (UIImage *)imageScaleToFillInSize: (CGSize) viewsize
{
    // calculate the fitted size
    UIGraphicsBeginImageContext(viewsize);
    
    CGRect rect = CGRectMake(0, 0, viewsize.width, viewsize.height);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

/*!
 * Returns the color of the image pixel at point. Returns nil if point lies outside the image bounds.
 * If the point coordinates contain decimal parts, they will be truncated.
 *
 * To get at the pixel data, this method must draw the image into a bitmap context.
 * For minimal memory usage and optimum performance, only the specific requested
 * pixel is drawn.
 * If you need to query pixel colors for the same image repeatedly (e.g., in a loop),
 * this approach is probably less efficient than drawing the entire image into memory
 * once and caching it.
 */
- (UIColor *)colorAtPixel:(CGPoint)point
{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
-(UIImage *)imageWithEdgeLashen
{
    UIImage *  img=[self stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    return img;
    
    
}

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}



@end
