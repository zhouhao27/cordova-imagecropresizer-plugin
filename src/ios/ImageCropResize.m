//
//  ImageCropResize.m
//  ImageCropResize PhoneGap / Cordova Plugin
//
//  Created by Raanan Weber on 02.01.12.
//
//  The software is open source, MIT Licensed.
//  Copyright (c) 2012-2013 webXells GmbH , http://www.webxells.com. All rights reserved.
//

#import "ImageCropResize.h"
#import "NSData+Base64.h"
#import "CDVFile.h"

@implementation ImageCropResize

@synthesize callbackID;

- (void) cropResizeImage:(CDVInvokedUrlCommand*)command {
    NSDictionary *options = [command.arguments objectAtIndex:0];
    
    CGFloat width = [[options objectForKey:@"width"] floatValue];
    CGFloat height = [[options objectForKey:@"height"] floatValue];
    NSInteger quality = [[options objectForKey:@"quality"] integerValue];
    NSString *format =  [options objectForKey:@"format"];
    
    //Load the image
    UIImage *img = [self getImageUsingOptions:options];
    UIImage *scaledImage = [self cropResizeImage:img toWidth:width toHeight:height];     
    
    NSNumber *newWidthObj = [[NSNumber alloc] initWithFloat:width];
    NSNumber *newHeightObj = [[NSNumber alloc] initWithFloat:height];
    
    CDVPluginResult* pluginResult = nil;
    NSData* imageDataObject = nil;
    if ([format isEqualToString:@"jpg"]) {
      imageDataObject = UIImageJPEGRepresentation(scaledImage, (quality/100.f));
    } else {
      imageDataObject = UIImagePNGRepresentation(scaledImage);
    }
        
    NSString *encodedString = [imageDataObject base64EncodingWithLineLength:0];
    NSDictionary* result = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:encodedString, newWidthObj, newHeightObj, nil] forKeys:[NSArray arrayWithObjects: @"imageData", @"width", @"height", nil]];
    
    if (encodedString != nil) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (UIImage*) getImageUsingOptions:(NSDictionary*)options {
  NSString *imageData = [options objectForKey:@"data"];
    
  UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithBase64EncodedString:imageData]];
  return img;
}

-(UIImage *)cropResizeImage:(UIImage *)sourceImage toWidth:(CGFloat)newWidth toHeight:(CGFloat)newHeight
{
    // input size comes from image
    CGSize inputSize = sourceImage.size;
    
    // round up side length to avoid fractional output size
    newWidth = ceilf(newWidth);
    newHeight = ceilf(newHeight);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(newWidth, newHeight);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(newWidth / inputSize.width,
                        newHeight / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                        inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0,
                                 outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                   center.y - scaledInputSize.height/2.0,
                                   scaledInputSize.width,
                                   scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [sourceImage drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}

@end
