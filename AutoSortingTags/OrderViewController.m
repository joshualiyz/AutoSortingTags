//
//  OrderViewController.m
//  test
//
//  Created by joshuali on 15/11/17.
//  Copyright © 2015年 aixuehuisi. All rights reserved.
//

#import "OrderViewController.h"
#import "TagItem.h"
#import "TagView.h"

#define COLUM_NUM  4
#define ROW_NUM    10

@interface OrderViewController ()<TagViewTouchDelegate>
{
    CGFloat gap;
    CGFloat itemWidth;
    TagItem * curDraggingTag;
    TagItem * detectingTag;
    CGPoint startDraggingOrigin;
    NSInteger curIndex;
    NSInteger detectingIndex;
    UIScrollView * scrollView;
}
@property (nonatomic, strong) NSMutableArray * tags;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 50);
    [self.view addSubview:scrollView];
    self.tags = [NSMutableArray array];
    gap = 20;
    itemWidth = ([UIScreen mainScreen].bounds.size.width - 50 - 20 * (COLUM_NUM - 1)) / COLUM_NUM;
    for(int i = 0 ; i < ROW_NUM ; i ++){
        for(int j = 0 ; j < COLUM_NUM ; j ++){
            TagItem * tag = [TagItem new];
            CGPoint desOrigin = CGPointMake(25 + (gap + itemWidth) * j, (gap + itemWidth) * i);
            tag.center = CGPointMake(desOrigin.x + itemWidth/2, desOrigin.y + itemWidth/2);
            tag.desCenter = tag.center;
            tag.view = [[TagView alloc] initWithFrame:CGRectMake(desOrigin.x, desOrigin.y, itemWidth, itemWidth)];
            tag.view.userInteractionEnabled = YES;
            ((TagView *)tag.view).touchDelegate = self;
            tag.view.backgroundColor = [UIColor colorWithRed: 20 * (i + 1) * (j + 1) / 255.0f green:20 * (ROW_NUM-i) * (COLUM_NUM-j) / 255.0f blue:20 * (i + 1) * (j + 1) / 255.0f alpha:1];
            [self.tags addObject:tag];
            [scrollView addSubview:tag.view];
            tag.view.font = [UIFont systemFontOfSize:17];
            tag.view.text = [NSString stringWithFormat:@"%i", i * COLUM_NUM + j];
            tag.view.textAlignment = NSTextAlignmentCenter;
            tag.view.layer.cornerRadius = itemWidth/2;
            tag.view.layer.masksToBounds = YES;
        }
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, (gap + itemWidth) * ROW_NUM);
}

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

- (void) startOrderAnim : (TagItem *) targetTag index : (NSInteger) targetIndex
{
    CGPoint tmpPoint = CGPointMake(targetTag.center.x, targetTag.center.y);
    curDraggingTag.center = CGPointMake(tmpPoint.x, tmpPoint.y);
    
    BOOL forward = curIndex > targetIndex;
    NSMutableArray * tags = [NSMutableArray arrayWithArray:[self.tags subarrayWithRange:NSMakeRange(forward ? targetIndex : curIndex, labs(targetIndex - curIndex) + 1)]];
    if(forward){
        id cur = [tags lastObject];
        [tags insertObject:cur atIndex:0];
        [tags removeLastObject];
    }else{
        id cur = [tags firstObject];
        [tags addObject:cur];
        [tags removeObjectAtIndex:0];
    }
    [self.tags replaceObjectsInRange:NSMakeRange(forward ? targetIndex : curIndex, labs(targetIndex - curIndex) + 1) withObjectsFromArray:tags];
    NSInteger tmpCurIndex = curIndex;
    curIndex = targetIndex;
        for(NSInteger i = MIN(tmpCurIndex, targetIndex); i <= MAX(tmpCurIndex, targetIndex); i ++){
            if(i == curIndex){
                continue;
            }
            [UIView animateWithDuration:ANIM_DURATION animations:^{
                [UIView setAnimationDelay:ANIM_DURATION / (MAX(tmpCurIndex, targetIndex) - MIN(tmpCurIndex, targetIndex)) * (forward ? MAX(tmpCurIndex, targetIndex) - i : i - MIN(tmpCurIndex, targetIndex))];
                TagItem * tag = [self.tags objectAtIndex:i];
                tag.center = CGPointMake(25 + (gap + itemWidth) * (i % COLUM_NUM) + itemWidth/2, (gap + itemWidth) * (i / COLUM_NUM) + itemWidth/2);
                tag.desCenter = tag.center;
                tag.view.center = tag.desCenter;
            }
            completion:^(BOOL finished) {
                             }];
    }
}

