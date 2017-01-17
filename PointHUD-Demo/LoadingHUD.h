//
//  LoadingHUD.h
//  HdgSDK_Pay
//
//  Created by 翻墙的小猪 on 2017/1/13.
//  Copyright © 2017年 hodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingHUD : UIView

/*
 * 初始化一个等待效果
 */
- (instancetype)init;

/*
 * 全屏幕遮盖
 */
- (void)showLoading;

/*
 * 动画下需要显示的文字
 */
- (void)showText:(NSString*)string;

/*
 * 停止 移出等待效果和文字
 */
- (void)removeLoading;

@end
