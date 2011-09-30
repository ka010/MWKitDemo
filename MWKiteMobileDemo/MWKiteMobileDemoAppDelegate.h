//
//  MWKiteMobileDemoAppDelegate.h
//  MWKiteMobileDemo
//
//  Created by Kai Aras on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MWKiteMobileDemoViewController;

@interface MWKiteMobileDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MWKiteMobileDemoViewController *viewController;

@end
