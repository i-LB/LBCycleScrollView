//
//  LBCycleScrollView.m
//  LBCycleScrollView
//
//  Created by iLB on 2017/3/16.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import "LBCycleScrollView.h"
#import "UICollectionViewCell+LBCycleScrollView.h"

const CGFloat LBCycleScrollViewTimeInterval = 5;
const CGFloat LBCycleScrollViewPageControlTopBottomMargin = 10;
const CGFloat LBCycleScrollViewPageControlLeftRightMargin = 10;

NSString *const LBCycleScrollViewCellIdentifier = @"LBCycleScrollViewCellIdentifier";

@interface LBCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;
// current visual cell index
@property (nonatomic) NSUInteger currentIndex;
// if cycle scroll is enabled, totalItemsCount is double of itemArray count
// if cycle scroll is not enabled, totalItemsCount is equal itemArray count
@property (nonatomic) NSUInteger totalItemsCount;

@end

@implementation LBCycleScrollView

+ (LBCycleScrollView *)cycleScrollViewWithFrame:(CGRect)frame cellClass:(Class)cls {
    
    LBCycleScrollView *view = [[self alloc] initWithFrame:frame];
    view.cycleScrollEnabled = YES;
    view.cellCls = [cls isSubclassOfClass:[UICollectionViewCell class]] ? cls : [UICollectionViewCell class];
    view = [view initWithFrame:frame];
    return view;
}

+ (LBCycleScrollView *)nonCycleScrollViewWithFrame:(CGRect)frame cellClass:(Class)cls {
    
    LBCycleScrollView *view = [[self alloc] initWithFrame:frame];
    view.cycleScrollEnabled = NO;
    view.cellCls = [cls isSubclassOfClass:[UICollectionViewCell class]] ? cls : [UICollectionViewCell class];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self setupViewAndInitialValue];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupViewAndInitialValue];
}

#pragma mark - Private

- (void)setupViewAndInitialValue {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:self.cellCls ? self.cellCls : [UICollectionViewCell class]
            forCellWithReuseIdentifier:LBCycleScrollViewCellIdentifier];
    [self addSubview:self.collectionView];
    
    self.cycleScrollEnabled = YES;
    self.timingScrollingEnabled = YES;
    self.scrollTimeInterval = LBCycleScrollViewTimeInterval;
    self.pageControlLeftOrRightMargin = LBCycleScrollViewPageControlLeftRightMargin;
    self.pageControlTopOrBottomMargin = LBCycleScrollViewPageControlTopBottomMargin;
    self.scrollDirection = LBCycleScrollViewScrollDirectionHorizontal;
    self.pageControlAlignment = LBCycleScrollViewPageControlAlignmentLeft | LBCycleScrollViewPageControlAlignmentBottom;
}

/**
 Start cycle scroll timer
 */
