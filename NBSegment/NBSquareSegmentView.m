//
//  NBSquareSegmentView.m
//  Fish
//
//  Created by Li Zhiping on 1/8/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBSquareSegmentView.h"

@implementation NBSquareSegmentItem

@end

@interface NBSquareSegmentView ()

@property (strong, nonatomic)NSMutableArray *items;

@property (strong, nonatomic)NSMutableArray *buttons;

@property (assign, nonatomic)CGFloat previousOffset;

@end

@implementation NBSquareSegmentView

- (instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedIndex = NSNotFound;
        
        [self initialization];
        for (NBSquareSegmentItem *item in items) {
            [self addSegmentItem:item];
        }
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectedIndex:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithItems:nil];
}

- (void)awakeFromNib{
    [self initialization];
}

- (void)initialization{
    
    self.items = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    
    self.defaultColor = [UIColor blackColor];
    self.selectedColor = [UIColor redColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.items.count > 0) {
        //设置按钮的frame
        CGFloat buttonWidth = [self itemButtonWidth];
        CGFloat buttonLeft = 0;
        CGFloat buttonHeight = CGRectGetHeight(self.bounds);
        
        for (int i=0; i<self.buttons.count; i++) {
            UIButton *button = [self.buttons objectAtIndex:i];
            [button setFrame:CGRectMake(buttonLeft, 0, buttonWidth, buttonHeight)];
            buttonLeft += buttonWidth;
        }
    }
}

- (CGFloat)itemButtonWidth{
    return CGRectGetWidth(self.bounds)/self.items.count;
}

- (void)addSegmentItem:(NBSquareSegmentItem *)item{
    if (item) {
        [self.items addObject:item];
        UIButton *button = [self buttonWithItem:item];
        [self addSubview:button];
        [self.buttons addObject:button];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (UIButton *)buttonWithItem:(NBSquareSegmentItem *)item{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:item.title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:[self defaultFontSize]]];
    
    [button setTitleColor:self.defaultColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
    [button setTitleColor:self.selectedColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(segmentTapAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)segmentTapAction:(UIButton *)btn{
    NSInteger index = [self.buttons indexOfObject:btn];
    [self setSelectedIndex:index animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(squareSegmentView:didSelectedAtIndex:)]) {
        [self.delegate squareSegmentView:self didSelectedAtIndex:index];
    }
}

- (void)setOffsetWithScrollViewWidth:(CGFloat)width
                    scrollViewOffset:(CGFloat)offset{
    
    NSInteger currentIndex = offset/width;
    NSInteger nextIndex = 0;
    //如果是在向右滑动(即显示右侧的内容)
    if (self.previousOffset < offset) {
        nextIndex = currentIndex + 1;
    }else{
        currentIndex += 1;
        nextIndex = currentIndex - 1;
    }
    
    if (nextIndex >= 0 && nextIndex < self.items.count) {
        
        int movedDistance = (int)offset%(int)width;
        if (nextIndex < currentIndex) {
            movedDistance = fabs(width - movedDistance);
        }
        if (movedDistance != 0) {
            CGFloat totalDistance = width;
            CGFloat rate = movedDistance/totalDistance;

            //修改当前显示按钮的字体
            CGFloat fontSize = [self selectedFontSize] - ([self selectedFontSize] - [self defaultFontSize]) * (rate);
            UIButton *currentButton = [self.buttons objectAtIndex:currentIndex];
            [currentButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            
            //修改将要显示的按钮的字体
            CGFloat nextButtonFontSize = [self defaultFontSize] + ([self selectedFontSize] - [self defaultFontSize]) * rate;
            UIButton *nextButton = [self.buttons objectAtIndex:nextIndex];
            [nextButton.titleLabel setFont:[UIFont systemFontOfSize:nextButtonFontSize]];
            
            CGFloat green = 0;
            CGFloat blue = 0;
            CGFloat red = 0;
            [self.defaultColor getRed:&red green:&green blue:&blue alpha:nil];
            
            CGFloat nextBlue = 0;
            CGFloat nextGreen = 0;
            CGFloat nextRed = 0;
            [self.selectedColor getRed:&nextRed green:&nextGreen blue:&nextBlue alpha:nil];
            
            CGFloat green1 = green + (nextGreen - green)*rate;
            CGFloat blue1 = blue + (nextBlue - blue)*rate;
            CGFloat red1 = red + (nextRed - red)*rate;
            UIColor *color = [[UIColor alloc] initWithRed:red1 green:green1 blue:blue1 alpha:1];
            [nextButton setTitleColor:color forState:UIControlStateNormal];
            
            nextGreen = nextGreen + (green - nextGreen)*rate;
            nextBlue = nextBlue + (blue - nextBlue)*rate;
            nextRed = nextRed + (red - nextRed)*rate;
            color = [[UIColor alloc] initWithRed:nextRed green:nextGreen blue:nextBlue alpha:1];
            [currentButton setTitleColor:color forState:UIControlStateNormal];
        }
    }
    self.previousOffset = offset;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (CGFloat)selectedFontSize{
    return 17;
}

- (CGFloat)defaultFontSize{
    return 13;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated{
    if (selectedIndex != self.selectedIndex &&
        selectedIndex >= 0 &&
        selectedIndex < self.items.count) {
        
        UIButton *preBtn = nil;
        if (self.selectedIndex >= 0 && self.selectedIndex < self.items.count) {
            preBtn = [self.buttons objectAtIndex:self.selectedIndex];
            [preBtn setTitleColor:self.defaultColor forState:UIControlStateNormal];
        }
        
        _selectedIndex = selectedIndex;
        
        UIButton *btn = [self.buttons objectAtIndex:selectedIndex];
        [btn setTitleColor:self.selectedColor forState:UIControlStateNormal];
        
        CGFloat selectedFontSize = [self selectedFontSize];
        CGFloat defaultFontSize = [self defaultFontSize];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:selectedFontSize]];
        [preBtn.titleLabel setFont:[UIFont systemFontOfSize:defaultFontSize]];
    }
}

@end
