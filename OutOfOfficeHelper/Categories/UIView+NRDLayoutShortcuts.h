//
//  UIView+NRDLayoutShortcuts.h
//  Layout Shortcuts Category
//
//  Created by Joshua Sullivan on 11/27/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

// NOTE: Comments are designed for compatibility with AppleDoc (http://gentlebytes.com/appledoc), not HeaderDoc.

/**
 A batch of methods for common layout scenarios such as creating a header or footer or searching for a particular type of constraint.
 
 Created by Joshua Sullivan (jsulliva@nerdery.com)
 */


@interface UIView (NRDLayoutShortcuts)


/*!
 Allows the specification of fixed insets on each side of the view, relative to its superview.
 @param topInset The top inset from the view relative to its superview.
 @param leftInset The left inset from the view relative to its superview.
 @param bottomInset The bottom inset from the view relative to its superview.
 @param rightInset The right inset from the view relative to its superview.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsWithTopInset:(CGFloat)topInset leftInset:(CGFloat)leftInset bottomInset:(CGFloat)bottomInset rightInset:(CGFloat)rightInset;

/*!
 Convenience method for creating insets from UIEdgeInsets object.
 
 Uses the values in the UIEdgeInsets parameter to call @link createConstraintsWithTopInset:leftInset:bottomInset:rightInset: @/link
 @param insets A UIEdgeInsets object which will be used to populate the inset values.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsFromInsets:(UIEdgeInsets)insets;

/*!
 Convenience method for creating a uniform inset.
 Uses the parameter value for all parameters on @link createConstraintsWithTopInset:leftInset:bottomInset:rightInset: @/link
 @param inset A CGFloat which will be used to populate the inset values.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsWithUniformInset:(CGFloat)inset;

/*!
 Create a header view with a fixed height.
 The view will be top-aligned with its superview and match its width. The height of the view will be equal to the headerHeight parameter.
 @param headerHeight A CGFloat defining the height of the header view.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForHeaderWithHeight:(CGFloat)headerHeight;

/*!
 Create a header view with a height determined by spacing to the view passed in the bottomView parameter.
 The view will be top-aligned with its superview and match its width. The header will extend down to bottomView plus or minus the spacing value.
 @param bottomView Another UIView which this view will extend to.
 @param spacing The space between the header view and bottomView. A value of 0.0 will be flush. Positive numbers create space, negative numbers cause overlap.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForHeaderWithBottomRelativeToView:(UIView *)bottomView andSpacing:(CGFloat)spacing;

/*!
 Create a footer view with a fixed height.
 The view will be bottom-aligned with its superview and match its width. The height of the view will be equal to the footerHeight parameter.
 @param footerHeight A CGFloat defining the height of the footer view.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForFooterWithHeight:(CGFloat)footerHeight;

/*!
 Create a footer view with a height determined by spacing to the view passed in the topView parameter.
 The view will be bottom-aligned with its superview and match its width. The header will extend up to topView plus or minus the spacing value.
 @param topView Another UIView which this view will extend to.
 @param spacing The space between the header view and topView. A value of 0.0 will be flush. Positive numbers create space, negative numbers cause overlap.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForFooterWithTopRelativeToView:(UIView *)topView andSpacing:(CGFloat)spacing;

/*!
 Create a two column arrangement with the left column having a fixed width. The view that this method is called on will be the left column view.
 @param leftColumnWidth The width of the left column.
 @param rightColumnView The view to use as the right column.
 @param gutterWidth The space between the 2 columns.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForTwoColumnsWithFixedLeftSize:(CGFloat)leftColumnWidth rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth;

/*!
 Create a two column arrangement with the right column having a fixed width. The view that this method is called on will be the left column view.
 @param rightColumnWidth The width of the right column.
 @param rightColumnView The view to use as the right column.
 @param gutterWidth The space between the 2 columns.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForTwoColumnsWithFixedRightSize:(CGFloat)rightColumnWidth rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth;

/*!
 Create a two column arrangement with the left column having a width that is a percentage of its superview's width. The view that this method is called on will be the left column view.
 @param leftColumnPercentage A number in the range 0.0 - 1.0 which will determine the percentage of the view's superview width to match.
 @param rightColumnView The view to use as the right column.
 @param gutterWidth The space between the 2 columns.
 @return An NSArray of constraints suitable for use with UIView's addConstraints: method.
 */
- (NSArray *)createConstraintsForTwoColumnsWithRelativeSize:(CGFloat)leftColumnPercentage rightColumnView:(UIView *)rightColumnView columnGutterWidth:(CGFloat)gutterWidth;

/*!
 Search the view hierarchy for a particular kind of constraint on (optionally) a particular object.
 Searches down the view hierarchy until a constraint of the specified type for the specified object is found. If no object is specified, the first instance of the specified type is returned. If the search fails, nil will be returned.
 @param type The type of constraint (enumerated in NSLayoutConstraint.h) to search for.
 @param viewObject (optional) The view to which the constraint should be targeted to. Setting this to nil will return the first occurence of the specified type.
 @return An NSLayoutConstraint object if one was found. Otherwise, nil.
 */
- (NSLayoutConstraint *)findConstraintOfType:(NSLayoutAttribute)type forObject:(UIView *)viewObject;

/*!
 Search the view hierarchy for a particular kind of constraint.
 Searches down the view hierarchy finding all constraints of the specified type.
 @param type The type of constraint (enumerated in NSLayoutConstraint.h) to search for.
 @return An NSArray of constraints of the specified type.
 */
- (NSArray *)findAllConstraintsOfType:(NSLayoutAttribute)type;

@end
