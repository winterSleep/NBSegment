//
//  NBSquareSegmentView.h
//  Fish
//
//  Created by Li Zhiping on 1/8/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBSquareSegmentView;

@protocol NBSquareSegmentViewDelegate <NSObject>

@optional

- (void)squareSegmentView:(NBSquareSegmentView *)segmentView
       didSelectedAtIndex:(NSInteger)index;

@end

@interface NBSquareSegmentItem : NSObject

@property (strong, nonatomic)NSString *title;

@end

@interface NBSquareSegmentView : UIView

//items 由 NBSegmentItem 对象组成
- (instancetype)initWithItems:(NSArray *)items;

@property (weak, nonatomic)id <NBSquareSegmentViewDelegate>delegate;

@property (assign, nonatomic)NSInteger selectedIndex;

@property (strong, nonatomic)UIColor *defaultColor;
@property (strong, nonatomic)UIColor *selectedColor;

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated;

- (void)setOffsetWithScrollViewWidth:(CGFloat)width
                    scrollViewOffset:(CGFloat)offset;

@end
