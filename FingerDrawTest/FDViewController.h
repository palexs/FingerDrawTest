//
//  FDViewController.h
//  FingerDrawTest
//
//  Created by  on 7/30/12.
//
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import "Canvas.h"

@class Canvas;

@interface FDViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (nonatomic, retain) Canvas *drawingCanvas;

- (IBAction)changeMode:(id)sender;
- (IBAction)makeScreenshotAndSaveToCameraRoll:(id)sender;
- (IBAction)sendScreenshotViaEmail:(id)sender;

@end
