//
//  NMCustomLabelStyle.m
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

#import "NMCustomLabelStyle.h"
#import "NMFont.h"

NSString * const NMCustomLabelStyleDefaultKey = @"nm-default-style";
NSString * const NMCustomLabelStyleBoldKey = @"nm-bold-style";
NSString * const NMCustomLabelStyleItalicKey = @"nm-ital-style";
NSString * const NMCustomLabelStyleMarkKey = @"nm-mark-style";

@implementation NMCustomLabelStyle

-(id)copyWithZone:(NSZone *)zone{
	NMCustomLabelStyle *style = [NMCustomLabelStyle new];
	style.fontName = [self.fontName copyWithZone:zone];
	style.fontSize = self.fontSize;
	style.textColor = [self.textColor copyWithZone:zone];
	style.image = self.image;
	style.imageVerticalOffset = self.imageVerticalOffset;
	style.backgroundColor = [self.backgroundColor copyWithZone:zone];
	style.shadowOffset = self.shadowOffset;
	style.shadowBlurRadius = self.shadowBlurRadius;
	style.shadowColor = [self.shadowColor copyWithZone:zone];
	return style;
}

+(id)styleWithFont:(UIFont *)font color:(UIColor *)color{
	NMCustomLabelStyle *style = [NMCustomLabelStyle new];
	[style setFont:font];
	style.textColor = color;
	return style;
}
+(id)styleWithImage:(UIImage *)image verticalOffset:(CGFloat)verticalOffset{
	NMCustomLabelStyle *style = [NMCustomLabelStyle new];
	style.image = image;
	style.imageVerticalOffset = verticalOffset;
	return style;
}
+(id)styleWithImage:(UIImage *)image{
	return [self styleWithImage:image verticalOffset:0];
}

-(UIFont *)font{
	if(!self.fontName){
		self.fontName = @"Helvetica";
	}
	if (self.fontSize == 0) {
		self.fontSize = 12;
	}
	return [UIFont fontWithName:self.fontName size:self.fontSize];
}
-(void)setFont:(UIFont *)font{
	self.fontName = font.fontName;
	self.fontSize = font.pointSize;
}
-(CGFloat)fontSize{
	return [NMFont adjustContentSizeForContentSizeCategory:_fontSize];
}

-(NSString *)description{
	NSString *description = [super description];
	description = [NSString stringWithFormat:@"%@ <%@ (%f) – %@>", description, _fontName, _fontSize, _textColor];
	return description;
}

#pragma mark - shadow
-(void)createShadow{
	if(!self.shadow){
		_shadow = [NSShadow new];
	}
}
-(CGSize)shadowOffset{
	return self.shadow.shadowOffset;
}
-(void)setShadowOffset:(CGSize)shadowOffset{
	[self createShadow];
	self.shadow.shadowOffset = shadowOffset;
}
-(CGFloat)shadowBlurRadius{
	return self.shadow.shadowBlurRadius;
}
-(void)setShadowBlurRadius:(CGFloat)shadowBlurRadius{
	[self createShadow];
	self.shadow.shadowBlurRadius = shadowBlurRadius;
}
-(UIColor *)shadowColor{
	return self.shadow.shadowColor;
}
-(void)setShadowColor:(UIColor *)shadowColor{
	[self createShadow];
	self.shadow.shadowColor = shadowColor;
}

@end
