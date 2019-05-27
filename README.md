LBCycleScrollView
==============

Cycle scroll view for iOS. Use Objective-C.

![LBCycleScrollView](https://github.com/i-LB/LBResources/blob/master/LBCycleScrollView.gif)

Usage
==============

### Cycle scroll view with custom page control

    LBPageControl *control1 = [[LBPageControl alloc] init];
    control1.pageIndicatorImage = [UIImage imageNamed:@"control1"];
    control1.currentPageIndicatorImage = [UIImage imageNamed:@"control2"];
    
    LBCycleScrollView *scrollView1 = [LBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 200.f) cellClass:[DemoCollectionViewCell_One class]];
    scrollView1.delegate = self;
    scrollView1.pageControl = control1;
    scrollView1.pageControlAlignment = LBCycleScrollViewPageControlAlignmentRight | LBCycleScrollViewPageControlAlignmentBottom;
    [self.view addSubview:scrollView1];
    
    DemoModel *model1 = [DemoModel new];
    model1.image = [UIImage imageNamed:@"img1"];
    model1.string = @"Bei Jing";
    
    DemoModel *model2 = [DemoModel new];
    model2.image = [UIImage imageNamed:@"img2"];
    model2.string = @"Hong Kong";
    
    DemoModel *model3 = [DemoModel new];
    model3.image = [UIImage imageNamed:@"img3"];
    model3.string = @"New York";
    
    DemoModel *model4 = [DemoModel new];
    model4.image = [UIImage imageNamed:@"img4"];
    model4.string = @"Paris";
    
    scrollView1.itemArray = @[model1, model2, model3, model4];
    [scrollView1 reloadData];
    
### Cycle scroll view with custom vertical page control

    LBPageControl *control2 = [[LBPageControl alloc] init];
    control2.pageControlDirection = LBPageControlDirectionVertical;
    
    LBCycleScrollView *scrollView2 = [LBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.f, 210.f, self.view.frame.size.width, 100.f) cellClass:[DemoCollectionViewCell_Two class]];
    scrollView2.delegate = self;
    scrollView2.scrollTimeInterval = 4.f;
    scrollView2.pageControlAlignment = LBCycleScrollViewPageControlAlignmentCenter | LBCycleScrollViewPageControlAlignmentLeft;
    scrollView2.scrollDirection = LBCycleScrollViewScrollDirectionVertical;
    scrollView2.pageControl = control2;
    [self.view addSubview:scrollView2];
    
    scrollView2.itemArray = @[UIColorFromRGB(0xFF8EAD), UIColorFromRGB(0xD18FFE), UIColorFromRGB(0xF6F87E)];
    [scrollView2 reloadData];
    
### None cycle scroll view with custom page control

    LBPageControl *control3 = [[LBPageControl alloc] init];
    control3.currentPageIndicatorImage = [UIImage imageNamed:@"control3"];
    
    LBCycleScrollView *scrollView3 = [LBCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.f, 320.f, self.view.frame.size.width, 200.f) cellClass:[DemoCollectionViewCell_One class]];
    scrollView3.delegate = self;
    scrollView3.scrollTimeInterval = 3.f;
    scrollView3.cycleScrollEnabled = NO;
    scrollView3.pageControlAlignment = LBCycleScrollViewPageControlAlignmentCenter | LBCycleScrollViewPageControlAlignmentTop;
    scrollView3.pageControl = control3;
    [self.view addSubview:scrollView3];
    
    DemoModel *model5 = [DemoModel new];
    model5.image = [UIImage imageNamed:@"img5"];
    
    DemoModel *model6 = [DemoModel new];
    model6.image = [UIImage imageNamed:@"img6"];
    
    DemoModel *model7 = [DemoModel new];
    model7.image = [UIImage imageNamed:@"img7"];
    
    scrollView3.itemArray = @[model5, model6, model7];
    [scrollView3 reloadData];
    
### None timing scrolling cycle scroll view with custom page control

    LBPageControl *control4 = [[LBPageControl alloc] init];
    control4.pageIndicatorSpacing = 15.f;
    control4.pageIndicatorTintColor = [UIColor whiteColor];
    control4.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    LBCycleScrollView *scrollView4 = [LBCycleScrollView new];
    scrollView4.frame = CGRectMake(0.f, 530.f, self.view.frame.size.width, 100.f);
    scrollView4.cellCls = [DemoCollectionViewCell_Two class];
    scrollView4.delegate = self;
    scrollView4.timingScrollingEnabled = NO;
    scrollView4.pageControlAlignment = LBCycleScrollViewPageControlAlignmentBottom | LBCycleScrollViewPageControlAlignmentLeft;
    scrollView4.pageControl = control4;
    [self.view addSubview:scrollView4];
    
    scrollView4.itemArray = @[UIColorFromRGB(0xBABABA), UIColorFromRGB(0xAB82FF), UIColorFromRGB(0xFFDEAD), UIColorFromRGB(0xD1EEEE), UIColorFromRGB(0x87CEFF)];
    [scrollView4 reloadData];
    
### Download the demo project and read more.

Installation
==============

### CocoaPods

Add pod 'LBCycleScrollView' to your Podfile.
Run pod install or pod update.

### Manually

Download all the files in the LBCycleScrollView subdirectory.
Add the source files to your Xcode project.

Requirements
==============

This library requires iOS 8.0+ and Xcode 7.0+.

License
==============

LBCycleScrollView is provided under the MIT license. See LICENSE file for details.
