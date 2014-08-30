//
//  NMViewController.m
//
//  Created by Robert Haining
//
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//

#import "NMViewController.h"

@implementation NMViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(30, 45, self.view.frame.size.width-60, 120);

	NMCustomLabel *label1 = [[NMCustomLabel alloc] initWithFrame:frame];
	label1.text = [NSString stringWithFormat:@"<span class='%@'>Your bones don't break, mine do.</span> That's clear. Your cells react to bacteria and viruses differently than mine. <span class='ital_style'>You don't get sick, I do.</span> That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.", NMCustomLabelStyleBoldKey];
	[label1.htmlString setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]]];
	[label1.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] color:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]] forKey:NMCustomLabelStyleBoldKey];
	[label1.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:12] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]] forKey:@"ital_style"];
	label1.htmlString.kern = -0.5;
	label1.htmlString.lineHeight = 12;
	[self.view addSubview:label1];
    
    frame.origin.y = CGRectGetMaxY(label1.frame);
    frame.size.height = 230;
	
	NMCustomLabel *label2 = [[NMCustomLabel alloc] initWithFrame:frame];
	label2.text = [NSString stringWithFormat:@"You think water moves fast? You should see ice. It moves like it has a mind. <span class='%@'>Like it knows it killed the world once and got a taste for murder.</span> After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. <span class='ital_style'>Nature is lethal but it doesn't hold a candle to man.</span>", NMCustomLabelStyleBoldKey];
	[label2.htmlString setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] color:[UIColor colorWithRed:60/255.0 green:87/255.0 blue:186/255.0 alpha:1.0]]];
	[label2.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"Georgia-Bold" size:16] color:[UIColor colorWithRed:98/255.0 green:186/255.0 blue:60/255.0 alpha:1.0]] forKey:NMCustomLabelStyleBoldKey];
	[label2.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"Verdana-Italic" size:15] color:[UIColor colorWithRed:60/255.0 green:87/255.0 blue:186/255.0 alpha:1.0]] forKey:@"ital_style"];
	label2.htmlString.kern = 0.6;
	label2.htmlString.lineHeight = 16;
	[self.view addSubview:label2];
    
    frame.origin.y = CGRectGetMaxY(label2.frame);
    frame.size.height = 50;
	
	NMCustomLabel *label3 = [[NMCustomLabel alloc] initWithFrame:frame];
	label3.text = @"This is a picture of me: <span class='fez'>         </span>  – what do you think?";
	[label3.htmlString setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"Georgia" size:14] color:[UIColor colorWithRed:98/255.0 green:227/255.0 blue:104/255.0 alpha:1]]];
	[label3.htmlString setStyle:[NMCustomLabelStyle styleWithImage:[UIImage imageNamed:@"fez.png"] verticalOffset:-8] forKey:@"fez"];
	label3.htmlString.lineHeight = 25;
	[self.view addSubview:label3];
    
    frame.origin.y = CGRectGetMaxY(label3.frame);
    frame.size.height = 50;
	
	NMCustomLabel *label4 = [[NMCustomLabel alloc] initWithFrame:frame];
	label4.text = @"Dig the text? Check out http://slipsum.com/ .. Also, be sure to follow us @Digg ";
	label4.htmlString.shouldBoldAtNames = YES;
	label4.htmlString.shouldLinkTypes = kNMShouldLinkURLs | kNMShouldLinkUsernames;
	label4.delegate = self;
	label4.htmlString.linkColor = [UIColor colorWithRed:0 green:102/255.0 blue:153/255.0 alpha:1];
	label4.htmlString.activeLinkColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1];
	label4.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	label4.htmlString.kern = 0.6;
	label4.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
	label4.htmlString.lineHeight = 16;
	[self.view addSubview:label4];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
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
