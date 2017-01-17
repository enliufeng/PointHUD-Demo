//
//  UIView+MyRefresh.h
//  Corner-APP
//
//  Created by 翻墙的小猪 on 2017/1/11.
//  Copyright © 2017年 翻墙的小猪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MyRefresh)

/*
 设置或返回View的 x y h w
 */
@property (nonatomic, assign) float h;
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
