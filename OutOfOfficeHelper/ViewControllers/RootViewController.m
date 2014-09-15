//
//  RootViewController.m
//  OutOfOfficeHelper
//
//  Created by Joshua Sullivan on 9/13/14.
//  Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

@import MessageUI;

#import "RootViewController.h"
#import "DatePickerOverlay.h"
#import "WFHPTOPickerOverlay.h"
#import "UIImage+ImageEffects.h"

NSString * const kDefaultsRecipientsKey = @"__kDefaultsRecipientsKey";

NSString * const kRootToDatePickerSegueIdentifier = @"kRootToDatePickerSegueIdentifier";

@interface RootViewController () <DatePickerOverlayDelegate,
                                  WFHPTOPickerOverlayDelegate,
                                  UITextFieldDelegate,
                                  MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) WfhPtoType wfhPtoType;
@property (strong, nonatomic) NSDateFormatter *displayDateFormatter;
@property (strong, nonatomic) NSDateFormatter *emailDateFormatter;
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

    self.displayDateFormatter = [NSDateFormatter new];
    self.displayDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.emailDateFormatter = [NSDateFormatter new];
    self.emailDateFormatter.dateFormat = @"MM/dd";

    self.wfhPtoType = WfhPtoTypePtoOnly;

    self.datePickerOverlay.frame = self.view.bounds;
    self.wfhPtoPickerOverlay.frame = self.view.bounds;

    [self refreshFields];
}

- (void)refreshFields
{
    self.startDateLabel.text = [self.displayDateFormatter stringFromDate:self.startDate];
    self.endDateLabel.text = [self.displayDateFormatter stringFromDate:self.endDate];
    self.wfhPtoLabel.text = [WFHPTOPickerOverlay stringForWfhPtoType:self.wfhPtoType];
}

- (void)prepareForEmailComposition
{
    [[NSUserDefaults standardUserDefaults] setObject:self.recipientField.text forKey:kDefaultsRecipientsKey];
    NSArray *recipients = [self.recipientField.text componentsSeparatedByString:@","];

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:recipients];
        [mailComposer setSubject:[self generateEmailSubject]];
        [mailComposer setMessageBody:[self generateEmailBody] isHTML:NO];
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable To Send Email"
                                                        message:@"The system is reporting that email cannot be sent at this time. Check your email settings and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }


}

- (NSString *)generateEmailSubject
{
    NSString *subject;

    NSString *startDateString = [self.emailDateFormatter stringFromDate:self.startDate];
    NSString *endDateString = [self.emailDateFormatter stringFromDate:self.endDate];
    BOOL singleDate = [startDateString isEqualToString:endDateString];

    NSString *oooType = @"";
    switch(self.wfhPtoType) {
        case WfhPtoTypeNeither:break;
        case WfhPtoTypeWfhOnly:
            oooType = @"WFH ";
            break;
        case WfhPtoTypePtoOnly:
            oooType = @"PTO ";
            break;
        case WfhPtoTypeBoth:
            oooType = @"WFH/PTO ";
            break;
    }
    if (singleDate) {
        subject = [NSString stringWithFormat:@"OOO: %@%@", oooType, startDateString];
    } else {
        subject = [NSString stringWithFormat:@"OOO: %@%@ - %@", oooType, startDateString, endDateString];
    }

    return subject;
}

- (NSString *)generateEmailBody
{
    NSString *startDateString = [self.emailDateFormatter stringFromDate:self.startDate];
    NSString *endDateString = [self.emailDateFormatter stringFromDate:self.endDate];
    BOOL singleDate = [startDateString isEqualToString:endDateString];

    NSString *oooType = @"";
    switch(self.wfhPtoType) {
        case WfhPtoTypeNeither:
            oooType = @"Neither";
            break;
        case WfhPtoTypeWfhOnly:
            oooType = @"WFH";
            break;
        case WfhPtoTypePtoOnly:
            oooType = @"PTO";
            break;
        case WfhPtoTypeBoth:
            oooType = @"Both";
            break;
    }

    NSMutableString *body = [NSMutableString string];
    if (singleDate) {
        [body appendFormat:@"Date: %@\n", startDateString];
    } else {
        [body appendFormat:@"Dates: %@ - %@\n", startDateString, endDateString];
    }
    [body appendFormat:@"WFH or PTO: %@\n", oooType];
    [body appendFormat:@"PTO Hours: %@\n\n", self.ptoHoursUsedField.text];
    [body appendFormat:@"Available by phone: %@\n", self.phoneSwitch.on ? @"Yes" : @"No"];
    [body appendFormat:@"Available by email: %@\n", self.emailSwitch.on ? @"Yes" : @"No"];
    [body appendFormat:@"Available by IM: %@\n\n", self.imSwitch.on ? @"Yes" : @"No"];

    return [NSString stringWithString:body];
}

#pragma mark - Managing pickers

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
    if (self.wfhPtoType == WfhPtoTypeNeither || self.wfhPtoType == WfhPtoTypeWfhOnly) {
        self.ptoHoursUsedField.text = @"0.0";
    }
    [self hideWfhPtoPicker];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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
    [self prepareForEmailComposition];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *title;
        NSString *message;
        switch (result) {
            case MFMailComposeResultSaved:
                title = @"Email Saved";
                message = @"Your OOO email was saved to Drafts, but was NOT sent.";
                break;
            case MFMailComposeResultSent:
                title = @"Email Sent";
                message = @"Your OOO email was successfully sent.";
                break;
            case MFMailComposeResultCancelled:return;
            case MFMailComposeResultFailed:
                title = @"Email Failed";
                message = @"Unable to send email! Check your mail settings and try again.";
                break;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }];
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
