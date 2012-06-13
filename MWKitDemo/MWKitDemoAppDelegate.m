//
//  MWKitDemoAppDelegate.m
//  MWKitDemo
//
//  Created by Kai Aras on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MWKitDemoAppDelegate.h"

@implementation MWKitDemoAppDelegate
@synthesize isConnected;
@synthesize window;


-(IBAction)startSearch:(id)sender {
    [[MWMetaWatch sharedWatch]startSearch];
}

-(IBAction)closeChannel:(id)sender {
    [[MWMetaWatch sharedWatch]close];
    
}


-(IBAction)toggleButtonEnabled:(id)sender {
    NSButton *button = (NSButton*)sender;
    unsigned char b;
    
    switch (button.tag) {
        case 0:
            b=kBUTTON_A;
            break;
        case 1:
            b=kBUTTON_B;
            break;
        case 2:
            b=kBUTTON_C;
            break;
        case 3:
            b=kBUTTON_D;
            break;
        case 4:
            b=kBUTTON_E;
            break;
        case 5:
            b=kBUTTON_F;
            break;
        default:
            break;
    }
    
    if (button.state == NSOnState) {
        [[MWMetaWatch sharedWatch]enableButton:kMODE_IDLE index:b type:kBUTTON_TYPE_IMMEDIATE];
        
    }else {
        [[MWMetaWatch sharedWatch]disableButton:kMODE_IDLE index:b type:kBUTTON_TYPE_IMMEDIATE];
        
    }
}





-(IBAction)buzz:(id)sender {
    [[MWMetaWatch sharedWatch]buzz];
}

-(IBAction)toggleInvert:(id)sender {
    NSButton *button = (NSButton*)sender;
    
    if (button.state == NSOnState) {
        [[MWMetaWatch sharedWatch]setDisplayInverted:YES];
    }else {
        [[MWMetaWatch sharedWatch]setDisplayInverted:NO];
        
    }
}


-(IBAction)sendText:(id)sender {
    NSString *text = [textField stringValue];
    CGImageRef ref = [MWImageTools imageForText:text];
    NSImage *img = [[NSImage alloc]initWithCGImage:ref size:NSMakeSize(96, 96)];
    [imgBufferView setImage:img];
    
    [[MWMetaWatch sharedWatch]writeText:text];

    
}



-(IBAction)testWriteBuffer:(id)sender {
    CGImageRef ref = [MWImageTools imageForText:@"010dev.com"];
    NSImage *img = [[NSImage alloc]initWithCGImage:ref size:NSMakeSize(96, 96)];
    [imgBufferView setImage:img];
    
    //[[MWMetaWatch sharedWatch]writeText:@"010dev.com"];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"5" forKey:@"pushcount"];
    [dict setObject:@"1" forKey:@"phonecount"];
    [dict setObject:@"2" forKey:@"tweetcount"];

    
    [[MWMetaWatch sharedWatch]writeIdleScreenWithData:dict];
}

-(IBAction)loadTemplate:(id)sender {
    [[MWMetaWatch sharedWatch]loadTemplate:kMODE_IDLE];
    [[MWMetaWatch sharedWatch]updateDisplay:kMODE_IDLE];
    
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    /*
        init MWKit with a ConnectionController 
        available are: 
            - MWBluetoothController (uses IOBluetooth to create an RFCOMM channel)
            - MWSerialPortController (writes to the TTY directly, serial port needs to be setup by OS)
     */
    
    [MWMetaWatch sharedWatch].connectionController = [MWBluetoothController sharedController];
    
//    CGImageRef ref = [MWImageTools imageFromText:@"test"];
//    NSImage *img = [[NSImage alloc]initWithCGImage:ref size:NSMakeSize(96, 96)];
//    
//    [imgBufferView setImage:img];
    
    [logTextView setFont:[NSFont fontWithName:@"Courier New" size:12]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidOpenChannel:) name:MWKitDidOpenChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidCloseChannel:) name:MWKitDidCloseChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveData:) name:MWKitDidReceiveData object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidSendData:) name:MWKitDidSendData object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveButtonPress:) name:MWKitDidReceivePuttonPress object:nil];
}



#pragma mark - Notifications

-(void)mwDidOpenChannel:(NSNotification*)aNotification {
    self.isConnected=YES;
    [logTextView setString:[[MWMetaWatch sharedWatch]logString] ];
}

-(void)mwDidCloseChannel:(NSNotification*)aNotification {
    self.isConnected=NO;
    [logTextView setString:[[MWMetaWatch sharedWatch]logString] ];
    
}

-(void)mwDidReceiveData:(NSNotification*)aNotification {
    [logTextView setString:[[MWMetaWatch sharedWatch]logString] ];
}

-(void)mwDidSendData:(NSNotification*)aNotification {
    [logTextView setString:[[MWMetaWatch sharedWatch]logString] ];
}

-(void)mwDidReceiveButtonPress:(NSNotification*)aNotification {
    NSLog(@"Button %@ pressed",[aNotification object]);
    [logTextView setString:[[MWMetaWatch sharedWatch]logString] ];
    
}

@end
