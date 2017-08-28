//
//  LBCycleScrollView.h
//  LBCycleScrollView <https://github.com/i-LB/LBCycleScrollView>
//
//  Created by iLB on 2017/3/16.
//  Copyright © 2017年 iLB.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import "LBPageControl.h"

typedef NS_ENUM(NSUInteger, LBCycleScrollViewScrollDirection) {
    LBCycleScrollViewScrollDirectionHorizontal,
    LBCycleScrollViewScrollDirectionVertical
};

typedef NS_OPTIONS(NSUInteger, LBCycleScrollViewPageControlAlignment) {
    LBCycleScrollViewPageControlAlignmentLeft         = 1 << 0,      // visually left aligned
    LBCycleScrollViewPageControlAlignmentCenter       = 1 << 1,      // visually centered
    LBCycleScrollViewPageControlAlignmentRight        = 1 << 2,      // visually right aligned
    LBCycleScrollViewPageControlAlignmentTop          = 1 << 3,      // visually top aligned
    LBCycleScrollViewPageControlAlignmentBottom       = 1 << 4,      // visually bottom aligned
};

@class LBCycleScrollView;

@protocol LBCycleScrollViewDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (void)cycleScrollView:(LBCycleScrollView *)scrollView didSelectItemAtIndex:(NSUInteger)index;
// Called after the user changes the selection.
- (void)cycleScrollView:(LBCycleScrollView *)scrollView didSelectItem:(UICollectionViewCell *)item atIndex:(NSUInteger)index;

@end

@interface LBCycleScrollView : UIView

@property (nonatomic, weak)   id<LBCycleScrollViewDelegate> delegate;

@property (nonatomic, strong) LBPageControl *pageControl;
// data source array
@property (nonatomic, strong) NSArray *itemArray;
// the class of cell will register to the collectionView
@property (nonatomic, strong) Class cellCls;
// scroll time interval. default is 5 seconds
@property (nonatomic) CGFloat scrollTimeInterval;
// page control left margin or right margin. default is 15.f
@property (nonatomic) CGFloat pageControlLeftOrRightMargin;
// page control top margin or bottom margin. default is 0.f
@property (nonatomic) CGFloat pageControlTopOrBottomMargin;
// page control visually aligned. default is left
@property (nonatomic) LBCycleScrollViewPageControlAlignment pageControlAlignment;
// scroll direction. default is horizontal
@property (nonatomic) LBCycleScrollViewScrollDirection scrollDirection;
// cycle scroll. default is NO
@property (nonatomic, getter=isCycleScrollEnabled) BOOL cycleScrollEnabled;
// timing scrolling. default is YES
@property (nonatomic, getter=isTimingScrollEnabled) BOOL timingScrollEnabled;
// manual scroll enable. default is YES
@property (nonatomic, getter=isManualScrollEnabled) BOOL manualScrollEnabled;

/**
 Creates and returns a new instance of the LBCycleScrollView with cycle scroll function

 @param frame  view frame
 @param cls    the subclass of UICollectionViewCell will register to the collectionView
 @return       new instance of the LBCycleScrollView
 */
+ (LBCycleScrollView *)cycleScrollViewWithFrame:(CGRect)frame cellClass:(Class)cls;


/**
 Creates and returns a new instance of the LBCycleScrollView with non cycle scroll function
 
 @param frame  view frame
 @param cls    the subclass of UICollectionViewCell will register to the collectionView
 @return       new instance of the LBCycleScrollView
 */
+ (LBCycleScrollView *)nonCycleScrollViewWithFrame:(CGRect)frame cellClass:(Class)cls;

/**
 Reload data
 */
- (void)reloadData;

@end
