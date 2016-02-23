//
//  ImageCropResize.h
//  ImageCropResize PhoneGap / Cordova Plugin
//
//  Created by Raanan Weber on 02.01.12.
// 
//  The software is open source, MIT Licensed.
//  Copyright (c) 2012-2013 webXells GmbH , http://www.webxells.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface ImageCropResize : CDVPlugin {
    
    NSString* callbackID;  
    
}

@property (nonatomic, copy) NSString* callbackID;

//Instance Method  

- (void) cropResizeImage:(CDVInvokedUrlCommand*)command;

@end
