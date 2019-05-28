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

@interface LBCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

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
    
    LBCycleScrollView *view = [self alloc];
    view.cycleScrollEnabled = YES;
    view.cellCls = [cls isSubclassOfClass:[UICollectionViewCell class]] ? cls : [UICollectionViewCell class];
    view = [view initWithFrame:frame];
    return view;
}

+ (LBCycleScrollView *)nonCycleScrollViewWithFrame:(CGRect)frame cellClass:(Class)cls {
    
    LBCycleScrollView *view = [self alloc];
    view.cycleScrollEnabled = NO;
    view.cellCls = [cls isSubclassOfClass:[UICollectionViewCell class]] ? cls : [UICollectionViewCell class];
    view = [view initWithFrame:frame];
    return view;
}

- (instancetype)init {
    
    if (self == [super init]) {
        [self setupViewAndInitialValue];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self setupViewAndInitialValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self == [super initWithCoder:aDecoder]) {
        [self setupViewAndInitialValue];
    }
    return self;
}

- (void)layoutSubviews {

    _collectionView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    [self reloadData];
}

#pragma mark - Private

- (void)setupViewAndInitialValue {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:_cellCls ? _cellCls : [UICollectionViewCell class]
            forCellWithReuseIdentifier:LBCycleScrollViewCellIdentifier];
    [self addSubview:_collectionView];
    
    _timingScrollEnabled = YES;
    _manualScrollEnabled = YES;
    _scrollTimeInterval = LBCycleScrollViewTimeInterval;
    _pageControlLeftOrRightMargin = LBCycleScrollViewPageControlLeftRightMargin;
    _pageControlTopOrBottomMargin = LBCycleScrollViewPageControlTopBottomMargin;
    _pageControlAlignment = LBCycleScrollViewPageControlAlignmentLeft | LBCycleScrollViewPageControlAlignmentBottom;
    self.scrollDirection = LBCycleScrollViewScrollDirectionHorizontal;
}

/**
 Start cycle scroll timer
 */
