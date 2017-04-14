//
//  BPUIImageAdditions.m
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "BPUIImageAdditions.h"

CGContextRef createARGBBitmapContextFromImage(CGImageRef image)
{
    CGContextRef    context = NULL;
    CGImageRef      inImage = image;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	NSInteger       bitmapByteCount;
	NSInteger       bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
    return context;
}

@implementation UIImage(ws)

- (UIImage *)resizableImageForAlliOSVersionWithCapInsets:(UIEdgeInsets)capInsets {
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 4.99) {
        return [self resizableImageWithCapInsets:capInsets];
    } else {
        return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
}

- (UIImage *)scaleToScale:(float)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scale,self.size.height*scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width*scale, self.size.height*scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)resizeToSize:(CGSize)size
{
    if (self.size.width==size.width&&self.size.height==size.height) {
        return self;
    }
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)resizeToSizeWithScale:(CGSize)size
{
    if (self.size.width==size.width&&self.size.height==size.height) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)resizeWithMaxSize:(CGSize)size
{
    if (self.size.width>size.width || self.size.height>size.height) {
        CGSize maxSize = CGSizeMake(size.width, floorf(size.width/self.size.width*self.size.height));
        if (maxSize.height>size.height) {
            maxSize = CGSizeMake(floorf(size.height/self.size.height*self.size.width), size.height);
        }
        return [self resizeToSize:maxSize];
    }
    return self;
}

- (UIImage *)resizeWithMaxLength:(CGFloat)maxLength {
    if (self.size.width>maxLength || self.size.height>maxLength) {
        CGSize maxSize;
        if (self.size.width > self.size.height) {
            maxSize = CGSizeMake(maxLength, floorf(maxLength/self.size.width*self.size.height));
        } else {
            maxSize = CGSizeMake(floorf(maxLength/self.size.height*self.size.width), maxLength);
        }
        return [self resizeToSize:maxSize];
    }
    return self;
}

- (UIImage *)resizeWithMinLength:(CGFloat)minLength {
    if (self.size.width>minLength && self.size.height>minLength) {
        CGSize minSize;
        if (self.size.width < self.size.height) {
            minSize = CGSizeMake(minLength, floorf(minLength/self.size.width*self.size.height));
        } else {
            minSize = CGSizeMake(floorf(minLength/self.size.height*self.size.width), minLength);
        }
        return [self resizeToSize:minSize];
    }
    return self;
}

- (UIImage *)rotateImageWithOri:(int)ori
{
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    UIImageOrientation orient = ori;
    
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (UIImage *)rotateImage {
    return [self rotateImageWithOri:self.imageOrientation];
}

- (UIColor *)pixcelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
	CGImageRef inImage = self.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = createARGBBitmapContextFromImage(self.CGImage);
	if (cgctx == NULL) { return nil; /* error */ }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
	if (data != NULL) {
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  data[offset]; 
		int red = data[offset+1]; 
		int green = data[offset+2]; 
		int blue = data[offset+3]; 
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}
	
	// When finished, release the context
	CGContextRelease(cgctx); 
	// Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

- (UIImage *)getSubImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return image;
}

- (UIImage *)addImageAtBottom:(UIImage *)image
{
    CGSize size1 = CGSizeMake(self.size.width, self.size.height);
    CGSize size2 = CGSizeMake(self.size.width, self.size.width*image.size.height/image.size.width);
    
    CGSize size = CGSizeMake(size1.width, size1.height+size2.height);
    
    UIGraphicsBeginImageContext(size);
    // Draw image1
    [image drawInRect:CGRectMake(0, size1.height, size2.width, size2.height)];
    // Draw image2
    [self drawInRect:CGRectMake(0, 0, size1.width, size1.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (UIImage *)addCornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:cornerRadius] addClip];
    [self drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
