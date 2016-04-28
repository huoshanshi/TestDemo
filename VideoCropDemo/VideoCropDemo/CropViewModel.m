//
//  CropViewModel.m
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/25.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import "CropViewModel.h"

@implementation CropViewModel
+(BOOL)markerIsEffectiveWith:(NSMutableArray *)markArr leftPoint:(CGFloat)leftPoint {
    if (markArr.count>0) {
        
        for (NSString *leftStr in markArr) {
            
            CGFloat left=[leftStr floatValue];
            
            
            
            if (leftPoint<left) {
              
                return NO;
               
            }
        }
    }
 return YES;
}

@end
