//
//  ViewController.m
//  LTUMobileiOSExampleQR
//
//  Created by Adam Bednarek on 4/3/13.
//  Copyright (c) 2013 LTU technologies. All rights reserved.
//

#import <LTUSDK/LTUManager.h>

#import "ZBarSDK.h"
#import "ViewController.h"

// Enter your project ID
static NSInteger const projectID = -1;

@interface ViewController ()

@property (nonatomic, strong) LTUCameraView *camView;

@property (nonatomic, weak) IBOutlet UIButton *searchImageButton;
@property (nonatomic, weak) IBOutlet UIView *searchingView;

// QR Code scanning properties
@property BOOL isScanningForQRCodes;

- (IBAction)cancelSearch:(id)sender;
- (IBAction)searchImage:(id)sender;

// Helper method to display a successful searchImage result
- (void)displaySuccessfulSearchImageResult:(LTUQuery *)queryResult;

// Helper method to display an error message
- (void)displayError:(NSError *)error;

// QR Code Scanning methods
- (void)startQRScanning;
- (void)stopQRScanning;
- (void)displayQRCodeResult:(NSString *)qrData;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // The Camera preview has an aspect ratio of 1.3, the screen aspect ratio
  // has an aspect ratio of the height / width.  This changes between iPhone 4, 5 and iPad)
  // To fit the preview nicely, we normalize this by making the preview frame wider
  CGFloat screenAspectRatio = self.view.frame.size.height / self.view.frame.size.width;
  CGFloat normalizeRatio = screenAspectRatio / 1.3;
  CGRect cameraFrame = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width * normalizeRatio,
                                  self.view.frame.size.height);
  self.camView = [[LTUCameraView alloc] initWithFrame:cameraFrame];
  // Insert the camview below the views created by storyboard
  [self.view insertSubview:self.camView atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self startQRScanning];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self stopQRScanning];
}

- (void)viewDidUnload
{
  [self setSearchingView:nil];
  [self setSearchImageButton:nil];
  [super viewDidUnload];
}

- (IBAction)cancelSearch:(id)sender
{
  [[LTUManager sharedManager] cancelAllSearchRequests];
  self.searchingView.hidden = YES;
  self.searchImageButton.hidden = NO;
}

- (IBAction)searchImage:(id)sender
{
  self.searchingView.hidden = NO;
  self.searchImageButton.hidden = YES;
  UIImage *image = [self.camView captureImage];
  NSArray *projectIDs = [NSArray arrayWithObject:[NSNumber numberWithInt:projectID]];
  [[LTUManager sharedManager] searchInProjects:projectIDs withImage:image
   success:^(LTUQuery *queryResult)
   {
     [self displaySuccessfulSearchImageResult:queryResult];
   }
   failure:^(NSError *error)
   {
      [self displayError:error];
   }
   finished:^
   {
     self.searchingView.hidden = YES;
     self.searchImageButton.hidden = NO;
     // Pause QR Scanning when displaying IR result/error
     [self stopQRScanning];
   }];
}

- (void)displaySuccessfulSearchImageResult:(LTUQuery *)queryResult
{
  NSString *title;
  NSString *message;

  // If there was no match, the matchesList will be empty
  if ([queryResult.matchesList count] == 0)
  {
    title = @"No Match!";
    message = @"Please try another image.";
  }
  else
  {
    // The queryResult.matchesList is an NSArray of LTUMatchedVisual objects
    // The LTUMatchedVisual object contains the LTUVisual and LTUMatchedImage
    LTUVisual *firstMatchedVisual = [[queryResult.matchesList objectAtIndex:0] matched_visual];
    title = firstMatchedVisual.title;

    // LTUMetaData is optional via the API.  If it exists, there will be an NSArray of LTUMetaData Objects
    if ([firstMatchedVisual.metadataList count] != 0)
    {
      // For this example, the value of the first metadata object is displayed
      LTUMetaData *firstMetadata = [firstMatchedVisual.metadataList objectAtIndex:0];
      message = firstMetadata.value;
    }
    else
    {
      message = @"No Visual Info Attached";
    }
  }

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)displayError:(NSError *)error
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[error localizedDescription]
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)startQRScanning
{
  if (!self.isScanningForQRCodes)
  {
    self.isScanningForQRCodes = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      while (self.isScanningForQRCodes)
      {
        @autoreleasepool
        {
          ZBarImageScanner *zBarScanner = [[ZBarImageScanner alloc] init];
          [zBarScanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
          [zBarScanner setEnableCache:NO];
          ZBarImage *scannedImage = [[ZBarImage alloc] initWithCGImage:[[self.camView captureImage] CGImage]];
          NSInteger barCodeID = [zBarScanner scanImage:scannedImage];
          if (barCodeID >= 1 && zBarScanner.results > 0)
          {
            // Only care about QR Codes
            for (ZBarSymbol *symbol in zBarScanner.results)
            {
              if ([symbol.typeName isEqualToString:@"QR-Code"])
              {
                // Cancel Search Image if we're searching an image
                [self performSelectorOnMainThread:@selector(cancelSearch:) withObject:nil waitUntilDone:YES];
                NSString *qrData = symbol.data;
                [self stopQRScanning];
                [self performSelectorOnMainThread:@selector(displayQRCodeResult:) withObject:qrData waitUntilDone:NO];
                break;
              }
            }
          }
        }
      }
    });
  }
}

- (void)stopQRScanning
{
  self.isScanningForQRCodes = NO;
}

- (void)displayQRCodeResult:(NSString *)qrData
{
  UIAlertView *qrAlert = [[UIAlertView alloc] initWithTitle:@"QR Match!"
                                                    message:[NSString stringWithFormat:@"%@", qrData]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
  [qrAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  // Resume QR Scanning
  [self startQRScanning];
}


@end
