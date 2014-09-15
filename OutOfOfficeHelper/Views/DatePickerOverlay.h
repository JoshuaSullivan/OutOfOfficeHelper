//
// Created by Joshua Sullivan on 9/14/14.
// Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

@import UIKit;

@protocol DatePickerOverlayDelegate;

@interface DatePickerOverlay : UIView

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet id <DatePickerOverlayDelegate> delegate;

- (void)configureWithDate:(NSDate *)date backgroundImage:(UIImage *)backgroundImage;

@end

@protocol DatePickerOverlayDelegate <NSObject>

- (void)datePickerOverlay:(DatePickerOverlay *)datePickerOverlay didPickDate:(NSDate *)date;
- (void)datePickerOverlayDidRequestDismissal:(DatePickerOverlay *)datePickerOverlay;

@end
