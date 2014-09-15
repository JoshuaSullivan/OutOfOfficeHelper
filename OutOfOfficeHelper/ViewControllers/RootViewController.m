//
//  RootViewController.m
//  OutOfOfficeHelper
//
//  Created by Joshua Sullivan on 9/13/14.
//  Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

#import "RootViewController.h"
#import "DatePickerOverlay.h"
#import "WFHPTOPickerOverlay.h"
#import "UIImage+ImageEffects.h"

NSString * const kDefaultsRecipientsKey = @"__kDefaultsRecipientsKey";

NSString * const kRootToDatePickerSegueIdentifier = @"kRootToDatePickerSegueIdentifier";

@interface RootViewController () <DatePickerOverlayDelegate, WFHPTOPickerOverlayDelegate>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) WfhPtoType wfhPtoType;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign, nonatomic) BOOL pickingStartDate;

@property (weak, nonatomic) IBOutlet UITextField *recipientField;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wfhPtoLabel;
@property (weak, nonatomic) IBOutlet UITextField *ptoHoursUsedField;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *imSwitch;
@property (weak, nonatomic) IBOutlet DatePickerOverlay *datePickerOverlay;
@property (weak, nonatomic) IBOutlet WFHPTOPickerOverlay *wfhPtoPickerOverlay;

- (IBAction)startDateTapped:(id)sender;
- (IBAction)endDateTapped:(id)sender;
- (IBAction)wfhPtoTapped:(id)sender;
- (IBAction)composeEmailTapped:(id)sender;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.recipientField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsRecipientsKey];
    self.startDate = [NSDate date];
    self.endDate = [NSDate date];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.wfhPtoType = WfhPtoTypePtoOnly;

    self.datePickerOverlay.frame = self.view.bounds;
    self.wfhPtoPickerOverlay.frame = self.view.bounds;

    [self refreshFields];
}

- (void)refreshFields
{
    self.startDateLabel.text = [self.dateFormatter stringFromDate:self.startDate];
    self.endDateLabel.text = [self.dateFormatter stringFromDate:self.endDate];
    self.wfhPtoLabel.text = [WFHPTOPickerOverlay stringForWfhPtoType:self.wfhPtoType];
}

- (void)showDatePicker
{
    [self clearKeyboard];
    NSDate *date = self.pickingStartDate ? self.startDate : self.endDate;
    UIImage *image = [self blurredSnapshot];
    [self.datePickerOverlay configureWithDate:date backgroundImage:image];
    [self.view addSubview:self.datePickerOverlay];
    self.datePickerOverlay.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.datePickerOverlay.alpha = 1.0f;
    }];
}

- (void)hideDatePicker
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePickerOverlay.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.datePickerOverlay removeFromSuperview];
                     }];
}

- (void)showWfhPtoPicker
{
    [self clearKeyboard];
    UIImage *image = [self blurredSnapshot];
    [self.wfhPtoPickerOverlay configureWithType:self.wfhPtoType backgroundImage:image];
    [self.view addSubview:self.wfhPtoPickerOverlay];
    self.wfhPtoPickerOverlay.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.wfhPtoPickerOverlay.alpha = 1.0f;
    }];
}

- (void)hideWfhPtoPicker
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.wfhPtoPickerOverlay.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.wfhPtoPickerOverlay removeFromSuperview];
                     }];
}

- (void)clearKeyboard
{
    [self.recipientField resignFirstResponder];
    [self.ptoHoursUsedField resignFirstResponder];
}

#pragma mark - DatePickerOverlayDelegate

- (void)datePickerOverlay:(DatePickerOverlay *)datePickerOverlay didPickDate:(NSDate *)date
{
    if (self.pickingStartDate) {
        self.startDate = date;
    } else {
        self.endDate = date;
    }
}

- (void)datePickerOverlayDidRequestDismissal:(DatePickerOverlay *)datePickerOverlay
{
    if (self.startDate > self.endDate) {
        if (self.pickingStartDate) {
            self.endDate = [NSDate dateWithTimeInterval:0.0 sinceDate:self.startDate];
        } else {
            self.startDate = [NSDate dateWithTimeInterval:0.0 sinceDate:self.endDate];
        }
    }
    [self refreshFields];
    [self hideDatePicker];
}

#pragma mark - WFHPTOPickerOverlayDelegate

- (void)wfhPtoPickerOverlay:(WFHPTOPickerOverlay *)wfhptoPickerOverlay pickedType:(WfhPtoType)type
{
    self.wfhPtoType = type;
}

- (void)wfhPtoPickerOverlayDidRequestDismissal:(WFHPTOPickerOverlay *)wfhptoPickerOverlay
{
    [self refreshFields];
    if (self.wfhPtoType == WfhPtoTypeNone || self.wfhPtoType == WfhPtoTypeWfhOnly) {
        self.ptoHoursUsedField.text = @"0.0";
    }
    [self hideWfhPtoPicker];
}


#pragma mark - IBActions

- (IBAction)startDateTapped:(id)sender
{
    self.pickingStartDate = YES;
    [self showDatePicker];
}

- (IBAction)endDateTapped:(id)sender
{
    self.pickingStartDate = NO;
    [self showDatePicker];
}

- (IBAction)wfhPtoTapped:(id)sender
{
    [self showWfhPtoPicker];
}

- (IBAction)composeEmailTapped:(id)sender
{
    
}

#pragma mark - Helper Methods

- (UIImage *)blurredSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, self.view.window.screen.scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [image nrd_imageByApplyingLightEffect];
}

@end