- (void)startCycleScrollTimer {
    
    [self stopCycleScrollTimer];
    
    if (!_timingScrollEnabled) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimeInterval target:self selector:@selector(startCycleScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 Stop cycle scroll timer
 */
- (void)stopCycleScrollTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 Start cycle scroll
 */
- (void)startCycleScroll {
    
    if (_scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        if (!_cycleScrollEnabled && (_currentIndex + 1 == _itemArray.count)) {
            [_collectionView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
        } else {
            [_collectionView setContentOffset:CGPointMake((_currentIndex + 1) * _collectionView.frame.size.width, 0.f) animated:YES];
        }
    } else {
        if (!_cycleScrollEnabled && (_currentIndex + 1 == _itemArray.count)) {
            [_collectionView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
        } else {
            [_collectionView setContentOffset:CGPointMake(0.f, (_currentIndex + 1) * _collectionView.frame.size.height) animated:YES];
        }
    }
}

/**
 Reset page control frame
 */
- (void)resetPageControlFrame {
    
    if (!_pageControl) {
        return;
    }
    
    CGSize controlSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    
    CGFloat controlX = 0;
    CGFloat controlY = 0;

    if (_pageControlAlignment & LBCycleScrollViewPageControlAlignmentTop) {
        controlY = _pageControlTopOrBottomMargin;
    }
    if (_pageControlAlignment & LBCycleScrollViewPageControlAlignmentBottom) {
        controlY = self.frame.size.height - controlSize.height - _pageControlTopOrBottomMargin;
    }
    if (_pageControlAlignment & LBCycleScrollViewPageControlAlignmentLeft) {
        controlX = _pageControlLeftOrRightMargin;
    }
    if (_pageControlAlignment & LBCycleScrollViewPageControlAlignmentRight) {
        controlX = self.frame.size.width - controlSize.width - _pageControlLeftOrRightMargin;
    }
    if (_pageControlAlignment & LBCycleScrollViewPageControlAlignmentCenter) {
        if (_pageControl.pageControlDirection == LBPageControlDirectionHorizontal) {
            controlX = (self.frame.size.width - controlSize.width) / 2;
        } else {
            controlY = (self.frame.size.height - controlSize.height) / 2;
        }
    }

    _pageControl.frame = CGRectMake(controlX, controlY, controlSize.width, controlSize.height);
}

#pragma mark - Public

- (void)reloadData {
    
    if (_itemArray.count == 0 ||
        _collectionView.frame.size.width == 0 ||
        _collectionView.frame.size.height == 0) {
        return;
    }
    
    _pageControl.numberOfPages = _itemArray.count;
    [self resetPageControlFrame];
    [self stopCycleScrollTimer];
    
    if (_cycleScrollEnabled) {
        _totalItemsCount = _itemArray.count <= 1 ? _itemArray.count : 2 * _itemArray.count;
        [_collectionView reloadData];
        
        if (_totalItemsCount > 1) {
            // scroll to the middle of the view
            if (_scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
                [_collectionView setContentOffset:CGPointMake((_totalItemsCount / 2 + _selectedIndex) * _collectionView.frame.size.width, 0.f) animated:NO];
            } else {
                [_collectionView setContentOffset:CGPointMake(0.f, (_totalItemsCount / 2 + _selectedIndex) * _collectionView.frame.size.height) animated:NO];
            }
            _pageControl.currentPage = _currentIndex % _itemArray.count;
            [self startCycleScrollTimer];
        }
    } else {
        _totalItemsCount = _itemArray.count;
        [_collectionView reloadData];
        
        if (_totalItemsCount > 1) {
            [self startCycleScrollTimer];
        }
    }
}

#pragma mark - Setter/Getter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    [self reloadData];
}

- (void)setCellCls:(Class)cellCls {
    
    _cellCls = [cellCls isSubclassOfClass:[UICollectionViewCell class]] ? cellCls : [UICollectionViewCell class];
    [_collectionView registerClass:_cellCls ? _cellCls : [UICollectionViewCell class]
        forCellWithReuseIdentifier:LBCycleScrollViewCellIdentifier];
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
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    if (_scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    } else {
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    [_collectionView setCollectionViewLayout:layout animated:NO];
}

- (void)setManualScrollEnabled:(BOOL)manualScrollEnabled {
    
    _manualScrollEnabled = manualScrollEnabled;
    
    _collectionView.scrollEnabled = _manualScrollEnabled;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LBCycleScrollViewCellIdentifier forIndexPath:indexPath];
    [cell setCellItem:_itemArray[indexPath.row % _itemArray.count]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectItemAtIndex:_currentIndex % _itemArray.count];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_totalItemsCount <= 1) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat pageHeight = scrollView.frame.size.height;
    if (_scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {
        _currentIndex = (scrollView.contentOffset.x + pageWidth * 0.5) / pageWidth;
    } else {
        _currentIndex = (scrollView.contentOffset.y + pageHeight * 0.5) / pageHeight;
    }
    
    _selectedIndex = _currentIndex % _itemArray.count;
    _pageControl.currentPage = _selectedIndex;
    
    if (_cycleScrollEnabled) {
        if (_currentIndex == 0) {
            if (scrollView.contentOffset.x <= 0 &&
                _scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {  // has scroll to the first cell
                // scroll to the middle of the collection view
                [_collectionView setContentOffset:CGPointMake(_totalItemsCount / 2 * pageWidth, 0.f) animated:NO];
            } else if (scrollView.contentOffset.y <= 0 &&
                       _scrollDirection == LBCycleScrollViewScrollDirectionVertical) {  // has scroll to the first cell
                // scroll to the middle of the collection view
                [_collectionView setContentOffset:CGPointMake(0.f, _totalItemsCount / 2 * pageHeight) animated:NO];
            }
        } else if (_currentIndex == _totalItemsCount - 1) {
            if (_currentIndex * pageWidth <= scrollView.contentOffset.x &&
                _scrollDirection == LBCycleScrollViewScrollDirectionHorizontal) {  // has scroll to the last cell
                // scroll to the cell in front of the middle of the collection view
                [_collectionView setContentOffset:CGPointMake((_totalItemsCount / 2 - 1) * pageWidth, 0.f) animated:NO];
            } else if (_currentIndex * pageHeight <= scrollView.contentOffset.y &&
                       _scrollDirection == LBCycleScrollViewScrollDirectionVertical) {  // has scroll to the last cell
                // scroll to the cell in front of the middle of the collection view
                [_collectionView setContentOffset:CGPointMake(0.f, (_totalItemsCount / 2 - 1) * pageHeight) animated:NO];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopCycleScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_totalItemsCount > 1) {
        [self startCycleScrollTimer];
    }
}

#pragma mark - Overide

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    _collectionView.backgroundColor = backgroundColor;
}

- (void)dealloc {
    
    [self stopCycleScrollTimer];
    
#if DEBUG
    NSLog(@"LBCycleScrollView dealloc");
#endif
}

@end
