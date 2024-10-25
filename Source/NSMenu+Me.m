
#import "AppKit/NSMenu+Me.h"
#import <Foundation/NSUserDefaults.h>
#import <Foundation/NSValue.h>

CGFloat limitedValue(CGFloat minValue, CGFloat maxValue, CGFloat testValue)
{
  if (testValue < minValue)
    return minValue;
  if (testValue > maxValue)
    return maxValue;
  return testValue;
}

NSPoint KFFixMainMenuInitialOrigin(NSPoint origin) {
  const CGFloat MAX_MARGIN = 200.0f;
  NSPoint result = origin;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSValue *leftMargin = [defaults objectForKey: @ "GSMenuOriginLeftMargin"];
  NSValue *topMargin  = [defaults objectForKey: @ "GSMenuOriginTopMargin"];
  // dirty hook
  // @see https://oleb.net/blog/2014/02/nsuserdefaults-handling-default-values
  if (leftMargin == nil)
    {
      leftMargin = [NSNumber numberWithShort: 0.0f];
    }
  if (topMargin == nil)
    {
      topMargin = [NSNumber numberWithShort: 0.0f];
    }
  result.x += limitedValue(0, MAX_MARGIN, fabs([((NSNumber *)leftMargin) floatValue]));
  result.y -= limitedValue(0, MAX_MARGIN, fabs([((NSNumber *)topMargin) floatValue]));
  return result;
}
