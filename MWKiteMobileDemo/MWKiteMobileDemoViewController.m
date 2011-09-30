//
//  MWKiteMobileDemoViewController.m
//  MWKiteMobileDemo
//
//  Created by Kai Aras on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MWKiteMobileDemoViewController.h"

@implementation MWKiteMobileDemoViewController


CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    
    NSLog(@"size: %u:%u",pixelsHigh,pixelsWide);
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 1);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceGray();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaNone);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}



UIImage* ManipulateImagePixelData(CGImageRef inImage)
{
    
    
    // Create the bitmap context
    CGContextRef cgctx = CreateARGBBitmapContext(inImage);
    if (cgctx == NULL) 
    { 
        // error creating context
        return;
    }
    
    // Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}}; 
    
    // Draw the image to the bitmap context. Once we draw, the memory 
    // allocated for the context for rendering will then contain the 
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage); 
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    const char *data = CGBitmapContextGetData (cgctx);
    
    int x,y=0;
    for (y=0; y<h; y++) {
        NSString *rowString = @"";
        
        unsigned char *p;
        p= data + 96*y;
        for (x=0; x<w; x++) {
            // do your thing
            
            //            if (p[0]==0xff) {
            //                p[0]=0x00;
            //            }else {
            //                 p[0]=0xff;
            //            }
            
            rowString = [rowString stringByAppendingFormat:@"0x%02x ",p[0]];
            
            // p[0] is red, p[1] is green, p[2] is blue, p[3] can be alpha if spp==4
            p += 1;
        }
        // NSLog(@"%@",rowString);
    }
    
    [[MWMetaWatch sharedWatch]writeImage:[NSData dataWithBytes:data length:96*96]];
    
    CGImageRef imgRef = CGBitmapContextCreateImage(cgctx);
    UIImage* img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    
    // When finished, release the context
    CGContextRelease(cgctx); 
    // Free image data memory for the context
    
    if (data)
    {
        free(data);
    }
    
    
    
    
    return img;
}






-(UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];  
    CGSize size  = CGSizeMake(96, 96);
    
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0 
        UIGraphicsBeginImageContext(size);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger 
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    //[text drawAtPoint:CGPointMake(0.0, 40.0) withFont:font];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor]CGColor]);
    CGContextFillRect(ctx, CGRectMake(0, 0, 96, 96));
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor]CGColor]);
    
    [text drawInRect:CGRectMake(0, 35, 96, 51) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    
    return image;
}





-(IBAction)disconnect:(id)sender {
    [[MWMetaWatch sharedWatch]close]; 
}



-(IBAction)startDiscovery:(id)sender {
    [[MWMetaWatch sharedWatch]openChannel];
}


-(IBAction)testWriteBuffer:(id)sender {
    
    [textField resignFirstResponder];
    
    if ([[textField text]length]==0) {
        [[MWMetaWatch sharedWatch]writeNotification:@"test notification" withContent:@"test content"];

    }else {
        [[MWMetaWatch sharedWatch]writeText:textField.text];

    }
    

    //    [[MWMetaWatch sharedWatch]testWriteBuffer];
}


-(IBAction)buzz:(id)sender {
    [[MWMetaWatch sharedWatch]buzz];
    
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





-(void)makeImage {
   
//    CGSize size = CGSizeMake(96,96);
//
//    
//    if (UIGraphicsBeginImageContextWithOptions != NULL)
//        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
//    else
//        // iOS is < 4.0 
//        UIGraphicsBeginImageContext(size);
//    
//    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger 
//    //
//    // CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
//    
//    // draw in context, you can use also drawInRect:withFont:
//    [@"Hello from iOS" drawAtPoint:CGPointMake(0.0, 0.0) withFont:[UIFont fontWithName:@"Helvetica" size:15]];
//    
//    // transfer image
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();    
    
    
    CGImageRef inImage =[[self imageFromText:@"Hello from iOS :)"]CGImage]; //[[UIImage imageNamed:@"010dev.bmp"]CGImage]; // 
    UIImage *img = ManipulateImagePixelData(inImage);    
    
      [imageView setImage:[self imageFromText:@"Hello from iOS :)"]];
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [logTextView setFont:[UIFont fontWithName:@"mw8_5" size:16]];
    [logTextView setText:@"started" ];

    inverted = NO;
    
    

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidOpenChannel:) name:MWKitDidOpenChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidCloseChannel:) name:MWKitDidCloseChannelNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveData:) name:MWKitDidReceiveData object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidSendData:) name:MWKitDidSendData object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mwDidReceiveButtonPress:) name:MWKitDidReceivePuttonPress object:nil];
    
    [MWMetaWatch sharedWatch].connectionController = [MWBTStackController sharedController];
    
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

@end
