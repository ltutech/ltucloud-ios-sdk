//
//  LTUCameraView.m
//
//  Copyright 2012 LTU technologies. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

#import "LTUCameraView.h"

@interface LTUCameraView () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (atomic, strong) CIImage                        *nextImage;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer  *previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput    *videoDataOutput;
@property (nonatomic, assign) dispatch_queue_t            videoDataOutputQueue;

@end


@implementation LTUCameraView

// Clean up Capture setup
- (void)teardownAVCapture
{
    [self.previewLayer removeFromSuperlayer];
}

- (void) dealloc
{
    [self teardownAVCapture];
}

- (void)startPreview
{
    if (!self.previewLayer.session.isRunning)
    {
        [self.previewLayer.session startRunning];
        self.isPaused = NO;
    }
}

- (void)pausePreview
{
    [self.previewLayer.session stopRunning];
    self.isPaused = YES;
}

- (UIImage *)captureImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef ref = [context createCGImage:self.nextImage fromRect:self.nextImage.extent];
    UIImage *image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(ref);
    return image;
}

// This init gets called when view is being created by StoryBoard or Nib
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupAVCapture];
    }
    return self;
}

// This init gets called when we're adding the view via code
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupAVCapture];
    }
    return self;
}

- (void)displayError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)setupAVCapture
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [AVCaptureSession new];
    
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    // Select a video device, and make it the input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error == nil)
    {
        [session addInput:deviceInput];
        
        // Make a video data output
        self.videoDataOutput = [AVCaptureVideoDataOutput new];
        
        [session addOutput:self.videoDataOutput];
        
        // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
        NSDictionary *colorSpaceSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                       forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        self.videoDataOutput.videoSettings = colorSpaceSettings;
        
        // discard if the data output queue is blocked (as we process the captured image)
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        
        // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        // see the header doc for setSampleBufferDelegate:queue: for more information
        self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        self.previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
        //      self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill	;
        CALayer *rootLayer = self.layer;
        rootLayer.masksToBounds = YES;
        self.previewLayer.frame = rootLayer.bounds;
        [rootLayer addSublayer:self.previewLayer];
    }
    else
    {
        [self displayError:error];
        [self teardownAVCapture];
    }
    [session startRunning];
}

// This gets called once we get our first buffer..
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldNotPropagate);
    self.nextImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *) attachments];
    
    if (attachments)
    {
        CFRelease(attachments);
    }
}

@end
