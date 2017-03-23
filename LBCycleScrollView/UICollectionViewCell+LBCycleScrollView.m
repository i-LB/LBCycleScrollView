//
//  UICollectionViewCell+LBCycleScrollView.m
//  LBCycleScrollView
//
//  Created by iLB on 2017/3/17.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import "UICollectionViewCell+LBCycleScrollView.h"
#import <objc/message.h>

@implementation UICollectionViewCell (LBCycleScrollView)

#pragma mark - Properties

static const char LBCycleScrollViewCellItemKey = '\0';

- (void)setCellItem:(id)cellItem {
    
    objc_setAssociatedObject(self, &LBCycleScrollViewCellItemKey,
                             cellItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self assignmentValueToView];
}

- (id)cellItem {
    
    return objc_getAssociatedObject(self, &LBCycleScrollViewCellItemKey);
}

#pragma mark - Private

/**
 the subclass must overide this method
 */
- (void)assignmentValueToView { }

@end
