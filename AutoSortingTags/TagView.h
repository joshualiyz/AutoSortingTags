//
//  TagView.h
//  AutoSortingTags
//
//  Created by joshuali on 15/11/18.
//  Copyright © 2015年 joshuali. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewTouchDelegate <NSObject>

- (void) tagView : (UIView *) view touchesBegan:(NSSet<UITouch *> *)touches;

- (void) tagView : (UIView *) view touchesMoved:(NSSet<UITouch *> *)touches;

- (void) tagView : (UIView *) view touchesEnded:(NSSet<UITouch *> *)touches;

- (void) tagView : (UIView *) view touchesCancelled:(NSSet<UITouch *> *)touches;

@end

@interface TagView : UILabel
@property (nonatomic, weak) id<TagViewTouchDelegate> touchDelegate;
@end
