//
//  BaseChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatDetail.h"
#import "DevilChatContent.h"
#import "BaseChatCell.h"
#import "ChooseRespondToDevil.h"
#import "BaseChoice.h"

@interface BaseChatDetail ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation BaseChatDetail

+ (instancetype)chatDetail {
    static BaseChatDetail *chatDetail = nil;
    if (chatDetail == nil) {
        chatDetail = [[BaseChatDetail alloc] init];
    }
    return chatDetail;
}

//初始化聊天节点数，
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 0;
    self.nodeNumber = 0;
    self.isDevil = YES;
    self.chatContent = [[DevilChatContent alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.9) style:UITableViewStylePlain];
    self.chatContent.delegate = self;
    self.chatContent.dataSource = self;
    [self.view addSubview:self.chatContent];
    self.chooseContent = [[ChooseRespondToDevil alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.9, self.view.bounds.size.width, self.view.bounds.size.height * 0.1)];
    [self.view addSubview:self.chooseContent];
    self.chooseRespond = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.chooseContent.frame.size.width, self.chooseContent.frame.size.height)];
    [self.chooseRespond setTitle:@"Responder?" forState:UIControlStateNormal];
    [self.chooseRespond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chooseRespond addTarget:self action:@selector(showChoices) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseContent addSubview:self.chooseRespond];
}

//准备选择时，检查聊天记录的视图偏移量，进行调整
- (void)checkChatContent {
    CGFloat distance = self.cellHeight + 64 - self.chooseContent.frame.origin.y;
    if ( distance > 0 ) {
        CGRect chatContentFrame = self.chatContent.frame;
        chatContentFrame.origin.y = -distance;
        chatContentFrame.size.height = self.view.bounds.size.height * 0.9 + distance;
        self.chatContent.frame = chatContentFrame;
    }
}

//设置respond bar选中之后的变化
- (void)setRespondBar {
    //之前以为要重绘，发现原来只要修改frame就可以
    CGRect chooseContentFrame= self.chooseContent.frame;
    chooseContentFrame.origin.y = self.view.bounds.size.height * 0.6;
    self.chooseContent.frame = chooseContentFrame;
    [self checkChatContent];
}

//恢复respond bar的初始状态
- (void)recoverRespondBar {
    CGRect chooseContentFrame= self.chooseContent.frame;
    chooseContentFrame.origin.y = self.view.bounds.size.height * 0.9;
    self.chooseContent.frame = chooseContentFrame;
    [self removeChoicesView];
    CGRect chatContentFrame = self.chatContent.frame;
    if (chatContentFrame.origin.y < 0) {
        if ((chatContentFrame.origin.y +  self.view.bounds.size.height * 0.3) > 0) {
            chatContentFrame.origin.y = 0;
        } else {
            chatContentFrame.origin.y += self.view.bounds.size.height * 0.3 - 88;
        }
    }
    self.chatContent.frame = chatContentFrame;
    //[self.chatContent setContentOffset:CGPointMake(0, self.view.bounds.size.height * 0.9)];
}

//显示选项。
- (void)showChoices {
    self.chooseRespond.userInteractionEnabled = NO;
    [self setRespondBar];
    self.choices = [[DevilChatContent alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.7, self.view.bounds.size.width, self.view.bounds.size.height * 0.3)];
    self.choices.delegate = self;
    self.choices.dataSource = self;
    self.choices.estimatedRowHeight = 60;
    self.choices.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.choices];
}

- (void)removeChoicesView {
    if (self.choices != nil) {
        [self.choices removeFromSuperview];
    }
}

//发送消息
- (void)sendMessage {
    self.isDevil = NO;
    self.nodeNumber += 1;
    [self recoverRespondBar];
    self.cellHeight = 0;
    [self.chatContent reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self devilRespond];
    });
}

//恶魔的回复
- (void)devilRespond {
    self.isDevil = YES;
    self.nodeNumber += 1;
    self.cellHeight = 0;
    [self.chatContent reloadData];
    self.chooseRespond.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.chatContent) {
        return self.nodeNumber;
    } else if (tableView == self.choices) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chatContent) {
        return 1;
    } else if (tableView == self.choices) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//
//    cell.textLabel.text = @"222";
//    return cell;
    if (tableView == self.chatContent) {
        CGRect frame = [self.chatContent rectForRowAtIndexPath:indexPath];
        self.cellHeight += frame.size.height;
        //static NSString *baseChat = @"baseChat";
        BaseChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseChat"];
        if(cell == nil){
            cell = [[BaseChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"baseChat" devil:self.isDevil];
        }
        return cell;
    } else if (tableView == self.choices) {
        CGRect frame = [self.chatContent rectForRowAtIndexPath:indexPath];
        self.cellHeight += frame.size.height;
        static NSString *choice = @"choice";
        BaseChoice *cell = [tableView dequeueReusableCellWithIdentifier:choice];
        if(cell == nil){
            cell = [[BaseChoice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:choice];
        }
        return cell;
    }
    return nil;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choices) {
        [self sendMessage];
    }
}



@end
