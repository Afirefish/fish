//
//  BaseChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatDetail.h"
#import "ChatRoomMgr.h"
#import "DevilChatContent.h"
#import "BaseChatCell.h"
#import "ChooseRespondToDevil.h"
#import "BaseChoice.h"


@interface BaseChatDetail ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseChatDetail

//初始化聊天节点数，
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatRoomMgr = [ChatRoomMgr defaultMgr];
    self.nodeNumber = 0;
    self.isDevil = NO;
    [self setSubViews];
    self.chatContent.delegate = self;
    self.chatContent.dataSource = self;
    [self.view addSubview:self.chatContent];
    [self.view addSubview:self.chooseContent];
    [self.chooseContent.chooseRespond addTarget:self action:@selector(showChoices) forControlEvents:UIControlEventTouchUpInside];
    self.choices.delegate = self;
    self.choices.dataSource = self;
    [self.view addSubview:self.choices];
}

//设置子视图
- (void)setSubViews {
    self.chatContent = [[DevilChatContent alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.9) style:UITableViewStylePlain];
    self.chooseContent = [[ChooseRespondToDevil alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.9, self.view.bounds.size.width, self.view.bounds.size.height * 0.1)];
    self.choices = [[DevilChatContent alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height * 0.3)];
}

//滚动到底部
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger section = [self.chatContent numberOfSections];
    if (section<1) return;  //无数据时不执行 要不会crash
    NSInteger row = [self.chatContent numberOfRowsInSection:section-1];
    if (row<1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row-1 inSection:section-1];  //取最后一行数据
    [self.chatContent scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

//设置respond bar选中之后的变化
- (void)setRespondBar {
    //之前以为要重绘，发现原来只要修改frame就可以
    CGRect chooseContentFrame= self.chooseContent.frame;
    chooseContentFrame.origin.y = self.view.bounds.size.height * 0.6;
    self.chooseContent.frame = chooseContentFrame;
    CGRect chatContentFrame = self.chatContent.frame;
    chatContentFrame.size.height = self.view.bounds.size.height * 0.6;
    self.chatContent.frame = chatContentFrame;
    [self scrollTableToFoot:YES];
}

//恢复respond bar的初始状态
- (void)recoverRespondBar {
    CGRect chooseContentFrame= self.chooseContent.frame;
    chooseContentFrame.origin.y = self.view.bounds.size.height * 0.9;
    self.chooseContent.frame = chooseContentFrame;
    [self removeChoicesView];
    CGRect chatContentFrame = self.chatContent.frame;
    chatContentFrame.size.height = self.view.bounds.size.height * 0.9;
    self.chatContent.frame = chatContentFrame;
    [self scrollTableToFoot:YES];
}

//显示玩家的选项，因为数据源变更了，在显示之前重新加载一下数据
- (void)showChoices {
    self.chooseContent.chooseRespond.userInteractionEnabled = NO;
    [self.choices reloadData];
    [self setRespondBar];
    CGRect choicesFrame = self.choices.frame;
    choicesFrame.origin.y = self.view.bounds.size.height * 0.7;
    self.choices.frame = choicesFrame;
}

//隐藏玩家的选项
- (void)removeChoicesView {
    CGRect choicesFrame = self.choices.frame;
    choicesFrame.origin.y = self.view.bounds.size.height;
    self.choices.frame = choicesFrame;
}

//玩家做出选择的消息
- (void)sendMessage{
    self.isDevil = NO;
    self.nodeNumber += 1;
    [self recoverRespondBar];
    [self.chatContent reloadData];
    [self scrollTableToFoot:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{//加个延迟有种思考的感觉233
        [self devilRespond];
    });
}

//恶魔的回复
- (void)devilRespond {
    self.isDevil = YES;
    self.nodeNumber += 1;
    [self.chatContent reloadData];
    [self scrollTableToFoot:YES];
    self.chooseContent.chooseRespond.userInteractionEnabled = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//聊天记录每一个作为一个新的section，而玩家选项一个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.chatContent) {
        return self.nodeNumber;
    } else if (tableView == self.choices) {
        return 1;
    }
    return 0;
}

//聊天记录每一个section仅包括一行，玩家选项暂定为4个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chatContent) {
        return 1;
    } else if (tableView == self.choices) {
        return 4;
    }
    return 0;
}

//这里做了点特别的处理，对于聊天记录的视图，每个cell有不同的标志符，对于每个玩家选择，设置为一个标志符（后面实现的时候没有复用了）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *baseChat = [NSString stringWithFormat:@"BaseChat%ld",(long)indexPath.section];
        BaseChatCell *cell = [tableView dequeueReusableCellWithIdentifier:baseChat];
        if(cell == nil){
            cell = [[BaseChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseChat devil:self.isDevil message:self.playerChoice respond:nil];
        }
        return cell;
    } else if (tableView == self.choices) {
        static NSString *choice = @"Choice";
        BaseChoice *cell = [tableView dequeueReusableCellWithIdentifier:choice];
        if(cell == nil){
            cell = [[BaseChoice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:choice message:nil];
        }
        return cell;
        /*一些这里在之前注册tableviewcell的写法
         *[self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"MyCell"];
         *如果写了这个，那么可以不用写if(cell == nil)的判断，只需要写
         *UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];但是如果没注册
         *的话，即使加了判断cell是否为空，这么写也不行
         *但是像我写的这个UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];才能支持cell为空判断后初始化的写
         *法
         */
    }
    return nil;
}


#pragma mark Table view delegate

//玩家做出选择时，发送消息到聊天记录视图中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choices) {
        BaseChoice *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.playerChoice = cell.textLabel.text;//这里很容易被hook弄崩。。
        [self sendMessage];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma json

//解析本地的json
- (void)jsonData:(NSString *)devil {
    [self.chatRoomMgr messageJson:devil];
    self.playerMessages = self.chatRoomMgr.playerMessages;
    self.devilMessages = self.chatRoomMgr.devilMessages;
}

@end
