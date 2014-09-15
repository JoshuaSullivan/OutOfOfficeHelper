//
//  WFHPTOPickerOverlay.h
//  OutOfOfficeHelper
//
//  Created by Joshua Sullivan on 9/15/14.
//  Copyright (c) 2014 Josh Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WfhPtoType) {
    WfhPtoTypeNeither = 0,
    WfhPtoTypeWfhOnly,
    WfhPtoTypePtoOnly,
    WfhPtoTypeBoth
};

@protocol WFHPTOPickerOverlayDelegate;

@interface WFHPTOPickerOverlay : UIView

@property (weak, nonatomic) IBOutlet id <WFHPTOPickerOverlayDelegate> delegate;

- (void)configureWithType:(WfhPtoType)type backgroundImage:(UIImage *)backgroundImage;

+ (NSString *)stringForWfhPtoType:(WfhPtoType)type;

@end

@protocol WFHPTOPickerOverlayDelegate <NSObject>

- (void)wfhPtoPickerOverlay:(WFHPTOPickerOverlay *)wfhptoPickerOverlay pickedType:(WfhPtoType)type;
- (void)wfhPtoPickerOverlayDidRequestDismissal:(WFHPTOPickerOverlay *)wfhptoPickerOverlay;

@end
