//
//  LTUCameraView.h
//
//  Copyright 2012 LTU technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 LTUCameraView

 `LTUCameraView` is a subclass of `UIView` that displays a camera preview, and lets you capture a `UIImage` frame.

 To use this:

  - Just simply create a View in NIB/StoryBoard and use this class instead of `UIView`.
  - Create an IBOutlet in your ViewController with `LTUCameraView` to use the extra start/pause/capture features
 */
@interface LTUCameraView : UIView

/**
 A state whether the camera is paused or not
 */
@property BOOL isPaused;

/**
  Starts the preview of the camera
 */
- (void)startPreview;

/**
 Pauses the preview of the camera, this will show the last frame in the View
 */
- (void)pausePreview;

/**
 Capture a frame of the displayed camera view

 @return The captured image as `UIImage`
 */
- (UIImage *)captureImage;

@end
