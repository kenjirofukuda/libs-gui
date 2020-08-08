/* Definition of class NSGridView
   Copyright (C) 2020 Free Software Foundation, Inc.
   
   By: Gregory John Casamento
   Date: 08-08-2020

   This file is part of the GNUstep Library.
   
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   
   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110 USA.
*/

#ifndef _NSGridView_h_GNUSTEP_GUI_INCLUDE
#define _NSGridView_h_GNUSTEP_GUI_INCLUDE

#import <AppKit/NSView.h>
#import <AppKit/NSLayoutAnchor.h>

#if OS_API_VERSION(MAC_OS_X_VERSION_10_12, GS_API_LATEST)

#if	defined(__cplusplus)
extern "C" {
#endif
  
enum {
  NSGridCellPlacementInherited = 0,
  NSGridCellPlacementNone,
  NSGridCellPlacementLeading,
  NSGridCellPlacementTop = NSGridCellPlacementLeading,    
  NSGridCellPlacementTrailing,
  NSGridCellPlacementBottom = NSGridCellPlacementTrailing,    
  NSGridCellPlacementCenter,
  NSGridCellPlacementFill    
};
typedef NSInteger NSGridCellPlacement;

enum { 
  NSGridRowAlignmentInherited = 0,
  NSGridRowAlignmentNone,
  NSGridRowAlignmentFirstBaseline,
  NSGridRowAlignmentLastBaseline
};
typedef NSInteger NSGridRowAlignment;

APPKIT_EXPORT const CGFloat NSGridViewSizeForContent;

@class NSGridColumn, NSGridRow, NSGridCell;
  
@interface NSGridView : NSView

- (instancetype) initWithFrame: (NSRect)frameRect;
- (instancetype) initWithCoder: (NSCoder *)coder;

+ (instancetype) gridViewWithNumberOfColumns: (NSInteger)columnCount rows: (NSInteger)rowCount;
+ (instancetype) gridViewWithViews: (NSArray *)rows; // an array containing an array of NSViews

- (NSInteger) numberOfRows;
- (NSInteger) numberOfColumns;

- (NSGridRow *) rowAtIndex: (NSInteger)index;
- (NSInteger) indexOfRow: (NSGridRow *)row; 
- (NSGridColumn *) columnAtIndex: (NSInteger)index;
- (NSInteger) indexOfColumn: (NSGridColumn *)column;
- (NSGridCell *) cellAtColumnIndex: (NSInteger)columnIndex rowIndex: (NSInteger)rowIndex;
- (NSGridCell *) cellForView: (NSView*)view;

- (NSGridRow *) addRowWithViews: (NSArray *)views;
- (NSGridRow *) insertRowAtIndex: (NSInteger)index withViews: (NSArray *)views;
- (void) moveRowAtIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;
- (void) removeRowAtIndex: (NSInteger)index;

- (NSGridColumn *) addColumnWithViews: (NSArray*)views;
- (NSGridColumn *) insertColumnAtIndex: (NSInteger)index withViews: (NSArray *)views;
- (void) moveColumnAtIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;
- (void) removeColumnAtIndex: (NSInteger)index;

- (NSGridCellPlacement) xPlacement;
- (void) setXPlacement: (NSGridCellPlacement)x;
- (NSGridCellPlacement) yPlacement;
- (void) setYPlacement: (NSGridCellPlacement)y;
- (NSGridRowAlignment) rowAlignment;
- (void) setRowAlignment: (NSGridRowAlignment)a;
  
- (CGFloat) rowSpacing;
- (void) setRowSpacing: (CGFloat)f;
- (CGFloat) columnSpacing;
- (void) setColumnSpacing: (CGFloat)f;
  
- (void) mergeCellsInHorizontalRange: (NSRange)hRange verticalRange: (NSRange)vRange;
  
@end

/// Cell
@interface NSGridCell : NSObject <NSCoding>

- (NSView *) contentView; 
- (void) setContentView: (NSView *)v;
  
+ (NSView *) emptyContentView;

// Weak references to row/column
- (NSGridRow *) row;
- (NSGridColumn *) column;

// Placement
- (NSGridCellPlacement) xPlacement;
- (void) setXPlacement: (NSGridCellPlacement)x;
- (NSGridCellPlacement) yPlacement;
- (void) setYPlacement: (NSGridCellPlacement)y;  
- (NSGridRowAlignment) rowAlignment;
- (void) setRowAlignment: (NSGridRowAlignment)a;

// Constraints
- (NSArray *) customPlacementConstraints;

@end

/// Column
@interface NSGridColumn : NSObject <NSCoding>

- (NSGridView *) gridView;
- (NSInteger) numberOfCells;
- (NSGridCell *) cellAtIndex:(NSInteger)index;

- (NSGridCellPlacement) xPlacement;
- (void) setXPlacement: (NSGridCellPlacement)x;
- (CGFloat) width;
- (void) setWidth: (CGFloat)f;
- (CGFloat) leadingPadding;
- (void) setLeadingPadding: (CGFloat)f;
- (CGFloat) trailingPadding;
- (void) setTrailingPadding: (CGFloat)f;

- (BOOL) isHidden; 
- (void) mergeCellsInRange: (NSRange)range;

@end

/// Row
@interface NSGridRow : NSObject <NSCoding>

- (NSGridView *) gridView;
- (NSInteger) numberOfCells;
- (NSGridCell *)cellAtIndex:(NSInteger)index;

- (NSGridCellPlacement) yPlacement;
- (void) setYPlacement: (NSGridCellPlacement)y;
- (CGFloat) height;
- (void) setHeight: (CGFloat)f;
- (CGFloat) topPadding;
- (void) setTopPadding: (CGFloat)f;
- (CGFloat) bottomPadding;
- (void) setBottomPadding: (CGFloat)f;

- (BOOL) isHidden; 
- (void) mergeCellsInRange: (NSRange)range;

@end

#if	defined(__cplusplus)
}
#endif

#endif	/* GS_API_MACOSX */

#endif	/* _NSGridView_h_GNUSTEP_GUI_INCLUDE */

