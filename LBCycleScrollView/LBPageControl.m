//
//  LBPageControl.m
//  LBCycleScrollViewDemo
//
//  Created by iLB on 2017/3/20.
//  Copyright © 2017年 iLB. All rights reserved.
//

#import "LBPageControl.h"

const CGFloat LBPageControlIndicatorWidth = 8;
const CGFloat LBPageControlIndicatorHeight = 8;
const CGFloat LBPageControlIndicatorSpacing = 8;

@interface LBPageControl ()

// container view
@property (nonatomic, strong) UIView *containerView;
// previous page
@property (nonatomic) NSInteger previousPage;
// page indicator width
@property (nonatomic) CGFloat pageIndicatorWidth;
// page indicator height
@property (nonatomic) CGFloat pageIndicatorHeight;
// current page indicator width
@property (nonatomic) CGFloat currentPageIndicatorWidth;
// current page indicator height
@property (nonatomic) CGFloat currentPageIndicatorHeight;
// normal page indicator size not equal current page indicator size
@property (nonatomic) BOOL pageIndicatorSizeNotSame;

@end

@implementation LBPageControl

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

#pragma mark - Overide

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.hidesForSinglePage && self.numberOfPages == 1) {
        return;
    }
    
    for (int i = 0; i < self.numberOfPages; i++) {
        CGRect imageViewFrame = [self frameOfPageIndicatorWithIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        imageView.tag = i;
        [self.containerView addSubview:imageView];
        
        imageView.backgroundColor = i == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
        imageView.image = i == self.currentPage ? self.currentPageIndicatorImage : self.pageIndicatorImage;
    }
    
    CGSize minSize = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat containerViewX = (self.frame.size.width - minSize.width) / 2;
    if (containerViewX < 0) {
        containerViewX = 0;
    }
    CGFloat containerViewY = (self.frame.size.height - minSize.height) / 2;
    if (containerViewY < 0) {
        containerViewY = 0;
    }
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, minSize.width, minSize.height);
}

#pragma mark - Private

/**
 Initial value
 */
- (void)setupViewAndInitialValue {
    
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    self.pageControlDirection = LBPageControlDirectionHorizontal;
    self.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageIndicatorWidth = LBPageControlIndicatorWidth;
    self.pageIndicatorHeight = LBPageControlIndicatorHeight;
    self.currentPageIndicatorWidth = LBPageControlIndicatorWidth;
    self.currentPageIndicatorHeight = LBPageControlIndicatorHeight;
    self.pageIndicatorSpacing = LBPageControlIndicatorSpacing;
}

/**
 The size of page indicator

 @param index  the index of page indicator
 @return       size
 */
- (CGSize)sizeOfPageIndicatorWithIndex:(NSInteger)index {
    
    if (index == self.currentPage) {
        return CGSizeMake(self.currentPageIndicatorWidth, self.currentPageIndicatorHeight);
    } else {
        return CGSizeMake(self.pageIndicatorWidth, self.pageIndicatorHeight);
    }
}

/**
 The frame of page indicator
 
 @param index  the index of page indicator
 @return       frame
 */
- (CGRect)frameOfPageIndicatorWithIndex:(NSInteger)index {
    
    CGSize minSize = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat previousMaxX = 0;
    CGFloat previousMaxY = 0;
    for (int i = 0; i <= index; i++) {
        CGSize imageViewSize = [self sizeOfPageIndicatorWithIndex:i];
        if (self.pageControlDirection == LBPageControlDirectionHorizontal) {
            if (i == 0) {
                X = 0;
            } else {
                X = previousMaxX + self.pageIndicatorSpacing;
            }
            Y = (minSize.height - imageViewSize.height) / 2;
            previousMaxX = X + imageViewSize.width;
        } else {
            if (i == 0) {
                Y = 0;
            } else {
                Y = previousMaxY + self.pageIndicatorSpacing;
            }
            X = (minSize.width - imageViewSize.width) / 2;
            previousMaxY = Y + imageViewSize.height;
        }
    }
    CGSize imageViewSize = [self sizeOfPageIndicatorWithIndex:index];
    return CGRectMake(X, Y, imageViewSize.width, imageViewSize.height);
}