- (void) detectHanging
{
    if(distanceBetweenPoints(detectingTag.center, CGPointMake(curDraggingTag.view.center.x - scrollView.frame.origin.x + scrollView.contentOffset.x, curDraggingTag.view.center.y - scrollView.frame.origin.y + scrollView.contentOffset.y)) < itemWidth / 2){
        [self startOrderAnim:detectingTag index:detectingIndex];
    }
    detectingTag = nil;
}

- (void) triggerDetecting
{
    BOOL outside = curDraggingTag.view.center.y < scrollView.frame.origin.y || curDraggingTag.view.center.y > scrollView.frame.origin.y + scrollView.frame.size.height;
    if(outside){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerDetecting) object:nil];
        [scrollView scrollRectToVisible:CGRectMake(curDraggingTag.view.frame.origin.x - scrollView.frame.origin.x + scrollView.contentOffset.x, curDraggingTag.view.frame.origin.y - scrollView.frame.origin.y + scrollView.contentOffset.y, itemWidth, itemWidth) animated:YES];
        [self performSelector:@selector(triggerDetecting) withObject:nil afterDelay:0.2];
    }else{
        for(NSInteger i = 0 ; i < self.tags.count ; i ++){
            TagItem * tag = [self.tags objectAtIndex:i];
            CGFloat distance = distanceBetweenPoints(tag.center, CGPointMake(curDraggingTag.view.center.x - scrollView.frame.origin.x + scrollView.contentOffset.x, curDraggingTag.view.center.y - scrollView.frame.origin.y + scrollView.contentOffset.y));
            if(curDraggingTag == tag || detectingTag == tag){
                continue;
            }
            if(distance < itemWidth / 2){
                detectingTag = tag;
                detectingIndex = i;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
                [self performSelector:@selector(detectHanging) withObject:nil afterDelay:DETECTING_DURATION];
                break;
            }
        }
    }
}

- (void) tagView:(UIView *)view touchesBegan:(NSSet<UITouch *> *)touches
{
    if(curDraggingTag){
        return;
    }
    scrollView.scrollEnabled = NO;
    UITouch *touch = [touches anyObject];
    startDraggingOrigin = [touch locationInView:scrollView];
    for(NSInteger i = 0 ; i < self.tags.count ; i ++){
        TagItem * tag = [self.tags objectAtIndex:i];
        if(CGRectContainsPoint(tag.view.frame, startDraggingOrigin)){
            curDraggingTag = tag;
            curIndex = i;
            [curDraggingTag.view removeFromSuperview];
            curDraggingTag.view.center = CGPointMake(curDraggingTag.center.x - scrollView.contentOffset.x + scrollView.frame.origin.x, curDraggingTag.center.y - scrollView.contentOffset.y + scrollView.frame.origin.y);
            [self.view addSubview:curDraggingTag.view];
            break;
        }
    }
}

- (void) tagView:(UIView *)view touchesMoved:(NSSet<UITouch *> *)touches
{
    if(curDraggingTag){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:scrollView];
        curDraggingTag.view.center = CGPointMake(curDraggingTag.desCenter.x - scrollView.contentOffset.x + scrollView.frame.origin.x + point.x - startDraggingOrigin.x, curDraggingTag.desCenter.y - scrollView.contentOffset.y + scrollView.frame.origin.y + point.y - startDraggingOrigin.y);
        
        [self triggerDetecting];
    }
}

- (void) tagView:(UIView *)view touchesEnded:(NSSet<UITouch *> *)touches
{
    scrollView.scrollEnabled = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerDetecting) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
    if(curDraggingTag){
        [curDraggingTag.view removeFromSuperview];
        curDraggingTag.view.center = CGPointMake(curDraggingTag.view.center.x - scrollView.frame.origin.x + scrollView.contentOffset.x, curDraggingTag.view.center.y - scrollView.frame.origin.y + scrollView.contentOffset.y);
        [scrollView addSubview:curDraggingTag.view];
        curDraggingTag.desCenter = curDraggingTag.center;
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            curDraggingTag.view.center = curDraggingTag.desCenter;
        } completion:^(BOOL finished) {
        }];
        curDraggingTag = nil;
    }
}

- (void) tagView:(UIView *)view touchesCancelled:(NSSet<UITouch *> *)touches
{
    scrollView.scrollEnabled = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerDetecting) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
    if(curDraggingTag){
        [curDraggingTag.view removeFromSuperview];
        curDraggingTag.view.center = CGPointMake(curDraggingTag.view.center.x - scrollView.frame.origin.x + scrollView.contentOffset.x, curDraggingTag.view.center.y - scrollView.frame.origin.y + scrollView.contentOffset.y);
        [scrollView addSubview:curDraggingTag.view];
        curDraggingTag.desCenter = curDraggingTag.center;
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            curDraggingTag.view.center = curDraggingTag.desCenter;
        } completion:^(BOOL finished) {
        }];
        curDraggingTag = nil;
    }
}

@end
