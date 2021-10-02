/*
   NSPopover.m

   The popover class

   Copyright (C) 2013 Free Software Foundation, Inc.

   Author:  Gregory Casamento <greg.casamento@gmail.com>
   Date: 2013

   This file is part of the GNUstep GUI Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#import <Foundation/NSArchiver.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSNotification.h>

#import "AppKit/NSPopover.h"
#import "AppKit/NSViewController.h"
#import "AppKit/NSView.h"
#import "AppKit/NSPanel.h"
#import "AppKit/NSNibLoading.h"
#import "AppKit/NSStoryboard.h"
#import "AppKit/NSGraphics.h"

// Popover private classes

@interface GSPopoverView : NSView
{
  NSView *_contentView;
}
@end

@implementation GSPopoverView

- (instancetype) initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  if (self)
    {
      [self setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    }
  return self;
}

- (void) setContentView: (NSView *)view
{
  if (view != nil)
    {
      ASSIGN(_contentView, view);
      [_contentView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
      [self addSubview: _contentView];
    }
  else
    {
      [_contentView removeFromSuperview];
    }
}

- (void) drawRect: (NSRect)dirtyRect
{
  NSRectEdge sides[] = {NSMinXEdge, NSMaxYEdge, NSMaxXEdge, NSMinYEdge};
  NSColor *black = [NSColor blackColor];
  NSColor *white = [NSColor whiteColor];
  NSColor *colors[] = {white, white, black, black};
  NSRect bounds = [self bounds];

  [super drawRect: dirtyRect];
  NSDrawColorTiledRects(bounds, bounds, sides, colors, 4);
}

@end

@interface GSPopoverPanel : NSPanel
@end

@implementation GSPopoverPanel

- (id) initWithContentRect: (NSRect)contentRect
                 styleMask: (NSUInteger)aStyle
                   backing: (NSBackingStoreType)bufferingType
                     defer: (BOOL)flag
{
  self = [super initWithContentRect: contentRect
                          styleMask: aStyle
                            backing: bufferingType
                              defer: flag];
  if (self)
    {
      [super setContentView: AUTORELEASE([[GSPopoverView alloc] initWithFrame: contentRect])];
    }
  return self;
}

- (void) orderOut: (id)sender
{
  [super orderOut: sender];
  [self close];
}

- (BOOL) canBecomeKeyWindow 
{
  return NO;
}

- (BOOL) canBecomeMainWindow 
{
  return NO;
}

- (void) setContentView: (NSView *)view
{
  [[super contentView] addSubview: view];
}

- (NSView *) contentView
{
  NSArray *subviews = [[super contentView] subviews];

  if ([subviews count] == 0)
    {
      return nil;
    }
  
  return [subviews objectAtIndex: 0];
}

@end

/* Class */
@implementation NSPopover

/* Properties */

/**
 * Sets the animate flag.  If YES then the popover will animate when it appears or disappears.
 */
- (void) setAnimates: (BOOL)flag
{
  _animates = flag;
}

/**
 * Returns current value of the animate flag.
 */
- (BOOL) animates
{
  return _animates;
}

/** 
 * Sets ths appearance of the popover.  Minimal is the default.  HUD is not supported.
 */ 
- (void) setAppearance: (NSPopoverAppearance)value
{
  _appearance = value;
}

/**
 * Returns the current appearance setting.
 */
- (NSPopoverAppearance) appearance
{
  return _appearance;
}

/**
 * Sets current popup behavior.  Valid settings are:
 * NSPopupBehaviorApplicationDefined, NSPopupBehaviorTransient, 
 * NSPopupBehaviorSemiTransient.
 */
- (void) setBehavior: (NSPopoverBehavior)value
{
  _behavior = value;
}

/**
 * Returns current behavior setting
 */
- (NSPopoverBehavior) behavior
{
  return _behavior;
}

/**
 * Accepts an NSSize value for the current content size.
 */
- (void) setContentSize: (NSSize)value
{
  _contentSize = value;
}

/**
 * Returns an NSSize representing the size of the NSPopover content view.
 */
- (NSSize) contentSize
{
  return _contentSize;
}

/**
 * Sets the contentViewController.  If in a storyboard this is automatically set
 * but if this is in a model that is NOT a storyboard (nib, xib, gorm, etc) then there must be
 * a model with the same name as the class name of the contentViewController.  Also,
 * This model must have the "view" outlet set to the view that will be shown
 * in the popup, if both of these conditions are not met, then the code will
 * throw an NSInternalInconsistency exception to report the issue back to the
 * user.
 */
- (void) setContentViewController: (NSViewController *)controller
{
  if ([NSStoryboard mainStoryboard] == nil)
    {
      NSString *controllerClassName = NSStringFromClass([controller class]);
      BOOL loaded = [NSBundle loadNibNamed: controllerClassName
				     owner: controller];
      if (!loaded)
	{
	  [NSException raise: NSInternalInconsistencyException
		      format: @"Could not load controller %@", controllerClassName];
	}
      else
	{
	  if ([controller view] == nil)
	    {
	      [NSException raise: NSInternalInconsistencyException
			  format: @"Loaded controller named %@, but view is not set", controllerClassName];
	    }
	}
    }
  ASSIGN(_contentViewController, controller);
}

/**
 * Returns the current contentViewController.
 */
- (NSViewController *) contentViewController
{
  return _contentViewController;
}

/**
 * Set delegate 
 */
- (void) setDelegate: (id)value
{
  _delegate = value;
}

/**
 * Return delegate
 */
- (id) delegate
{
  return _delegate;
}

