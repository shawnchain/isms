#ifndef IPHONEDEFS_H_
#define IPHONEDEFS_H_

/* Some default UI size */
#define UI_TOP_HUD_HEIGHT 20.0f
#define UI_TOP_NAVIGATION_THIN_BAR_HEIGHT  30.0f
#define UI_TOP_NAVIGATION_BAR_HEIGHT  44.0f
#define UI_BOTTOM_NAVIGATION_BAR_HEIGHT 40.0f
#define UI_BOTTOM_BUTTON_BAR_HEIGHT 49.0f

#define UI_MAIN_VIEW_HEIGHT (480.0f - UI_TOP_HUD_HEIGHT)
#define UI_MAIN_VIEW_CLIENT_HEIGHT (UI_MAIN_VIEW_HEIGHT - UI_TOP_NAVIGATION_BAR_HEIGHT - UI_BOTTOM_BUTTON_BAR_HEIGHT)

// UIButtonBar
enum UIButtonBarStyle {barstyleBlue = 0, barstyleBlack = 1, barstylTransparent=2};

enum kSwipeDirection {kSwipeDirectionUp=1, kSwipeDirectionDown=2, kSwipeDirectionLeft=4, kSwipeDirectionRight=8};

typedef enum
{
	UITransitionShiftImmediate = 0, // actually, zero or anything > 9
	UITransitionShiftLeft = 1,
	UITransitionShiftRight = 2,
	UITransitionShiftUp = 3,
	UITransitionFade = 6,
	UITransitionShiftDown = 7,

	// Customized transition style
	UITransitionFlip = 100,
	UITransitionFlipLeft = 101,
	UITransitionFlipRight = 102,
	UITransitionZoomIn = 103,
	UITransitionZoomOut = 104,
	
	UITransitionShiftUpOverly = 1001,
	UITransitionShiftDownOverly = 1002
} UITransitionStyle;

typedef enum {
	kUIControlEventMouseDown = 1 << 0,
	kUIControlEventMouseMovedInside = 1 << 2, // mouse moved inside control target
	kUIControlEventMouseMovedOutside = 1 << 3, // mouse moved outside control target
	kUIControlEventMouseEntered = 1<<4, //move crossed into active area
	kUIControlEventMouseExited = 1<<5, //move crossed out of active area
	kUIControlEventMouseUpInside = 1 << 6, // mouse up inside control target
	kUIControlEventMouseUpOutside = 1 << 7, // mouse up outside control target
	kUIControlAllEvents = (kUIControlEventMouseEntered | kUIControlEventMouseExited | kUIControlEventMouseDown | kUIControlEventMouseMovedInside | kUIControlEventMouseMovedOutside | kUIControlEventMouseUpInside | kUIControlEventMouseUpOutside)
} UIControlEventMasks;

// Some image buttons
#define BUTTON_COMPOSE @"img:button_compose"

#endif /*IPHONEDEFS_H_*/
