//
//  PRCalendarViewController.m
//  Pretend
//
//  Created by xijia dai on 2019/4/23.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import "PRCalendarViewController.h"
#import "PRCircleView.h"

@interface PRCalendarViewController ()

@end

@implementation PRCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *sizeArr = @[@300.0, @350.0, @400.0, @450.0, @500.0, @550.0, @600.0, @650.0];
    NSArray *colorArr = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor], [UIColor blackColor]];
    for (NSInteger i = 0; i <= 1; i ++) {
        [self addSubViewWithRadius:[[sizeArr objectAtIndex:7 - i] floatValue] color:[colorArr objectAtIndex:7 - i]];
    }
}

- (void)addSubViewWithRadius:(CGFloat)radius color:(UIColor *)color {
    PRCircleView *view = [[PRCircleView alloc] initWithRadius:radius color:color];
    [self.view addSubview:view];
    view.frame = [UIScreen mainScreen].bounds;
}

@end
