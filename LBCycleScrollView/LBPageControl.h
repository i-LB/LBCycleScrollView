//
//  LBPageControl.h
//  LBCycleScrollViewDemo
//
//  Created by iLB on 2017/3/20.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LBPageControlDirection) {
    LBPageControlDirectionHorizontal,
    LBPageControlDirectionVertical
};

@class LBPageControl;

NS_ASSUME_NONNULL_BEGIN
@protocol LBPageControlDelegate <NSObject>

@optional
- (void)pageControl:(LBPageControl *)control currentPage:(NSInteger)page;

@end

@interface LBPageControl : UIControl

@property (nonatomic, weak) id<LBPageControlDelegate> delegate;

@property (nonatomic) NSInteger numberOfPages;          // default is 0
@property (nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property (nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property (nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO
- (void)updateCurrentPageDisplay;                      // update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;   // returns minimum size required to display dots for given page count. can be used to size control if page count could change

@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nullable, nonatomic, strong) UIImage *pageIndicatorImage;
@property (nullable, nonatomic, strong) UIImage *currentPageIndicatorImage;

@property (nonatomic) LBPageControlDirection pageControlDirection;
@property (nonatomic) CGFloat pageIndicatorSpacing;

@end
NS_ASSUME_NONNULL_END
