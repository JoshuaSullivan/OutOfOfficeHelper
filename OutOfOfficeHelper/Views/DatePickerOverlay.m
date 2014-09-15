//
// Created by Joshua Sullivan on 9/14/14.
// Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

#import "DatePickerOverlay.h"
#import "UIImage+ImageEffects.h"

@interface DatePickerOverlay ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)datePickerDidChange:(UIDatePicker *)picker;
- (IBAction)doneTapped:(id)sender;

@end

@implementation DatePickerOverlay

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.datePicker.minimumDate = [NSDate date];
}

- (void)configureWithDate:(NSDate *)date backgroundImage:(UIImage *)backgroundImage
{
    self.datePicker.date = date;
    self.backgroundView.image = backgroundImage;
}

- (IBAction)datePickerDidChange:(UIDatePicker *)picker
{
    [self.delegate datePickerOverlay:self didPickDate:picker.date];
}

- (IBAction)doneTapped:(id)sender
{
    [self.delegate datePickerOverlayDidRequestDismissal:self];
}

@end