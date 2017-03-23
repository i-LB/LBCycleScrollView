//
//  DemoCollectionViewCell_Two.m
//  LBCycleScrollViewDemo
//
//  Created by iLB on 2017/3/20.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import "DemoCollectionViewCell_Two.h"

@implementation DemoCollectionViewCell_Two

- (void)assignmentValueToView {
    
    if ([self.cellItem isKindOfClass:[UIColor class]]) {
        UIColor *color = (UIColor *)self.cellItem;
        self.contentView.backgroundColor = color;
    }
}

@end
