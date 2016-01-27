//
//  ViewController.m
//  NBSegmentExample
//
//  Created by Li Zhiping on 1/27/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "ViewController.h"
#import "NBSquareSegmentView.h"

@interface ViewController ()<UIScrollViewDelegate, NBSquareSegmentViewDelegate>

@property (strong, nonatomic)NBSquareSegmentView *titleSegment;

@property (strong, nonatomic)UIScrollView *pagerView;
@property (strong, nonatomic)NSArray *pagedViewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    NSArray *itemTitles = @[@"标题1",@"标题2", @"标题3", @"标题4", @"标题5", @"标题6"];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i<itemTitles.count; i++) {
        NBSquareSegmentItem *item = [[NBSquareSegmentItem alloc] init];
        item.title = itemTitles[i];
        [items addObject:item];
    }
    self.titleSegment = [[NBSquareSegmentView alloc] initWithItems:items];
    [self.titleSegment setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [self topSegmentViewHeight])];
    [self.titleSegment setDelegate:self];
    [self.view addSubview:self.titleSegment];
    
    self.pagerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pagerView];
    [self.pagerView setPagingEnabled:YES];
    [self.pagerView setFrame:UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake([self topSegmentViewHeight], 0, 0, 0))];
    [self.pagerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.pagerView.bounces = NO;
    self.pagerView.scrollsToTop = NO;
    [self.pagerView setDelegate:self];
    [self.pagerView setShowsHorizontalScrollIndicator:NO];
    [self.pagerView setShowsVerticalScrollIndicator:NO];
    [self.pagerView setBackgroundColor:[UIColor redColor]];
    
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i=0; i<itemTitles.count; i++) {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        [self.pagerView addSubview:vc.view];
        [controllers addObject:vc];
        [self addChildViewController:vc];
        CGFloat r = arc4random() % 255;
        CGFloat g = arc4random() % 255;
        CGFloat b = arc4random() % 255;
        [vc.view setBackgroundColor:[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]];
    }
    self.pagedViewControllers = controllers;
}

- (CGFloat)topSegmentViewHeight{
    return 44.0f;
}

- (void)viewDidLayoutSubviews{
    CGFloat width = CGRectGetWidth(self.pagerView.frame);
    CGFloat contentWidth = width * [self.pagedViewControllers count];
    CGFloat contentHeight = CGRectGetHeight(self.pagerView.frame);
    [self.pagerView setContentSize:CGSizeMake(contentWidth, contentHeight)];
    
    for (int i=0; i<self.pagedViewControllers.count; i++) {
        UIViewController *vc = [self.pagedViewControllers objectAtIndex:i];
        CGRect frame = CGRectMake(i*width, 0, width, contentHeight);
        [vc.view setFrame:frame];
    }
    [super viewDidLayoutSubviews];
    [self.view layoutSubviews];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动过程中的操作
    [self.titleSegment setOffsetWithScrollViewWidth:CGRectGetWidth(scrollView.bounds) scrollViewOffset:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //调用 scrollToOffset 结束后的回调
    [self updateChildControllerStatus:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //滑动停止后，且之后不再自动滑动了
    if (!decelerate) {
        [self updateChildControllerStatus:scrollView];
        [self setSegmentViewSelectedIndex:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动彻底结束后的操作
    [self updateChildControllerStatus:scrollView];
    [self setSegmentViewSelectedIndex:scrollView];
}

- (void)setSegmentViewSelectedIndex:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds);
    [self.titleSegment setSelectedIndex:index animated:NO];
}

- (void)updateChildControllerStatus:(UIScrollView *)scrollView{
    //TODO: 获取数据或更新 UI
}

#pragma mark - NBSquareSegmentViewDelegate

- (void)squareSegmentView:(NBSquareSegmentView *)segmentView didSelectedAtIndex:(NSInteger)index{
    CGFloat xOffset = index * CGRectGetWidth(self.pagerView.bounds);
    [self.pagerView setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    [self updateChildControllerStatus:self.pagerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
