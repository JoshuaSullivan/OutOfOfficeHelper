//
//  UIView+NRDLayoutShortcuts.m
//  Layout Shortcuts Category
//
//  Created by Joshua Sullivan on 11/27/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import "UIView+NRDLayoutShortcuts.h"

@implementation UIView (NRDLayoutShortcuts)

#pragma mark - Constraints based on insets from superview.

- (NSArray *)createConstraintsFromInsets:(UIEdgeInsets)insets
{
    return [self createConstraintsWithTopInset:insets.top leftInset:insets.left bottomInset:insets.bottom rightInset:insets.right];
}
- (NSArray *)createConstraintsWithUniformInset:(CGFloat)inset
{
    return [self createConstraintsWithTopInset:inset leftInset:inset bottomInset:inset rightInset:inset];
}

- (NSArray *)createConstraintsWithTopInset:(CGFloat)topInset leftInset:(CGFloat)leftInset bottomInset:(CGFloat)bottomInset rightInset:(CGFloat)rightInset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormat = [NSString stringWithFormat:@"H:|-(%f)-[this]-(%f)-|", leftInset, rightInset];
    NSString *vFormat = [NSString stringWithFormat:@"V:|-(%f)-[this]-(%f)-|", topInset, bottomInset];
    NSDictionary *views = @{@"this" : self};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

#pragma mark - Constraints for header based either on height or spacing to another view (with optional insets)

- (NSArray *)createConstraintsForHeaderWithHeight:(CGFloat)headerHeight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormat = @"H:|[this]|";
    NSString *vFormat = [NSString stringWithFormat:@"V:|[this(%f)]", headerHeight];
    NSDictionary *views = @{@"this" : self};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}


- (NSArray *)createConstraintsForHeaderWithBottomRelativeToView:(UIView *)bottomView andSpacing:(CGFloat)spacing
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormat = @"H:|[this]|";
    NSString *vFormat = [NSString stringWithFormat:@"V:|[this]-(%f)-[bottomView]", spacing];
    NSDictionary *views = @{@"this" : self, @"bottomView" : bottomView};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

#pragma mark - Constraints for footer with fixed height or relative to another view.

- (NSArray *)createConstraintsForFooterWithHeight:(CGFloat)footerHeight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormat = @"H:|[this]|";
    NSString *vFormat = [NSString stringWithFormat:@"V:[this(%f)]|", footerHeight];
    NSDictionary *views = @{@"this" : self};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

- (NSArray *)createConstraintsForFooterWithTopRelativeToView:(UIView *)topView andSpacing:(CGFloat)spacing
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormat = @"H:|[this]|";
    NSString *vFormat = [NSString stringWithFormat:@"V:[topView]-(%f)-[this]|", spacing];
    NSDictionary *views = @{@"this" : self, @"topView" : topView};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

#pragma mark - Set up a 2-column layout with either fixed or relative width for the left column
- (NSArray *)createConstraintsForTwoColumnsWithFixedLeftSize:(CGFloat)leftColumnWidth rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    rightColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"leftColumn" : self, @"rightColumn" : rightColumnView};
    NSString *hFormat = [NSString stringWithFormat:@"H:|[leftColumn(%f)]-(%f)-[rightColumn]|", leftColumnWidth, gutterWidth];
    NSString *vLeftFormat = @"V:|[leftColumn]|";
    NSString *vRightFormat = @"V:|[rightColumn]|";
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vLeftFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vRightFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

- (NSArray *)createConstraintsForTwoColumnsWithFixedRightSize:(CGFloat)rightColumnWidth rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    rightColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"leftColumn" : self, @"rightColumn" : rightColumnView};
    NSString *hFormat = [NSString stringWithFormat:@"H:|[leftColumn]-(%f)-[rightColumn(%f)]|", gutterWidth, rightColumnWidth];
    NSString *vLeftFormat = @"V:|[leftColumn]|";
    NSString *vRightFormat = @"V:|[rightColumn]|";
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vLeftFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vRightFormat
                                                                                                     options:0
                                                                                                     metrics:nil
                                                                                                       views:views]];
    return constraints;
}

- (NSArray *)createConstraintsForTwoColumnsWithRelativeSize:(CGFloat)leftColumnPercentage rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    rightColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [NSMutableArray array];
    leftColumnPercentage = fmaxf(0.0, fminf(leftColumnPercentage, 1.0));
    
    NSDictionary *views = @{@"leftColumn" : self, @"rightColumn" : rightColumnView};
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.superview
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:leftColumnPercentage
                                                         constant:0.0]];
    NSString *hFormat = [NSString stringWithFormat:@"H:|[leftColumn]-(%f)-[rightColumn]|", gutterWidth];
    NSString *vLeftFormat = @"V:|[leftColumn]|";
    NSString *vRightFormat = @"V:|[rightColumn]|";
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vLeftFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vRightFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    return constraints;
}

#pragma mark - Search the view hierarchy for a particular type of constraint.

- (NSLayoutConstraint *)findConstraintOfType:(NSLayoutAttribute)type forObject:(UIView *)viewObject
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == type) {
            if (viewObject) {
                if (constraint.firstItem == viewObject) {
                    return constraint;
                }
            } else {
                return constraint;
            }
        }
    }
    
    for (UIView *subview in self.subviews) {
        NSLayoutConstraint *constraint = [subview findConstraintOfType:type forObject:viewObject];
        if (constraint) {
            return constraint;
        }
    }
    
    return nil;
}

- (NSArray *)findAllConstraintsOfType:(NSLayoutAttribute)type
{
    NSMutableArray *foundConstraints = [NSMutableArray array];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == type) {
            [foundConstraints addObject:constraint];
        }
    }
    
    for (UIView *subview in self.subviews) {
        [foundConstraints addObjectsFromArray:[subview findAllConstraintsOfType:type]];
    }
    
    return foundConstraints;
}


@end
