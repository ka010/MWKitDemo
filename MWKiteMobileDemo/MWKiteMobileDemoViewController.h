//
//  MWKiteMobileDemoViewController.h
//  MWKiteMobileDemo
//
//  Created by Kai Aras on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWKit/MWKit.h>
#import "MWCoreBluetoothController.h"
@interface MWKiteMobileDemoViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate> {
    BOOL inverted;
    IBOutlet UITextView *logTextView;
    IBOutlet UIImageView *imageView;
    IBOutlet UITextField *textField;
    IBOutlet UIPickerView *modePicker;
    IBOutlet UIBarButtonItem *modeButton;
    int _currentMode;

}

-(IBAction)startDiscovery:(id)sender;
-(IBAction)testWriteBuffer:(id)sender;
-(IBAction)buzz:(id)sender;
-(IBAction)inverDisplay:(id)sender;
-(IBAction)clear:(id)sender;
-(IBAction)disconnect:(id)sender;

-(IBAction)changeMode:(id)sender;
@end
