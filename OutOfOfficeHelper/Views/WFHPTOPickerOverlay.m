//
//  WFHPTOPickerOverlay.m
//  OutOfOfficeHelper
//
//  Created by Joshua Sullivan on 9/15/14.
//  Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

#import "WFHPTOPickerOverlay.h"

static NSString * const kWfhPtoTypeNeitherString = @"Neither";
static NSString * const kWfhPtoTypeWfhOnlyString = @"WFH Only";
static NSString * const kWfhPtoTypePtoOnlyString = @"PTO Only";
static NSString * const kWfhPtoTypeBothString = @"Both";

@interface WFHPTOPickerOverlay () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)doneTapped:(id)sender;

@end

@implementation WFHPTOPickerOverlay

- (void)configureWithType:(WfhPtoType)type backgroundImage:(UIImage *)backgroundImage
{
    [self.picker selectRow:type inComponent:0 animated:NO];
    self.backgroundView.image = backgroundImage;
}

- (IBAction)doneTapped:(id)sender
{
    [self.delegate wfhPtoPickerOverlayDidRequestDismissal:self];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [WFHPTOPickerOverlay stringForWfhPtoType:(WfhPtoType)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate wfhPtoPickerOverlay:self pickedType:(WfhPtoType)row];
}

#pragma mark - Helper Methods

+ (NSString *)stringForWfhPtoType:(WfhPtoType)type
{
    switch (type) {
        case WfhPtoTypeNeither: return kWfhPtoTypeNeitherString;
        case WfhPtoTypeWfhOnly: return kWfhPtoTypeWfhOnlyString;
        case WfhPtoTypePtoOnly: return kWfhPtoTypePtoOnlyString;
        case WfhPtoTypeBoth: return kWfhPtoTypeBothString;
    }
    return @"Unknown";
}


@end
