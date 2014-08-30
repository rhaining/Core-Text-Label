//
//  NMHTMLString.m
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

#import "NMHTMLString.h"
#import "NMFont.h"
#import "NMTextHelper.h"

NSString * const kNMImageInfoAttributeName = @"kNMImageInfoAttributeName";
NSString * const kNMImageAttributeName = @"kNMImageAttributeName";
NSString * const kNMImageVerticalOffsetAttributeName = @"kNMImageVerticalOffsetAttributeName";

@interface NMHTMLString(){
    NSMutableDictionary *_styles;
}

@property (nonatomic) BOOL includesSpanTags;
@property (nonatomic) BOOL includesMarkTags;
@property (nonatomic) BOOL includesAnchorTags;
@property (nonatomic) BOOL includesEmoji;
@end

@implementation NMHTMLString

-(instancetype)init{
	if(self = [super init]){
		[self setDefaultStyle:[NMCustomLabelStyle new]];
		_highlightedTextIndex = NSNotFound;
	}
	return self;
}

-(NSMutableDictionary *)styles{
	if(!_styles){
		_styles = [NSMutableDictionary dictionaryWithCapacity:5];
	}
	return _styles;
}
-(void)setStyle:(NMCustomLabelStyle *)style forKey:(NSString *)key{
	self.styles[key.lowercaseString] = style;
	[self clearAttributedString];
}
-(NMCustomLabelStyle *)styleForKey:(NSString *)key{
	return (self.styles)[key];
}
-(void)setDefaultStyle:(NMCustomLabelStyle *)style{
	[self setStyle:style forKey:NMCustomLabelStyleDefaultKey];
}
-(NMCustomLabelStyle *)defaultStyle{
	if(self.styles[NMCustomLabelStyleDefaultKey]){
		return self.styles[NMCustomLabelStyleDefaultKey];
	}else{
		return [NMCustomLabelStyle new];
	}
}

-(void)setShouldLinkTypes:(kNMShouldLink)shouldLinkTypes{
	_shouldLinkTypes = shouldLinkTypes;
	[self.delegate htmlStringShouldEnableUserInteraction:self];
}

-(void)setLinkColor:(UIColor *)color{
	if([self.linkColor isEqual:color]){
		return;
	}
	_linkColor = color;
	[self.delegate htmlStringDidUpdateColor:self];
}
-(void)setActiveLinkColor:(UIColor *)color{
	if([self.activeLinkColor isEqual:color]){
		return;
	}
	_activeLinkColor = color;
}


-(void)setText:(NSString *)text{
	if([self.text isEqualToString:text]){
		return;
	}
	_text = [text copy];
	
	if(self.text && self.text.length > 0){
		NSMutableString *mutableText = [self.text mutableCopy];
		[[NMTextHelper shortTagRegEx] replaceMatchesInString:mutableText options:0 range:NSMakeRange(0, self.text.length) withTemplate:@""];
		_text = [NSString stringWithString:mutableText];
		
		_cleanText = [[NMTextHelper tagRegEx] stringByReplacingMatchesInString:self.text
                                                                       options:0
                                                                         range:NSMakeRange(0, [self.text length])
                                                                  withTemplate:@""];
		[self clearAttributedString];
		
		self.includesSpanTags = ([self.text rangeOfString:@"<span"].location != NSNotFound);
		self.includesMarkTags = ([self.text rangeOfString:@"<mark"].location != NSNotFound);
		self.includesAnchorTags = ([self.text rangeOfString:@"<a"].location != NSNotFound);
		self.includesEmoji = ([self.text rangeOfCharacterFromSet:[NMTextHelper emojiCharacterSet]].location != NSNotFound);
	}else{
		_cleanText = nil;
		[self clearAttributedString];
		self.includesSpanTags = self.includesMarkTags = self.includesAnchorTags = self.includesEmoji = NO;
	}
	_highlightedTextIndex = NSNotFound;
}
-(void)clearAttributedString{
	_attributedString = nil;
}