#pragma mark - Public

- (void)updateCurrentPageDisplay {
    
    UIImageView *currentImageView;
    UIImageView *previousImageView;
    for (UIImageView *view in self.containerView.subviews) {
        if (view.tag == self.currentPage) {
            currentImageView = view;
        } else if (view.tag == self.previousPage) {
            previousImageView = view;
        }
    }
    
    if (self.pageIndicatorSizeNotSame) {
        if ((self.currentPage == self.numberOfPages - 1 && self.previousPage == 0) ||
            (self.currentPage == 0 && self.previousPage == self.numberOfPages - 1)) {
            for (int i = 0; i < self.numberOfPages; i++) {
                UIImageView *view = [self.containerView viewWithTag:i];
                view.frame = [self frameOfPageIndicatorWithIndex:i];
            }
        } else {
            currentImageView.frame = [self frameOfPageIndicatorWithIndex:self.currentPage];
            previousImageView.frame = [self frameOfPageIndicatorWithIndex:self.previousPage];
        }
    }
    
    currentImageView.backgroundColor = self.currentPageIndicatorTintColor;
    currentImageView.image = self.currentPageIndicatorImage;
    previousImageView.backgroundColor = self.pageIndicatorTintColor;
    previousImageView.image = self.pageIndicatorImage;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (self.pageControlDirection == LBPageControlDirectionHorizontal) {
        width = (self.pageIndicatorWidth + self.pageIndicatorSpacing) * (self.numberOfPages - 1) +
        self.currentPageIndicatorWidth;
        height = self.currentPageIndicatorHeight >= self.pageIndicatorHeight ? self.currentPageIndicatorHeight : self.pageIndicatorHeight;
    } else {
        width = self.currentPageIndicatorWidth >= self.pageIndicatorWidth ? self.currentPageIndicatorWidth : self.pageIndicatorWidth;
        height = (self.pageIndicatorHeight + self.pageIndicatorSpacing) * (self.numberOfPages - 1) +
        self.currentPageIndicatorHeight;
    }
    
    return CGSizeMake(width, height);
}

#pragma mark - Setter/Getter

- (void)setCurrentPage:(NSInteger)currentPage {
    
    if (_currentPage != currentPage) {
        self.previousPage = _currentPage;
        _currentPage = currentPage;
        
        if (!self.defersCurrentPageDisplay) {
            [self updateCurrentPageDisplay];
        }
    }
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    
    _pageIndicatorImage = pageIndicatorImage;
    
    if (_pageIndicatorImage) {
        self.pageIndicatorTintColor = [UIColor clearColor];
        self.pageIndicatorWidth = _pageIndicatorImage.size.width;
        self.pageIndicatorHeight = _pageIndicatorImage.size.height;
        
        if (self.pageIndicatorWidth != self.currentPageIndicatorWidth ||
            self.pageIndicatorHeight != self.currentPageIndicatorHeight) {
            self.pageIndicatorSizeNotSame = YES;
        } else {
            self.pageIndicatorSizeNotSame = NO;
        }
    }
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    
    _currentPageIndicatorImage = currentPageIndicatorImage;
    
    if (_currentPageIndicatorImage) {
        self.currentPageIndicatorTintColor = [UIColor clearColor];
        self.currentPageIndicatorWidth = _currentPageIndicatorImage.size.width;
        self.currentPageIndicatorHeight = _currentPageIndicatorImage.size.height;
        
        if (self.pageIndicatorWidth != self.currentPageIndicatorWidth ||
            self.pageIndicatorHeight != self.currentPageIndicatorHeight) {
            self.pageIndicatorSizeNotSame = YES;
        } else {
            self.pageIndicatorSizeNotSame = NO;
        }
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    
#if DEBUG
    NSLog(@"LBPageControl dealloc");
#endif
}

@end
