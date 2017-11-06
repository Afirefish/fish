//
//  CardFeastViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardFeastViewController.h"
#import "FeastView.h"
#import "BaseCardCraftViewController.h"

@interface CardFeastViewController ()

@end

@implementation CardFeastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Card Feast";
    //宴会的场面
    FeastView *feastView = [[FeastView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:feastView];
    //添加yuri craft
    UIButton *yuiBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    yuiBtn.frame = CGRectMake(0, self.view.bounds.size.height * 0.85, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.1);
    yuiBtn.backgroundColor = [UIColor clearColor];
    //[yuiBtn setTitle:@"yui" forState:UIControlStateNormal];
    [yuiBtn addTarget:self action:@selector(yuiCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yuiBtn];
    //添加kirito
    UIButton *kiritoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    kiritoBtn.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.8, self.view.bounds.size.height * 0.1);
    kiritoBtn.backgroundColor = [UIColor clearColor];
    //[kiritoBtn setTitle:@"kirito" forState:UIControlStateNormal];
    [kiritoBtn addTarget:self action:@selector(kiritoCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kiritoBtn];
    //添加asuna
    UIButton *asunaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    asunaBtn.frame = CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.8, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.1);
    asunaBtn.backgroundColor = [UIColor clearColor];
    //[asunaBtn setTitle:@"asuna" forState:UIControlStateNormal];
    [asunaBtn addTarget:self action:@selector(asunaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:asunaBtn];
    //添加leafa
    UIButton *leafaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leafaBtn.frame = CGRectMake(self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.38, self.view.bounds.size.width  * 0.3, self.view.bounds.size.height * 0.05);
    leafaBtn.backgroundColor = [UIColor clearColor];
    //[leafaBtn setTitle:@"leafa" forState:UIControlStateNormal];
    [leafaBtn addTarget:self action:@selector(leafaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leafaBtn];
    //添加silica
    UIButton *silicaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    silicaBtn.frame = CGRectMake(self.view.bounds.size.width * 0.65, self.view.bounds.size.height * 0.45, self.view.bounds.size.width  * 0.25, self.view.bounds.size.height *0.05);
    silicaBtn.backgroundColor = [UIColor clearColor];
    //[silicaBtn setTitle:@"silica" forState:UIControlStateNormal];
    [silicaBtn addTarget:self action:@selector(silicaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:silicaBtn];
    //添加agil
    UIButton *agilBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    agilBtn.frame = CGRectMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.6, self.view.bounds.size.width  * 0.4, self.view.bounds.size.height * 0.05);
    agilBtn.backgroundColor = [UIColor clearColor];
    //[agilBtn setTitle:@"agil" forState:UIControlStateNormal];
    [agilBtn addTarget:self action:@selector(agilCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agilBtn];
    //添加klein
    UIButton *kleinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    kleinBtn.frame = CGRectMake(self.view.bounds.size.width * 0.3, self.view.bounds.size.height  * 0.1, self.view.bounds.size.width  * 0.6, self.view.bounds.size.height * 0.1);
    kleinBtn.backgroundColor = [UIColor clearColor];
    //[kleinBtn setTitle:@"klein" forState:UIControlStateNormal];
    [kleinBtn addTarget:self action:@selector(kleinCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kleinBtn];
    //添加lisbeth
    UIButton *lisbethBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    lisbethBtn.frame = CGRectMake(self.view.bounds.size.width * 0.3, self.view.bounds.size.height  * 0.25, self.view.bounds.size.width  * 0.6, self.view.bounds.size.height * 0.1);
    lisbethBtn.backgroundColor = [UIColor clearColor];
    //[lisbethBtn setTitle:@"lisbeth" forState:UIControlStateNormal];
    [lisbethBtn addTarget:self action:@selector(lisbethCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lisbethBtn];
}

- (void)yuiCraft {
    NSLog(@"YUI CRAFT");
    BaseCardCraftViewController *yuiCraft = [[BaseCardCraftViewController alloc] initWithName:@"Yui"];
    yuiCraft.navigationItem.title = @"Yui";
    [self.navigationController pushViewController:yuiCraft animated:YES];
}

- (void)kiritoCraft {
    NSLog(@"KIRITO CRAFT");
    BaseCardCraftViewController *kiritoCraft = [[BaseCardCraftViewController alloc] initWithName:@"Kirito"];
    kiritoCraft.navigationItem.title = @"Kirito";
    [self.navigationController pushViewController:kiritoCraft animated:YES];
}

- (void)asunaCraft {
    NSLog(@"ASUNA CRAFT");
    BaseCardCraftViewController *asunaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Asuna"];
    asunaCraft.navigationItem.title = @"Asuna";
    [self.navigationController pushViewController:asunaCraft animated:YES];
}

- (void)leafaCraft {
    NSLog(@"LEAFA CRAFT");
    BaseCardCraftViewController *leafaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Leafa"];
    leafaCraft.navigationItem.title = @"Leafa";
    [self.navigationController pushViewController:leafaCraft animated:YES];
}

- (void)silicaCraft {
    NSLog(@"SILICA CRAFT");
    BaseCardCraftViewController *silicaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Silica"];
    silicaCraft.navigationItem.title = @"Silica";
    [self.navigationController pushViewController:silicaCraft animated:YES];
}

- (void)agilCraft {
    NSLog(@"AGIL CRAFT");
    BaseCardCraftViewController *agilCraft = [[BaseCardCraftViewController alloc] initWithName:@"Agil"];
    agilCraft.navigationItem.title = @"Agil";
    [self.navigationController pushViewController:agilCraft animated:YES];
}

- (void)kleinCraft {
    NSLog(@"KLEIN CRAFT");
    BaseCardCraftViewController *kleinCraft = [[BaseCardCraftViewController alloc] initWithName:@"Klein"];
    kleinCraft.navigationItem.title = @"Klein";
    [self.navigationController pushViewController:kleinCraft animated:YES];
}

- (void)lisbethCraft {
    NSLog(@"LISBETH CRAFT");
    BaseCardCraftViewController *lisbethCraft = [[BaseCardCraftViewController alloc] initWithName:@"Lisbeth"];
    lisbethCraft.navigationItem.title = @"Lisbeth";
    [self.navigationController pushViewController:lisbethCraft animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
