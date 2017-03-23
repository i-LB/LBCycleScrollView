//
//  DemoCollectionViewCell_One.m
//  LBCycleScrollViewDemo
//
//  Created by iLB on 2017/3/20.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import "DemoCollectionViewCell_One.h"
#import "DemoModel.h"

@interface DemoCollectionViewCell_One ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation DemoCollectionViewCell_One

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        
        CGFloat labelX = 10.f;
        CGFloat labelH = 30.f;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, frame.size.height - labelH, frame.size.width - labelX * 2, labelH)];
        self.label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)assignmentValueToView {
    
    if ([self.cellItem isKindOfClass:[DemoModel class]]) {
        DemoModel *model = (DemoModel *)self.cellItem;
        self.imageView.image = model.image;
        self.label.text = model.string;
    }
}

@end
