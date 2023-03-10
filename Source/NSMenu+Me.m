
#import "AppKit/NSMenu+Me.h"

NSPoint KFFixMainMenuInitialOrigin(NSPoint origin)
{
  NSPoint result = origin;
  result.x += 50;
  result.y -= 50;
  return result;
}