/**
 * Set relative position of the popup to the view it is associated with.
 */
- (void) setPositioningRect: (NSRect)value
{
  _positioningRect = value;
}

/**
 * Return the NSRect.
 */
- (NSRect) positioningRect
{
  return _positioningRect;
}

/**
 * Is the popover being shown.
 */
- (BOOL) isShown
{
  return _shown;
}

/* Methods */

/**
 * Close the popover.
 */
- (void) close
{
  [_realPanel close];
  [_realPanel setDelegate:nil];
}

/**
 * Close the popover.
 */
- (IBAction) performClose: (id)sender
{
  [_realPanel performClose:sender];
  [_realPanel setDelegate:nil];
}

/**
 * Show the popover relative to the specified rect on the edge specified.
 */
- (void) showRelativeToRect: (NSRect)positioningRect
                     ofView: (NSView *)positioningView 
              preferredEdge: (NSRectEdge)preferredEdge
{
  NSView *view = nil;
  NSRect screenRect;
  NSRect windowFrame;
  NSRect viewFrame;
  
  [_contentViewController loadView];
  view = [_contentViewController view];
  viewFrame = [view frame];

  if (!_realPanel)
    {
      _realPanel = [[GSPopoverPanel alloc] initWithContentRect: viewFrame
						      styleMask: NSBorderlessWindowMask
							backing: NSBackingStoreRetained
							  defer: NO];
      
      [_realPanel setBackgroundColor: [NSColor darkGrayColor]];
      [_realPanel setReleasedWhenClosed: YES];
      [_realPanel setExcludedFromWindowsMenu: YES];
      [_realPanel setLevel: NSPopUpMenuWindowLevel];
      [_realPanel setAutodisplay: NO];
      [_realPanel setDelegate: self];
      [_realPanel setContentView: view];
    }
  
  screenRect = [[positioningView window] convertRectToScreen:positioningRect];
  windowFrame = [_realPanel frame];
  windowFrame.origin = screenRect.origin;

  if(NSMinXEdge == preferredEdge)
    {
      windowFrame.origin.y -= viewFrame.size.height;
    }
  else if(NSMaxXEdge == preferredEdge)
    {
      windowFrame.origin.y += viewFrame.size.height;
    }
  else if(NSMinYEdge == preferredEdge)
    {
      windowFrame.origin.x -= viewFrame.size.width;
    }
  else if(NSMaxYEdge == preferredEdge)
    {
      windowFrame.origin.x += viewFrame.size.width;
    }

  [_realPanel setFrame: windowFrame display: YES];
  [_realPanel makeKeyAndOrderFront:self];
  
  NSDebugLog(@"Showing relative to in window %@",NSStringFromRect(positioningRect));
  NSDebugLog(@"Showing relative to in screen %@",NSStringFromRect(screenRect));
  
  _shown = YES;
}

- (BOOL) windowShouldClose: (id)sender
{
  return [_delegate popoverShouldClose:self];
}

- (void) windowDidClose: (NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:NSPopoverDidCloseNotification
						      object:self
						    userInfo:nil];
}

- (void) windowWillClose: (NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:NSPopoverWillCloseNotification
						      object:self
						    userInfo:nil];
}

- (id) initWithCoder: (NSCoder *)coder
{
  if (nil != (self = [super initWithCoder:coder]))
    {
      if (YES == [coder allowsKeyedCoding])
	{
	  _appearance = [coder decodeIntForKey: @"NSAppearance"];
	  _behavior   = [coder decodeIntForKey: @"NSBehavior"];
	  _animates   = [coder decodeBoolForKey: @"NSAnimates"];
	  _contentSize.width = [coder decodeDoubleForKey: @"NSContentWidth"];
	  _contentSize.height = [coder decodeDoubleForKey: @"NSContentHeight"];
	  [self setContentViewController:[coder decodeObjectForKey:@"NSContentViewController"]];
	}
      else
	{
	  [coder decodeValueOfObjCType: @encode(NSInteger) at: &_appearance];
	  [coder decodeValueOfObjCType: @encode(NSInteger) at: &_behavior];
	  [coder decodeValueOfObjCType: @encode(BOOL) at: &_animates];
	  [coder decodeValueOfObjCType: @encode(CGFloat) at: &_contentSize.width];
	  [coder decodeValueOfObjCType: @encode(CGFloat) at: &_contentSize.height];
	  [self setContentViewController:[coder decodeObject]];
	}
    }
  return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
  [super encodeWithCoder:coder];
  if (YES == [coder allowsKeyedCoding])
    {
      [coder encodeInt: _appearance forKey: @"NSAppearance"];
      [coder encodeInt: _behavior forKey: @"NSBehavior"];
      [coder encodeBool: _animates forKey: @"NSAnimates"];
      [coder encodeDouble: _contentSize.width forKey: @"NSContentWidth"];
      [coder encodeDouble: _contentSize.height forKey: @"NSContentHeight"];
      [coder encodeObject:_contentViewController forKey:@"NSContentViewController"];
    }
  else
    {
      [coder encodeValueOfObjCType: @encode(NSInteger) at: &_appearance];
      [coder encodeValueOfObjCType: @encode(NSInteger) at: &_behavior];
      [coder encodeValueOfObjCType: @encode(BOOL) at: &_animates];
      [coder encodeValueOfObjCType: @encode(CGFloat) at: &_contentSize.width];
      [coder encodeValueOfObjCType: @encode(CGFloat) at: &_contentSize.height];
      [coder encodeObject:_contentViewController];
    } 
}

@end
