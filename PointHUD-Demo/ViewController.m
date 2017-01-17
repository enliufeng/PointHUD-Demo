//
//  ViewController.m
//  PointHUD-Demo
//
//  Created by 翻墙的小猪 on 2017/1/17.
//  Copyright © 2017年 翻墙的小猪. All rights reserved.
//

#import "ViewController.h"
#import "LoadingHUD.h"

@interface ViewController ()

@property (nonatomic,strong)LoadingHUD *hud;
@property (nonatomic,strong)NSTimer    *timer;
@property (nonatomic,strong)UIButton   *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-20, 100, 40)];
    [_button setTitle:@"Preview" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)action:(id)action{

    if ([action isKindOfClass:[UIButton class]]) {
        
        _button.hidden = YES;
        _hud = [[LoadingHUD alloc]init];
        [_hud showLoading];
        [_hud showText:@"I am showing"];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(action:) userInfo:nil repeats:NO];
    }else{
    
        [_hud removeLoading];
        _button.hidden = NO;
        if (_timer) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer = nil;
            }
        }
    }
}


@end
