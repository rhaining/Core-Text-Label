//
//  NMViewController.m
//  CoreTextSample
//
//  Created by Robert Haining on 3/21/12.
//  Copyright (c) 2012 News.me. All rights reserved.
//

#import "NMViewController.h"

@interface NMViewController ()

@end

@implementation NMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	NMCustomLabel *label1 = [[NMCustomLabel alloc] initWithFrame:CGRectMake(30, 15, self.view.frame.size.width-60, 200)];
	label1.text = @"<b>Your bones don't break, mine do.</b> That's clear. Your cells react to bacteria and viruses differently than mine. <i>You don't get sick, I do.</i> That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.";
	label1.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	label1.fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
	label1.fontItalic = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:12];
	label1.kern = -0.5;
	label1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
	label1.textColorBold = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
	label1.lineHeight = 12;
	[self.view addSubview:label1];
	
	NMCustomLabel *label2 = [[NMCustomLabel alloc] initWithFrame:CGRectMake(30, 125, self.view.frame.size.width-60, 250)];
	label2.text = @"You think water moves fast? You should see ice. It moves like it has a mind. <b>Like it knows it killed the world once and got a taste for murder.</b> After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. <i>Nature is lethal but it doesn't hold a candle to man.</i>";
	label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	label2.fontBold = [UIFont fontWithName:@"Georgia-Bold" size:16];
	label2.fontItalic = [UIFont fontWithName:@"Verdana-Italic" size:15];
	label2.kern = 0.6;
	label2.textColor = [UIColor colorWithRed:60/255.0 green:87/255.0 blue:186/255.0 alpha:1.0];
	label2.textColorBold = [UIColor colorWithRed:98/255.0 green:186/255.0 blue:60/255.0 alpha:1.0];
	label2.lineHeight = 16;
	[self.view addSubview:label2];
	
	NMCustomLabel *label3 = [[NMCustomLabel alloc] initWithFrame:CGRectMake(30, 400, self.view.frame.size.width-60, 50)];
	label3.text = @"Dig the text? Check out http://slipsum.com/ .. Also, be sure to follow us @NewsDotMe ";
	label3.shouldBoldAtNames = YES;
	label3.shouldLinkTypes = kNMShouldLinkURLs | kNMShouldLinkUsernames;
	label3.delegate = self;
	label3.linkColor = [UIColor colorWithRed:0 green:102/255.0 blue:153/255.0 alpha:1];
	label3.activeLinkColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1];
	label3.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	label3.kern = 0.6;
	label3.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
	label3.lineHeight = 16;
	[self.view addSubview:label3];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

#pragma mark - NMCustomLabelDelegate
-(void)customLabelDidBeginTouch:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog{}
-(void)customLabelDidBeginTouchOutsideOfHighlightedText:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog{}
-(void)customLabel:(NMCustomLabel *)customLabel didChange:(UILongPressGestureRecognizer *)recog{}
-(void)customLabelDidEndTouch:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog{}
-(void)customLabelDidEndTouchOutsideOfHighlightedText:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog{}
-(void)customLabel:(NMCustomLabel *)customLabel didSelectText:(NSString *)text type:(kNMTextType)textType{
	switch (textType) {
		case kNMTextTypeLink:
			NSLog(@"loading: %@", text);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:text]];
			break;
		case kNMTextTypeUsername:
			NSLog(@"loading: twitter.com/%@", text);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", text]]];
			break;
		default:
			break;
	}
}


@end
