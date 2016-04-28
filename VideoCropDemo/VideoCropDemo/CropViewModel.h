//
//  CropViewModel.h
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/25.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CropViewModel : NSObject
+(BOOL)markerIsEffectiveWith:(NSMutableArray *)markArr leftPoint:(CGFloat)leftPoint;
@end
