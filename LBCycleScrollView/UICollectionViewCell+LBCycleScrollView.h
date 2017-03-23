//
//  UICollectionViewCell+LBCycleScrollView.h
//  LBCycleScrollView
//
//  Created by iLB on 2017/3/17.
//  Copyright © 2017年 iLB. All rights reserved.
//

/**
 
 Sample Code:
 
 ******************************* ExampleCell.h *********************************
 
 #import UICollectionViewCell+LBCycleScrollView.h
 
 @interface ExampleCell : UICollectionViewCell
 
 @property (nonatomic, strong) UILabel *titleLabel;
 
 @end
 
 ******************************* ExampleCell.m *********************************
 
 #import ExampleCell.h
 #import ExampleModel.h
 
 @implementation ExampleCell
 
 - (instancetype)initWithFrame:(CGRect)frame {
 
    if (self == [super initWithFrame:frame]) {
 
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
 }

 - (void)assignmentValueToView { 
 
    if ([self.cellItem isKindOfClass:[ExampleModel class]]) {
        ExampleModel *model = (ExampleModel *)self.cellItem;
        self.titleLabel.text = model.title;
    }
 }
 
 @end
 
 */

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (LBCycleScrollView)

// the data will display in cell
@property (nonatomic, strong) id cellItem;

@end
