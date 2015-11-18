//
//  TagItem.h
//  test
//
//  Created by joshuali on 15/11/17.
//  Copyright © 2015年 aixuehuisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ANIM_DURATION   0.2f
#define DETECTING_DURATION      0.2f

@interface TagItem : NSObject
@property (nonatomic, strong) UILabel * view;
@property CGPoint desCenter;
@property CGPoint center;
@property BOOL needChange;


@end
