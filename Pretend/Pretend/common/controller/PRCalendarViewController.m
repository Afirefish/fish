//
//  PRCalendarViewController.m
//  Pretend
//
//  Created by xijia dai on 2019/4/23.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import <Masonry.h>

#import "PRCalendarViewController.h"
#import "PRCalendarHeaderView.h"
#import "PRCalendarCell.h"

static NSString *cellIdentifier = @"kCellIdentifier";

@interface PRCalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) PRCalendarHeaderView *calendarHeaderView;
@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSInteger firstDayOffMonthOffset;
@property (nonatomic) NSInteger totalDayOfCurrentMonth;

@end

@implementation PRCalendarViewController

- (instancetype)init {
    if (self = [super init]) {
        [self updateCurrentCalendarWithDate:[NSDate date]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeCalendarView];
}

- (void)makeCalendarView {
    self.calendarHeaderView = [[PRCalendarHeaderView alloc] initWithItems:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
    [self.calendarHeaderView setTitleColor:[UIColor redColor] forSegmentAtIndex:@[@0, @6]];
    [self.calendarHeaderView setTitleColor:[UIColor grayColor] forSegmentAtIndex:@[@1, @2, @3, @4, @5]];
    [self.view addSubview:self.calendarHeaderView];
    [self.calendarHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20.0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40.0);
    }];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 7.0;
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.itemSize = CGSizeMake(width, 75.0);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.allowsSelection = NO;
        collectionView.accessibilityLabel = @"collectionView";
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = YES;
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.alwaysBounceVertical = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[PRCalendarCell class] forCellWithReuseIdentifier:cellIdentifier];
        collectionView;
    });
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.calendarHeaderView.mas_bottom);
    }];
}

- (void)updateCurrentCalendarWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger location = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSLog(@"NSCalendar date %td %td %td %td", range.location, range.length, location, weekday);
    NSInteger weekdayOfFirstday = location % 7 - weekday;
    self.firstDayOffMonthOffset = weekdayOfFirstday;
    self.totalDayOfCurrentMonth = range.length;
}

- (NSCalendar *)calendar {
    return _calendar ?: (_calendar = ({
        NSCalendar *cal = [NSCalendar currentCalendar];
        cal;
    }));
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6 * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PRCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger number = indexPath.row + 1 - self.firstDayOffMonthOffset;
    BOOL enable = YES;
    if (number < 0) {
        number = 31 + number;
        enable = NO;
    }
    else if (number > self.totalDayOfCurrentMonth) {
        number -= self.totalDayOfCurrentMonth;
        enable = NO;
    }
    [cell updateNumber:number enable:enable];
    return cell;
}

@end
