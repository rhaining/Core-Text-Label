//
//  NMHTMLString.h
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


#import <Foundation/Foundation.h>
#import "NMCustomLabelStyle.h"

typedef enum{
	kNMShouldLinkNothing	= 0,
	kNMShouldLinkUsernames	= 1 << 0,
	kNMShouldLinkURLs		= 2 << 0
}kNMShouldLink;

typedef enum{
	kNMTextTypeNone=0,
	kNMTextTypeUsername=1,
	kNMTextTypeLink=2,
	kNMTextTypeAnchorTag=3
}kNMTextType;

extern NSString * const kNMImageInfoAttributeName;
extern NSString * const kNMImageAttributeName;
extern NSString * const kNMImageVerticalOffsetAttributeName;

@protocol NMHTMLStringDelegate;

@interface NMHTMLString : NSObject

@property (nonatomic, readonly) NSMutableAttributedString *attributedString;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, readonly) NSString *cleanText;
@property (nonatomic) CGFloat kern;
@property (nonatomic) NMCustomLabelStyle *defaultStyle;
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) UIColor *activeLinkColor;
@property (nonatomic) BOOL shouldBoldAtNames;
@property (nonatomic) kNMShouldLink shouldLinkTypes;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) CGFloat lineHeight;
@property (nonatomic, weak) id<NMHTMLStringDelegate> delegate;
@property (nonatomic) CGFloat highlightedTextIndex;
@property (nonatomic, readonly) NSString *highlightedHref;
@property (nonatomic, readonly) NSString *highlightedText;
@property (nonatomic, readonly) kNMTextType highlightedTextType;
@property (nonatomic, readonly) CFIndex length;

-(void)setStyle:(NMCustomLabelStyle *)style forKey:(NSString *)key;
-(NMCustomLabelStyle *)styleForKey:(NSString *)key;

-(void)createAttributedString;
-(void)clearAttributedString;
-(void)resetAttributedString;
-(BOOL)hasHighlightedText;
-(void)resetHighlightedText;

@end

@protocol NMHTMLStringDelegate <NSObject>

@required
-(void)htmlStringShouldEnableUserInteraction:(NMHTMLString *)htmlString;
-(void)htmlStringDidUpdateColor:(NMHTMLString *)htmlString;
-(void)htmlStringDidUpdateAttributedString:(NMHTMLString *)htmlString;

@end