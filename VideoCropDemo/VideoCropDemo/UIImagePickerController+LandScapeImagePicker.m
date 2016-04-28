//
//  UIImagePickerController+LandScapeImagePicker.m
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/27.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import "UIImagePickerController+LandScapeImagePicker.h"

@implementation UIImagePickerController (LandScapeImagePicker)
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
@end