- (void)startCycleScrollTimer {
    
    [self stopCycleScrollTimer];
    
    if (!self.timingScrollingEnabled) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(startCycleScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 Stop cycle scroll timer
 */
- (void)stopCycleScrollTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 Start cycle scroll
 */
- (void)startCycleScroll {
    
    if (self.scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        if (!self.isCycleScrollEnabled && (self.currentIndex + 1 == self.itemArray.count)) {
            [self.collectionView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
        } else {
            [self.collectionView setContentOffset:CGPointMake((self.currentIndex + 1) * self.collectionView.frame.size.width, 0.f) animated:YES];
        }
    } else {
        if (!self.isCycleScrollEnabled && (self.currentIndex + 1 == self.itemArray.count)) {
            [self.collectionView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
        } else {
            [self.collectionView setContentOffset:CGPointMake(0.f, (self.currentIndex + 1) * self.collectionView.frame.size.height) animated:YES];
        }
    }
}

/**
 Reset page control frame
 */
- (void)resetPageControlFrame {
    
    if (!self.pageControl) {
        return;
    }
    
    CGSize controlSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    
    CGFloat controlX = 0;
    CGFloat controlY = 0;

    if (self.pageControlAlignment & LBCycleScrollViewPageControlAlignmentTop) {
        controlY = self.pageControlTopOrBottomMargin;
    }
    if (self.pageControlAlignment & LBCycleScrollViewPageControlAlignmentBottom) {
        controlY = self.frame.size.height - controlSize.height - self.pageControlTopOrBottomMargin;
    }
    if (self.pageControlAlignment & LBCycleScrollViewPageControlAlignmentLeft) {
        controlX = self.pageControlLeftOrRightMargin;
    }
    if (self.pageControlAlignment & LBCycleScrollViewPageControlAlignmentRight) {
        controlX = self.frame.size.width - controlSize.width - self.pageControlLeftOrRightMargin;
    }
    if (self.pageControlAlignment & LBCycleScrollViewPageControlAlignmentCenter) {
        if (self.pageControl.pageControlDirection == LBPageControlDirectionHorizontal) {
            controlX = (self.frame.size.width - controlSize.width) / 2;
        } else {
            controlY = (self.frame.size.height - controlSize.height) / 2;
        }
    }

    self.pageControl.frame = CGRectMake(controlX, controlY, controlSize.width, controlSize.height);
}

#pragma mark - Public

- (void)reloadData {
    
    self.pageControl.numberOfPages = self.itemArray.count;
    [self resetPageControlFrame];
    
    if (self.isCycleScrollEnabled) {
        self.totalItemsCount = self.itemArray.count <= 1 ? self.itemArray.count : 2 * self.itemArray.count;
        [self.collectionView reloadData];
        
        if (self.totalItemsCount > 1) {
            // scroll to the center of the middle view
            if (self.scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
                [self.collectionView setContentOffset:CGPointMake(self.totalItemsCount / 2 * self.collectionView.frame.size.width, 0.f) animated:NO];
            } else {
                [self.collectionView setContentOffset:CGPointMake(0.f, self.totalItemsCount / 2 * self.collectionView.frame.size.height) animated:NO];
            }
            self.pageControl.currentPage = self.currentIndex % self.itemArray.count;
            [self startCycleScrollTimer];
        }
    } else {
        self.totalItemsCount = self.itemArray.count;
        [self.collectionView reloadData];
        
        if (self.totalItemsCount > 1) {
            [self startCycleScrollTimer];
        }
    }
}

#pragma mark - Setter/Getter

- (void)setCellCls:(Class)cellCls {
    
    _cellCls = [cellCls isSubclassOfClass:[UICollectionViewCell class]] ? cellCls : [UICollectionViewCell class];
}

- (void)setPageControl:(LBPageControl *)pageControl {
    
    if (pageControl != _pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
        
        _pageControl = pageControl;
        [self addSubview:_pageControl];
    }
}

- (void)setScrollDirection:(LBCycleScrollViewScrollDirection)scrollDirection {
    
    _scrollDirection = scrollDirection;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    if (_scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    } else {
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    [self.collectionView setCollectionViewLayout:layout animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LBCycleScrollViewCellIdentifier forIndexPath:indexPath];
    [cell setCellItem:self.itemArray[indexPath.row % self.itemArray.count]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:self.currentIndex % self.itemArray.count];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.totalItemsCount <= 1) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat pageHeight = scrollView.frame.size.height;
    if (self.scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        self.currentIndex = (scrollView.contentOffset.x + pageWidth * 0.5) / pageWidth;
    } else {
        self.currentIndex = (scrollView.contentOffset.y + pageHeight * 0.5) / pageHeight;
    }
    
    self.pageControl.currentPage = self.currentIndex % self.itemArray.count;
    
    if (self.isCycleScrollEnabled) {
        if (self.currentIndex == 0) {
            if (scrollView.contentOffset.x <= 0 &&
                self.scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {  // has scroll to the first cell
                // scroll to the middle of the collection view
                [self.collectionView setContentOffset:CGPointMake(self.totalItemsCount / 2 * pageWidth, 0.f) animated:NO];
            } else if (scrollView.contentOffset.y <= 0 &&
                       self.scrollDirection == LBCycleScrollViewScrollDirectionVertical) {  // has scroll to the first cell
                // scroll to the middle of the collection view
                [self.collectionView setContentOffset:CGPointMake(0.f, self.totalItemsCount / 2 * pageHeight) animated:NO];
            }
        } else if (self.currentIndex == self.totalItemsCount - 1) {
            if (self.currentIndex * pageWidth <= scrollView.contentOffset.x &&
                self.scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {  // has scroll to the last cell
                // scroll to the cell in front of the middle of the collection view
                [self.collectionView setContentOffset:CGPointMake((self.totalItemsCount / 2 - 1) * pageWidth, 0.f) animated:NO];
            } else if (self.currentIndex * pageHeight <= scrollView.contentOffset.y &&
                       self.scrollDirection == LBCycleScrollViewScrollDirectionVertical) {  // has scroll to the last cell
                // scroll to the cell in front of the middle of the collection view
                [self.collectionView setContentOffset:CGPointMake(0.f, (self.totalItemsCount / 2 - 1) * pageHeight) animated:NO];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopCycleScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.totalItemsCount > 1) {
        [self startCycleScrollTimer];
    }
}

#pragma mark - Overide

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)dealloc {
    
    [self stopCycleScrollTimer];
    
#if DEBUG
    NSLog(@"LBCycleScrollView dealloc");
#endif
}

@end
