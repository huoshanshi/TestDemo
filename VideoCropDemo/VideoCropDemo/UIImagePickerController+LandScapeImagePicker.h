//
//  UIImagePickerController+LandScapeImagePicker.h
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/27.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (LandScapeImagePicker)
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end
