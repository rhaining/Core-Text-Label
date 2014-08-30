//
//  NMCustomLabel.h
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

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "NMCustomLabelStyle.h"
#import "NMHTMLString.h"


@class NMCustomLabel;
@protocol NMCustomLabelDelegate;

typedef enum{
	kNMAlignTop=0,
	kNMAlignCenter=1,
	kNMAlignBottom=2
} kNMLabelVerticalAlign;

@interface NMCustomLabel : UILabel <UIGestureRecognizerDelegate, NMHTMLStringDelegate>

@property (nonatomic, readonly) NMHTMLString *htmlString;
@property (nonatomic, weak) id<NMCustomLabelDelegate> delegate;
@property (nonatomic) kNMLabelVerticalAlign verticalAlign;
@property (nonatomic, readonly) UILongPressGestureRecognizer *pressRecog;

-(void)redraw;

@end

@protocol NMCustomLabelDelegate <NSObject>
@optional
-(void)customLabelDidBeginTouch:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog;
-(void)customLabelDidBeginTouchOutsideOfHighlightedText:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog;
-(void)customLabel:(NMCustomLabel *)customLabel didChange:(UILongPressGestureRecognizer *)recog;
-(void)customLabelDidEndTouch:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog;
-(void)customLabelDidEndTouchOutsideOfHighlightedText:(NMCustomLabel *)customLabel recog:(UILongPressGestureRecognizer *)recog;
-(void)customLabel:(NMCustomLabel *)customLabel didSelectText:(NSString *)text type:(kNMTextType)textType;
@end


