//
//  SwapViewController.m
//  test
//
//  Created by joshuali on 15/11/17.
//  Copyright © 2015年 aixuehuisi. All rights reserved.
//

#import "SwapViewController.h"
#import "TagItem.h"

@interface SwapViewController ()
{
    CGFloat itemWidth;
    TagItem * curDraggingTag;
    TagItem * detectingTag;
    CGPoint startDraggingOrigin;
}
@property (nonatomic, strong) NSMutableArray * tags;
@end

@implementation SwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tags = [NSMutableArray array];
    CGFloat gap = 20;
    itemWidth = ([UIScreen mainScreen].bounds.size.width - 50 - 20 * 3) / 4;
    for(int i = 0 ; i < 5 ; i ++){
        for(int j = 0 ; j < 4 ; j ++){
            TagItem * tag = [TagItem new];
            CGPoint desOrigin = CGPointMake(25 + (gap + itemWidth) * j, 50 + (gap + itemWidth) * i);
            tag.center = CGPointMake(desOrigin.x + itemWidth/2, desOrigin.y + itemWidth/2);
            tag.desCenter = tag.center;
            tag.view = [[UILabel alloc] initWithFrame:CGRectMake(desOrigin.x, desOrigin.y, itemWidth, itemWidth)];
            tag.view.backgroundColor = [UIColor colorWithRed: 20 * (i + 1) * (j + 1) / 255.0f green:20 * (5-i) * (4-j) / 255.0f blue:20 * (i + 1) * (j + 1) / 255.0f alpha:1];
            [self.tags addObject:tag];
            [self.view addSubview:tag.view];
            tag.view.font = [UIFont systemFontOfSize:6];
        }
    }
}

CGFloat distanceBetweenPoints1 (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

- (void) detectHanging
{
    if(distanceBetweenPoints1(detectingTag.center, curDraggingTag.view.center) < itemWidth / 2){
        CGPoint tmpPoint = CGPointMake(detectingTag.center.x, detectingTag.center.y);
        detectingTag.center = CGPointMake(curDraggingTag.center.x, curDraggingTag.center.y);
        curDraggingTag.center = CGPointMake(tmpPoint.x, tmpPoint.y);
        detectingTag.desCenter = detectingTag.center;
        
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            detectingTag.view.center = CGPointMake(detectingTag.desCenter.x, detectingTag.desCenter.y);
        } completion:^(BOOL finished) {
        }];
    }
    detectingTag = nil;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    startDraggingOrigin = [touch locationInView:self.view];
    for(TagItem * tag in self.tags){
        if(CGRectContainsPoint(tag.view.frame, startDraggingOrigin)){
            curDraggingTag = tag;
            break;
        }
    }
    if(curDraggingTag){
        [self.view bringSubviewToFront:curDraggingTag.view];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(curDraggingTag){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        curDraggingTag.view.center = CGPointMake(curDraggingTag.desCenter.x + point.x - startDraggingOrigin.x, curDraggingTag.desCenter.y + point.y - startDraggingOrigin.y);
        
        for(TagItem * tag in self.tags){
            if(curDraggingTag == tag || detectingTag == tag){
                continue;
            }
            if(distanceBetweenPoints1(tag.center, curDraggingTag.view.center) < itemWidth / 2){
                detectingTag = tag;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
                [self performSelector:@selector(detectHanging) withObject:nil afterDelay:DETECTING_DURATION];
                break;
            }
        }
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
    if(curDraggingTag){
        curDraggingTag.desCenter = curDraggingTag.center;
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            curDraggingTag.view.center = curDraggingTag.desCenter;
        } completion:^(BOOL finished) {
        }];
        curDraggingTag = nil;
    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(detectHanging) object:nil];
    if(curDraggingTag){
        curDraggingTag.desCenter = curDraggingTag.center;
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            curDraggingTag.view.center = curDraggingTag.desCenter;
        } completion:^(BOOL finished) {
        }];
        curDraggingTag = nil;
    }
}

@end
