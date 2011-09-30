//
//  MWKitDemoAppDelegate.h
//  MWKitDemo
//
//  Created by Kai Aras on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




#import <Cocoa/Cocoa.h>
#import <MWKit/MWkit.h>
#import <MWKit/MWImageTools.h>

#import <MWKit/MWBluetoothController.h>
#import <MWKit/MWSerialPortController.h>

@interface MWKitDemoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet NSTextView *logTextView;
    IBOutlet NSImageView *imgBufferView;
    IBOutlet NSTextField *textField;
    
}

@property (assign) BOOL isConnected;

@property (assign) IBOutlet NSWindow *window;


-(IBAction)startSearch:(id)sender;
-(IBAction)closeChannel:(id)sender;

-(IBAction)sendText:(id)sender;
-(IBAction)toggleButtonEnabled:(id)sender;
-(IBAction)buzz:(id)sender;
-(IBAction)toggleInvert:(id)sender;
-(IBAction)testWriteBuffer:(id)sender;
-(IBAction)loadTemplate:(id)sender;
@end
