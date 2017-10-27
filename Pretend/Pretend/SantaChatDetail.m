//
//  SantaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaChatDetail.h"
#import "SantaMgr.h"
#import "SantaDevilChatContent.h"
#import "SantaChatCell.h"
#import "ChooseRespondToSanta.h"
#import "SantaChoice.h"

#define kCellWidth 300
#define kCellGap 20

//说话语气很凶，但是实际是个很好的家伙，没有固定的居住地，偶尔会去chizi的宫殿呆着
@interface SantaChatDetail ()

@property (strong,nonatomic) SantaMgr *santaMgr;
@property (assign,nonatomic) NSUInteger previousStep;//上一步
@property (assign,nonatomic) NSUInteger santaFinished;//100代表结束
@property (strong,nonatomic) NSArray *choiceArr;//玩家所有选择的数组
@property (strong,nonatomic) NSDictionary *choiceDic;//玩家所有选择数组中的元素
@property (strong,nonatomic) NSString *choiceContent;//玩家选择字典中具体的信息字符串
@property (assign,nonatomic) NSUInteger choiceIndex;//玩家选择的回复的索引
@property (strong,nonatomic) NSArray *santaArr;//santa的回复的数组
@property (strong,nonatomic) NSDictionary *santaDic;//santa回复的字典
@property (strong,nonatomic) NSString *santaRespond;//santa的回复的信息字符串
@property (strong,nonatomic) NSMutableArray *allCellHeight;//保存聊天记录的所有视图的高度

@end

@implementation SantaChatDetail

+ (instancetype)santaChatDetail {
    static SantaChatDetail *santaChatDetail = nil;
    if (santaChatDetail == nil) {
        santaChatDetail = [[SantaChatDetail alloc] init];
        santaChatDetail.previousStep = 1;
        santaChatDetail.santaFinished = 1;
    }
    return santaChatDetail;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.santaMgr = [SantaMgr defaultMgr];
    //self.previousStep = self.santaMgr.previousStep;
    //self.santaFinished = self.santaMgr.santaFinished;
    [self jsonData:@"santa"];
    self.allCellHeight = [[NSMutableArray alloc] init];
}

//重写子视图设置的方法
- (void)setSubViews {
    self.chatContent = [[SantaDevilChatContent alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.9) style:UITableViewStylePlain];
    self.chooseContent = [[ChooseRespondToSanta alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.9, self.view.bounds.size.width, self.view.bounds.size.height * 0.1)];
    self.choices = [[SantaDevilChatContent alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height * 0.3)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////santa恶魔通过
//- (void)setSantaFinished{
//    self.santaFinished = 100;
//}

#pragma mark - Table view data source

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *santaChat = [NSString stringWithFormat:@"SantaChat%ld",(long)indexPath.section];
        SantaChatCell *cell = [tableView dequeueReusableCellWithIdentifier:santaChat];
        if(cell == nil){
            cell = [[SantaChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChat devil:self.isDevil message:self.playerChoice respond:self.santaRespond];
        }
        return cell;
    } else if (tableView == self.choices) {
        for (NSDictionary *dic in self.playerMessages) {
            NSNumber *step = [dic objectForKey:@"step"];
            NSUInteger myStep = [step integerValue];
            if (myStep == self.santaFinished) {
                self.choiceArr = [dic objectForKey:@"choice"];
                self.choiceDic = [self.choiceArr objectAtIndex:indexPath.row];
                self.choiceContent = [self.choiceDic objectForKey:@"message"];
                break;
            }
        }
        static NSString *santaChoice = @"SantaChoice";
        SantaChoice *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell == nil){
            cell = [[SantaChoice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChoice message:self.choiceContent];
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
        self.previousStep = self.santaFinished;
        [self.santaMgr savePreviousStep:self.previousStep];
        self.santaFinished = [nextStep integerValue];
        [self.santaMgr saveStep:self.santaFinished];
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
                        self.santaArr = [dic objectForKey:@"respond"];
                        self.santaDic = [self.santaArr objectAtIndex:self.choiceIndex];
                        self.santaRespond = [self.santaDic objectForKey:@"message"];
                        cellRect = [self.santaRespond boundingRectWithSize:CGSizeMake(kCellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                        break;
                    }
                }
            } else {
                cellRect = [self.playerChoice boundingRectWithSize:CGSizeMake(kCellWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
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
            if (myStep == self.santaFinished) {
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
    [self.santaMgr saveCardInfo:card];
}

@end
