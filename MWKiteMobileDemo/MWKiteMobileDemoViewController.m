//
//  MWKiteMobileDemoViewController.m
//  MWKiteMobileDemo
//
//  Created by Kai Aras on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MWKiteMobileDemoViewController.h"



@implementation MWKiteMobileDemoViewController


-(IBAction)disconnect:(id)sender {
    [[MWMetaWatch sharedWatch]close]; 
}



-(IBAction)startDiscovery:(id)sender {
    [[MWMetaWatch sharedWatch]startSearch];
}


-(IBAction)testWriteBuffer:(id)sender {
    
    [textField resignFirstResponder];
    
    if ([[textField text]length]==0) {
        NSData* data = [MWImageTools imageDataForCGImage:[[UIImage imageNamed:@"010dev.bmp"]CGImage]];
        [[MWMetaWatch sharedWatch]writeImage:data forMode:_currentMode];
        
    }else {
        // NSData *data = [MWImageTools imageDataForText:@"hellop world!"];
        UIImage *img = [MWImageTools imageForText:[textField.text uppercaseString]];
        imageView.image=img;
        [[MWMetaWatch sharedWatch]writeImage:[MWImageTools imageDataForUIImage:img] forMode:_currentMode];
        
    }
    
}


-(IBAction)buzz:(id)sender {
    [[MWMetaWatch sharedWatch]buzz];
    
}


-(void)clear:(id)sender {
    [[MWMetaWatch sharedWatch]loadTemplate:_currentMode];
    [[MWMetaWatch sharedWatch]updateDisplay:_currentMode];

}

-(IBAction)inverDisplay:(id)sender {
    
    if (inverted) {
        [[MWMetaWatch sharedWatch]setDisplayInverted:NO];
        inverted = NO;
    }else {
        [[MWMetaWatch sharedWatch]setDisplayInverted:YES];
        inverted = YES;
    }
}

-(void)changeMode:(id)sender {
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        if (modePicker.superview) {
            [modePicker removeFromSuperview];
        }else {
            
            [self.view addSubview:modePicker];
        }
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Notifications

-(void)mwDidOpenChannel:(NSNotification*)aNotification {
    //    self.isConnected=YES;
    
    [logTextView setText:[[MWMetaWatch sharedWatch]logString] ];
    [logTextView scrollRangeToVisible:NSMakeRange([logTextView.text length], 0)];
    
    NSLog(@"MWMetaWatch open");
    
    [[MWMetaWatch sharedWatch]buzz];
    
}

-(void)mwDidCloseChannel:(NSNotification*)aNotification {
    //    self.isConnected=NO;
    [logTextView setText:[[MWMetaWatch sharedWatch]logString] ];
    [logTextView scrollRangeToVisible:NSMakeRange([logTextView.text length], 0)];
    
}

-(void)mwDidReceiveData:(NSNotification*)aNotification {
    [logTextView setText:[[MWMetaWatch sharedWatch]logString] ];
    [logTextView scrollRangeToVisible:NSMakeRange([logTextView.text length], 0)];
}

-(void)mwDidSendData:(NSNotification*)aNotification {
    [logTextView setText:[[MWMetaWatch sharedWatch]logString] ];
    [logTextView scrollRangeToVisible:NSMakeRange([logTextView.text length], 0)];
    //  NSLog(@"MWMetaWatch data sent %@", [[MWMetaWatch sharedWatch]logString] );
}

-(void)mwDidReceiveButtonPress:(NSNotification*)aNotification {
    NSLog(@"Button %@ pressed",[aNotification object]);
    [logTextView setText:[[MWMetaWatch sharedWatch]logString] ];
    
}







#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [logTextView setFont:[UIFont fontWithName:@"MetaWatch Small caps 8pt" size:8]];
    [logTextView setText:@"started" ];
    
    inverted = NO;
    
    modePicker.frame = CGRectMake(0, self.view.frame.size.height-modePicker.frame.size.height, 320, 216);
    
    _currentMode = kMODE_IDLE;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidOpenChannel:) name:MWKitDidOpenChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidCloseChannel:) name:MWKitDidCloseChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveData:) name:MWKitDidReceiveData object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidSendData:) name:MWKitDidSendData object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveButtonPress:) name:MWKitDidReceivePuttonPress object:nil];
    
    [MWMetaWatch sharedWatch].connectionController = [MWCoreBluetoothController sharedController];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldClear:(UITextField *)aTextField {
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    [textField resignFirstResponder];

    return YES;   
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)aTextField {
    [textField resignFirstResponder];

    return YES;
}

#pragma mark UIPickerViewDataSource


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case kMODE_APPLICATION:
            return @"App";
            break;
        case kMODE_IDLE:
            return @"Idle";
            break;
        case kMODE_NOTIFICATION:
            return @"Notification";
            break;
            
        case kMODE_SCROLL:
            return @"Scroll";
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _currentMode = row;
    
    switch (row) {
        case kMODE_APPLICATION:
            modeButton.title= @"App";
            break;
        case kMODE_IDLE:
            modeButton.title= @"Idle";
            break;
        case kMODE_NOTIFICATION:
            modeButton.title= @"Notification";
            break;
            
        case kMODE_SCROLL:
            modeButton.title= @"Scroll";
            break;
        default:
            return nil;
            break;
    }
    
    [[MWMetaWatch sharedWatch]updateDisplay:_currentMode];


}

@end
