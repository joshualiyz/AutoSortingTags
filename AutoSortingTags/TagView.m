//
//  TagView.m
//  AutoSortingTags
//
//  Created by joshuali on 15/11/18.
//  Copyright © 2015年 joshuali. All rights reserved.
//

#import "TagView.h"

@implementation TagView

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.touchDelegate){
        [self.touchDelegate tagView:self touchesBegan:touches];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.touchDelegate){
        [self.touchDelegate tagView:self touchesMoved:touches];
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.touchDelegate){
        [self.touchDelegate tagView:self touchesEnded:touches];
    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.touchDelegate){
        [self.touchDelegate tagView:self touchesCancelled:touches];
    }
}

@end
