//
//  BaseChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatDetail.h"
#import "ChatRoomMgr.h"
#import "BaseChatTableView.h"
#import "BaseChatTableViewCell.h"
#import "BaseChoiceCollectionView.h"
#import "BaseChoiceCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kCellGap 20

@interface BaseChatDetail ()
@end

@implementation BaseChatDetail

static NSString *choice = @"Choice";

//初始化聊天节点数，
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.chatRoomMgr = [ChatRoomMgr defaultMgr];
    self.nodeNumber = 0;
    self.isDevil = NO;
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/2 , SCREEN_HEIGHT * 0.3);
    [self setSubViews];
    //聊天内容
    self.chatContent.delegate = self;
    self.chatContent.dataSource = self;
    [self.view addSubview:self.chatContent];
    //collection view显示的视图
    self.choiceCount = 4;
    [self.choicesCollectionView registerClass:[BaseChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
    self.choicesCollectionView.delegate = self;
    self.choicesCollectionView.dataSource = self;
    self.choicesCollectionView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    [self.view addSubview:self.choicesCollectionView];
    //玩家不能选择时的视图
    self.coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
    self.coverLabel.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.coverLabel.text = @"...";
    self.coverLabel.font = [UIFont systemFontOfSize:60];
    self.coverLabel.textAlignment = NSTextAlignmentCenter;
    self.coverLabel.alpha = 0;
    [self.view addSubview:self.coverLabel];
}

//设置子视图
- (void)setSubViews {
    self.chatContent = [[BaseChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7) style:UITableViewStylePlain];
    self.choicesCollectionView = [[BaseChoiceCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) collectionViewLayout:self.layout];

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

//玩家做出选择的消息
- (void)sendMessage{
    self.isDevil = NO;
    self.choicesCollectionView.userInteractionEnabled = NO;
    self.coverLabel.alpha = 1;
    self.nodeNumber += 1;
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
    [self.choicesCollectionView reloadData];
    self.coverLabel.alpha = 0;
    self.choicesCollectionView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//聊天记录每一个作为一个新的section，而玩家选项一个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.chatContent) {
        return self.nodeNumber;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.choicesCollectionView) {
        return 1;
    }
    return 0;
}

//聊天记录每一个section仅包括一行，玩家选项定为4个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chatContent) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.choicesCollectionView) {
        return self.choiceCount;
    }
    return 0;
}

//这里做了点特别的处理，对于聊天记录的视图，每个cell有不同的标志符，对于每个玩家选择，设置为一个标志符（后面实现的时候没有复用了）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *baseChat = [NSString stringWithFormat:@"BaseChat%ld",(long)indexPath.section];
        BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseChat];
        if(cell == nil){
            cell = [[BaseChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseChat isDevil:self.isDevil message:self.playerChoice respond:nil devilName:nil];
        }
        return cell;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (NSDictionary *dic in self.playerMessages) {
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger myStep = [step integerValue];
        if (myStep == self.finished) {
            self.choiceArr = [dic objectForKey:@"choice"];
            self.choiceDic = [self.choiceArr objectAtIndex:indexPath.row];
            self.choiceContent = [self.choiceDic objectForKey:@"message"];
            break;
        }
    }
    BaseChoiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:choice forIndexPath:indexPath];
    cell.messageLabel.text = self.choiceContent;
    return cell;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.playerChoice = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"message"];
    NSNumber *index = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"index"];
    self.choiceIndex = [index integerValue];
    NSNumber *nextStep = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"nextStep"];
    self.previousStep = self.finished;
    self.finished = [nextStep integerValue];
    [self sendMessage];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//设置cell高度，根据文本行数和大小变化
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = CGRectMake(0, 0, 0, 0);
    if (tableView == self.chatContent) {
        if (indexPath.section == [tableView numberOfSections] - 1 ) {
            if (self.isDevil == YES) {
                for (NSDictionary *dic in self.devilMessages) {
                    NSNumber *step = [dic objectForKey:@"step"];
                    NSUInteger mystep = [step integerValue];
                    if (mystep == self.previousStep) {
                        self.devilArr = [dic objectForKey:@"respond"];
                        self.devilDic = [self.devilArr objectAtIndex:self.choiceIndex];
                        self.devilRespondContent = [self.devilDic objectForKey:@"message"];
                        cellRect = [self.devilRespondContent boundingRectWithSize:CGSizeMake(self.view.bounds.size.width * 0.7, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                        break;
                    }
                }
            } else {
                cellRect = [self.playerChoice boundingRectWithSize:CGSizeMake(self.view.bounds.size.width * 0.7, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            }
            NSNumber *height = [NSNumber numberWithFloat:cellRect.size.height + kCellGap];
            if ([self.allCellHeight count] < self.nodeNumber) {//将正确的高度存入数组
                [self.allCellHeight addObject:height];
            }
        }
        CGFloat cellHeight = [[self.allCellHeight objectAtIndex:indexPath.section] floatValue];//每次重新加载时，除了最后的cell，高度直接从数组里获取
        return cellHeight;
    }
    return 0;
}

#pragma json

//解析本地的json
- (void)jsonData:(NSString *)devil {
    [self.chatRoomMgr messageJson:devil];
    self.playerMessages = self.chatRoomMgr.playerMessages;
    self.devilMessages = self.chatRoomMgr.devilMessages;
}

@end