-(CFIndex) length{
    return self.attributedString.length;
}
-(void)resetAttributedString{
	[self clearAttributedString];
	[self createAttributedString];
}
-(void)createAttributedString{
	if(!self.text || self.text.length == 0){
		//no text. return.
		return;
	}
	
    if(_attributedString){
        return;
    }
	
	NMCustomLabelStyle *defaultStyle = [self defaultStyle];
	
    _attributedString = [[NSMutableAttributedString alloc] initWithString:self.cleanText attributes:@{
                                                                                                      NSForegroundColorAttributeName : defaultStyle.textColor,
                                                                                                      NSFontAttributeName : defaultStyle.font
                                                                                                      }];
    if(defaultStyle.shadow){
        [self.attributedString addAttribute:NSShadowAttributeName value:defaultStyle.shadow range:NSMakeRange(0, self.attributedString.length)];
    }
	
	__block NSInteger locOfTag = -1;
	__block NSInteger totalTagLength = 0;

	if(self.includesSpanTags){
		[[NMTextHelper spanTagRegEx] enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
			int thisTagLength = 14;
			
			UIFont *font = nil;
			UIColor *color = nil, *backgroundColor = nil;
			UIImage *image=nil;
			CGFloat imageVerticalOffset=0;
			NSShadow *shadow=nil;
			if(match.numberOfRanges > 1){
				NSRange tagTypeRange = [match rangeAtIndex:1];
				thisTagLength += tagTypeRange.length;
				NSString *tagInfo = [[self.text substringWithRange:tagTypeRange] lowercaseString];
				tagInfo = [tagInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				NSArray *metadata = [tagInfo componentsSeparatedByString:@"="];
				if(metadata.count == 2 && [metadata[0] isEqualToString:@"class"]){
					NSString *styleKey = metadata[1];
					styleKey = [styleKey stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
					NMCustomLabelStyle *style = (self.styles)[styleKey];
					if(style){
                        font = style.font;
                        color = style.textColor;
                        backgroundColor = style.backgroundColor;
                        shadow = style.shadow;
						image = style.image;
						imageVerticalOffset = style.imageVerticalOffset;
					}
				}
			}
			
			NSRange markupRange = [match range];
			markupRange.length -= thisTagLength;
			markupRange.location -= totalTagLength;
			locOfTag = markupRange.location + markupRange.length;
			totalTagLength += thisTagLength;
			
            if(font && color){
                @try{
                    [self.attributedString addAttributes:@{
                                                           NSFontAttributeName : font,
                                                           NSForegroundColorAttributeName : color
                                                           }
                                                   range:markupRange];
                }@catch(NSException *ex){
                    NSLog(@"crazy shit going on %@", ex);
                }
            }
            if(backgroundColor){
                [self.attributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:markupRange];
            }
            if(shadow){
                [self.attributedString addAttribute:NSShadowAttributeName value:shadow range:markupRange];
            }
			if(image){
				NSDictionary *imageAttr = @{kNMImageAttributeName: image, kNMImageVerticalOffsetAttributeName: @(imageVerticalOffset)};
				NSDictionary *attributes = @{kNMImageInfoAttributeName: imageAttr};
                [self.attributedString addAttributes:attributes range:markupRange];
			}
			
		}];
	}
	
	if(self.includesMarkTags){
		[[NMTextHelper markTagRegEx] enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
			int thisTagLength = 13;
			
			UIFont *font = nil;
			UIColor *color = nil, *backgroundColor = nil;
			UIImage *image=nil;
			CGFloat imageVerticalOffset=0;
			NSShadow *shadow=nil;
			
			NMCustomLabelStyle *style = self.styles[NMCustomLabelStyleMarkKey];
			if(style){
                font = style.font;
                color = style.textColor;
                backgroundColor = style.backgroundColor;
                shadow = style.shadow;
				image = style.image;
				imageVerticalOffset = style.imageVerticalOffset;
			}
			
			NSRange markupRange = [match range];
			markupRange.length -= thisTagLength;
			markupRange.location -= totalTagLength;
			locOfTag = markupRange.location + markupRange.length;
			totalTagLength += thisTagLength;
			
            if(font && color){
                @try{
                    [self.attributedString addAttributes:@{
                                                           NSFontAttributeName : font,
                                                           NSForegroundColorAttributeName : color
                                                           }
                                                   range:markupRange];
                }@catch(NSException *ex){
                    NSLog(@"crazy shit going on %@", ex);
                }
            }
            if(backgroundColor){
                [self.attributedString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:markupRange];
            }
            if(shadow){
                [self.attributedString addAttribute:NSShadowAttributeName value:shadow range:markupRange];
            }
			if(image){
				NSDictionary *imageAttr = @{kNMImageAttributeName: image, kNMImageVerticalOffsetAttributeName: @(imageVerticalOffset)};
				NSDictionary *attributes = @{kNMImageInfoAttributeName: imageAttr};
                [self.attributedString addAttributes:attributes range:markupRange];
			}
			
		}];
	}
	
	if(self.shouldBoldAtNames && (self.shouldLinkTypes & kNMShouldLinkUsernames) ){
		[[NMTextHelper usernameRegEx] enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
			
			if(match.numberOfRanges > 1){
				NSRange range = [match rangeAtIndex:1];
				if(range.length > 1){ //aka not just an '@' symbol
					NSDictionary *attributes;
					if(self.linkColor){
						UIColor *tehLinkColor = self.linkColor;
						if(self.highlightedTextIndex != NSNotFound){
							if(self.highlightedTextIndex >= range.location && self.highlightedTextIndex < range.location+range.length){
								_highlightedTextType = kNMTextTypeUsername;
								tehLinkColor = self.activeLinkColor;
								_highlightedText = [self.cleanText substringWithRange:NSMakeRange(range.location, range.length)];
							}
						}
                        attributes = @{NSForegroundColorAttributeName : tehLinkColor};
					}else{
						NMCustomLabelStyle *boldStyle = (self.styles)[NMCustomLabelStyleBoldKey];
                        attributes = @{NSFontAttributeName : boldStyle.font, NSForegroundColorAttributeName : boldStyle.textColor};
					}
                    [self.attributedString addAttributes:attributes range:range];
				}
			}
		}];
	}
	
	if(self.shouldLinkTypes & kNMShouldLinkURLs){
		NSError *error = NULL;
		NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
		[detector enumerateMatchesInString:self.cleanText options:0 range:NSMakeRange(0, [self.cleanText length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
			
			NSRange matchRange = [match range];
			NSDictionary *attributes;
			if(self.linkColor){
				UIColor *tehLinkColor = self.linkColor;
				if(self.highlightedTextIndex != NSNotFound){
					if(self.highlightedTextIndex >= matchRange.location && self.highlightedTextIndex < matchRange.location+matchRange.length){
						_highlightedTextType = kNMTextTypeLink;
						tehLinkColor = self.activeLinkColor;
						_highlightedText = [self.cleanText substringWithRange:matchRange];
					}
				}
                attributes = @{NSForegroundColorAttributeName : tehLinkColor};
			}else{
				NMCustomLabelStyle *boldStyle = (self.styles)[NMCustomLabelStyleBoldKey];
				if(boldStyle){
                    attributes = @{NSFontAttributeName : boldStyle.font, NSForegroundColorAttributeName : boldStyle.textColor};
				}
			}
			if(attributes){
                [self.attributedString addAttributes:attributes range:matchRange];
			}
		}];
	}
		
	if(self.includesAnchorTags){
		[[NMTextHelper anchorTagRegEx] enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
			int thisTagLength = 8;
			
			UIColor *color = nil;
			NSString *urlString = nil;
			if(match.numberOfRanges > 1){
				NSRange tagTypeRange = [match rangeAtIndex:1];
				thisTagLength += tagTypeRange.length;
				NSString *tagInfo = [[self.text substringWithRange:tagTypeRange] lowercaseString];
				tagInfo = [tagInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				NSRange hrefRange = [tagInfo rangeOfString:@"href="];
				urlString = [tagInfo substringFromIndex:hrefRange.location+hrefRange.length];
				urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'\""]];
                color = self.linkColor;
			}
			
			NSRange markupRange = [match range];
			markupRange.length -= thisTagLength;
			markupRange.location -= totalTagLength;
			locOfTag = markupRange.location + markupRange.length;
			totalTagLength += thisTagLength;
			
			if(self.highlightedTextIndex != NSNotFound){
				if(self.highlightedTextIndex >= markupRange.location && self.highlightedTextIndex < markupRange.location+markupRange.length){
					_highlightedTextType = kNMTextTypeAnchorTag;
                    color = self.activeLinkColor;
					_highlightedText = [self.cleanText substringWithRange:markupRange];
					_highlightedHref = urlString;
				}
			}
			
            if(color){
                @try{
                    [self.attributedString addAttributes:@{
                                                           NSForegroundColorAttributeName : color
                                                           } range:markupRange];
                }@catch(NSException *ex){
                    NSLog(@"crazy shit going on %@", ex);
                }
            }
		}];
	}
	
	if(self.includesEmoji){
		NSRange range = [self.cleanText rangeOfCharacterFromSet:[NMTextHelper emojiCharacterSet] options:NSLiteralSearch range:NSMakeRange(0, self.cleanText.length)];
		while(range.location != NSNotFound){
			NSString *substring = [self.cleanText substringWithRange:range];
			if([substring rangeOfCharacterFromSet:[NMTextHelper alphaNumericCharacterSet] options:NSLiteralSearch range:NSMakeRange(0, substring.length)].location == NSNotFound){
				//			NSLog(@"EMOJIII: %@", substring);
				
				CGFloat emojiScale = 0.8;
				
                UIFont *currentFont = [self.attributedString attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
                UIFont *smallerFont = [currentFont fontWithSize:currentFont.pointSize * emojiScale];
                [self.attributedString addAttributes:@{NSFontAttributeName : smallerFont} range:range];
				
			}
			
			CGFloat location = range.location + range.length;
			range = [self.cleanText rangeOfCharacterFromSet:[NMTextHelper emojiCharacterSet] options:NSLiteralSearch range:NSMakeRange(location, self.cleanText.length-location)];
		}
	}
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.minimumLineHeight = self.lineHeight;
    paragraphStyle.maximumLineHeight = self.lineHeight;
    
    [self.attributedString addAttributes:@{
                                           NSParagraphStyleAttributeName : paragraphStyle,
                                           NSKernAttributeName : @(self.kern)
                                           } range:NSMakeRange(0, self.attributedString.length)];
    
    [self.delegate htmlStringDidUpdateAttributedString:self];

	
}
-(BOOL)hasHighlightedText{
	return _highlightedTextIndex != NSNotFound;
}

-(void)resetHighlightedText{
	_highlightedTextIndex = NSNotFound;
	_highlightedText = nil;
	_highlightedTextType = kNMTextTypeNone;
	_highlightedHref = nil;
}

-(CGFloat)lineHeight{
	if(_lineHeight){
		return [NMFont adjustContentSizeForContentSizeCategory:_lineHeight];
	}else{
		return _lineHeight;
	}
}
@end
