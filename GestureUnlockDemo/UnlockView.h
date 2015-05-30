//
//  UnlockView.h
//  GestureUnlockDemo
//
//  Created by caramel on 5/25/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnlockView;

@protocol UnlockViewDelegate <NSObject>

@optional
- (void)unlockViewDidFinishWith:(NSString *)result;

@end

@interface UnlockView : UIView

@property (weak, nonatomic) id<UnlockViewDelegate> delegate;

@end
