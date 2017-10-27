//
//  ChiziChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziChatDetail.h"
#import "ChiziMgr.h"
#import "ChiziDevilChatContent.h"
#import "ChiziChatCell.h"
#import "ChooseRespondToChizi.h"
#import "ChiziChoice.h"

#define kCellWidth 300
#define kCellGap 20

//设定为比较残忍的人，和santa很合得来，拥有最强大的近战攻击力
@interface ChiziChatDetail ()
@property (strong,nonatomic) ChiziMgr *chiziMgr;
@property (readwrite,assign,nonatomic) NSUInteger chiziFinished;//100代表结束
@property (assign,nonatomic) NSUInteger previousStep;//上一步
@property (strong,nonatomic) NSArray *choiceArr;//玩家所有选择的数组
@property (strong,nonatomic) NSDictionary *choiceDic;//玩家所有选择数组中的元素
@property (strong,nonatomic) NSString *choiceContent;//玩家选择字典中具体的信息字符串
@property (assign,nonatomic) NSUInteger choiceIndex;//玩家选择的回复的索引
@property (strong,nonatomic) NSArray *chiziArr;//chizi的回复的数组
@property (strong,nonatomic) NSDictionary *chiziDic;//chizi回复的字典
@property (strong,nonatomic) NSString *chiziRespond;//chizi的回复的信息字符串
@property (strong,nonatomic) NSMutableArray *allCellHeight;//保存聊天记录的所有视图的高度

@end

@implementation ChiziChatDetail

+ (instancetype)chiziChatDetail {
    static ChiziChatDetail *chiziChatDetail = nil;
    if (chiziChatDetail  == nil) {
        chiziChatDetail = [[ChiziChatDetail alloc] init];
        chiziChatDetail.previousStep = 1;
        chiziChatDetail.chiziFinished = 1;
    }
    return chiziChatDetail;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chiziMgr = [ChiziMgr defaultMgr];
    //self.previousStep = self.chiziMgr.previousStep;
    //self.chiziFinished = self.chiziMgr.chiziFinished;
    [self jsonData:@"chizi"];
    self.allCellHeight = [[NSMutableArray alloc] init];
}

//重写子视图设置的方法
- (void)setSubViews {
    self.chatContent = [[ChiziDevilChatContent alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.9) style:UITableViewStylePlain];
    self.chooseContent = [[ChooseRespondToChizi alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.9, self.view.bounds.size.width, self.view.bounds.size.height * 0.1)];
    self.choices = [[ChiziDevilChatContent alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height * 0.3)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////pufu恶魔通过
//- (void)setChiziFinished:(NSUInteger)chiziFinished {
//    self.chiziFinished = 100;
//}

#pragma mark - Table view data source

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *chiziChat = [NSString stringWithFormat:@"ChiziChat%ld",(long)indexPath.section];
        ChiziChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chiziChat];
        if(cell == nil){
            cell = [[ChiziChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chiziChat devil:self.isDevil message:self.playerChoice respond:self.chiziRespond];
        }
        return cell;
    } else if (tableView == self.choices) {
        for (NSDictionary *dic in self.playerMessages) {
            NSNumber *step = [dic objectForKey:@"step"];
            NSUInteger myStep = [step integerValue];
            if (myStep == self.chiziFinished) {
                self.choiceArr = [dic objectForKey:@"choice"];
                self.choiceDic = [self.choiceArr objectAtIndex:indexPath.row];
                self.choiceContent = [self.choiceDic objectForKey:@"message"];
                break;
            }
        }
        static NSString *santaChoice = @"SantaChoice";
        ChiziChoice *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell == nil){
            cell = [[ChiziChoice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChoice message:self.choiceContent];
        }
        return cell;
    }
    return nil;
}

#pragma mark Table view delegate

//玩家做出选择之后的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choices) {
        self.playerChoice = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"message"];
        NSNumber *index = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"index"];
        self.choiceIndex = [index integerValue];
        NSNumber *nextStep = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"nextStep"];
        self.previousStep = self.chiziFinished;
        [self.chiziMgr savePreviousStep:self.previousStep];
        self.chiziFinished = [nextStep integerValue];
        [self.chiziMgr saveStep:self.chiziFinished];
        [self sendMessage];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
                        self.chiziArr = [dic objectForKey:@"respond"];
                        self.chiziDic = [self.chiziArr objectAtIndex:self.choiceIndex];
                        self.chiziRespond = [self.chiziDic objectForKey:@"message"];
                        cellRect = [self.chiziRespond boundingRectWithSize:CGSizeMake(kCellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                        break;
                    }
                }
            } else {
                cellRect = [self.playerChoice boundingRectWithSize:CGSizeMake(kCellWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            }
            NSNumber *height = [NSNumber numberWithFloat:cellRect.size.height + kCellGap];
            if ([self.allCellHeight count] < self.nodeNumber) {//将正确的高度存入数组
                [self.allCellHeight addObject:height];
            }
        }
        CGFloat cellHeight = [[self.allCellHeight objectAtIndex:indexPath.section] floatValue];//每次重新加载时，除了最后的cell，高度直接从数组里获取
        return cellHeight;
    } else if (tableView == self.choices) {
        for (NSDictionary *dic in self.playerMessages) {
            NSNumber *step = [dic objectForKey:@"step"];
            NSUInteger myStep = [step integerValue];
            if (myStep == self.chiziFinished) {
                self.choiceArr = [dic objectForKey:@"choice"];
                self.choiceDic = [self.choiceArr objectAtIndex:indexPath.row];
                self.choiceContent = [self.choiceDic objectForKey:@"message"];
                cellRect = [self.choiceContent boundingRectWithSize:CGSizeMake(kCellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                break;
            }
        }
        return cellRect.size.height + kCellGap;//直接计算高度返回，因为每次的选项都不同，所以也不需要保存这些高度了，每次都不一样
    }
    return 0;
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chiziMgr saveCardInfo:card];
}

@end
