//
//  FDViewController.m
//  FingerDrawTest
//
//  Created by  on 7/30/12.
//
//

#import "FDViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FDViewController ()

@end

@implementation FDViewController

@synthesize modeSegmentedControl, drawingCanvas;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.drawingCanvas = [[Canvas alloc] initWithFrame:CGRectMake(0, 65, 320, 395)];
    [self.drawingCanvas setUserInteractionEnabled:YES];
    
    if (modeSegmentedControl.selectedSegmentIndex == 0) {
        [self.view addSubview:self.drawingCanvas];
        [self.view bringSubviewToFront:self.drawingCanvas];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.drawingCanvas = nil;
    self.modeSegmentedControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)changeMode:(id)sender
{
    if (modeSegmentedControl.selectedSegmentIndex == 0) {
        [self.view addSubview:self.drawingCanvas];
        [self.view bringSubviewToFront:self.drawingCanvas];
    } else {
        self.drawingCanvas.image = nil;
        [self.drawingCanvas removeFromSuperview];
    }
}

- (UIImage*)getScreenshot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)makeScreenshotAndSaveToCameraRoll:(id)sender
{
    UIImage *screenImage = [self getScreenshot];
	UIImageWriteToSavedPhotosAlbum(screenImage, self, nil, nil);
}

- (void)sendScreenshotViaEmail:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;    
    
    [picker setSubject:@"App Screenshot"];

    UIImage *emailImage = [self getScreenshot];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"screenshot"];

    NSString *emailBody = [NSString stringWithFormat:@"This is a screenshot from the app."];
    [picker setMessageBody:emailBody isHTML:YES];
    
    picker.navigationBar.barStyle = UIBarStyleBlack;    
    [self presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            
        break;
    }
    NSLog(@"RESULT: %i", result);
    
    self.drawingCanvas.image = nil;
    [self dismissModalViewControllerAnimated:YES];
}

@end
