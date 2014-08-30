//
//  NMFont.m
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

#import "NMFont.h"

@implementation NMFont

static NSDictionary *fontAdjustmentMap;

+(BOOL)shouldAdjustSize{
	return ([[UIApplication sharedApplication] respondsToSelector:@selector(preferredContentSizeCategory)]);
}

+(CGFloat)adjustContentSizeForContentSizeCategory:(CGFloat)fontSize{
	if([self shouldAdjustSize]){
		NSString *sizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			fontAdjustmentMap = @{UIContentSizeCategoryExtraSmall : @(-3),
								  UIContentSizeCategorySmall : @(-2),
								  UIContentSizeCategoryMedium : @(-1),
								  UIContentSizeCategoryLarge : @(0),
								  UIContentSizeCategoryExtraLarge : @(1),
								  UIContentSizeCategoryExtraExtraLarge : @(2),
								  UIContentSizeCategoryExtraExtraExtraLarge : @(3),
								  UIContentSizeCategoryAccessibilityMedium : @(3),
								  UIContentSizeCategoryAccessibilityLarge : @(3),
								  UIContentSizeCategoryAccessibilityExtraLarge : @(3),
								  UIContentSizeCategoryAccessibilityExtraExtraLarge : @(3),
								  UIContentSizeCategoryAccessibilityExtraExtraExtraLarge : @(3)
								  };
		});
		fontSize += [fontAdjustmentMap[sizeCategory] floatValue];
	}
	return fontSize;
}

+(UIFont *)fontAdjustedForContentSizeCategory:(UIFont *)font{
	if([self shouldAdjustSize]){
		NSMutableDictionary *attributes = [font.fontDescriptor.fontAttributes mutableCopy];
		CGFloat pointSize = [attributes[UIFontDescriptorSizeAttribute] floatValue];
		pointSize = [self adjustContentSizeForContentSizeCategory:pointSize];
		font = [UIFont fontWithDescriptor:font.fontDescriptor size:pointSize];
	}
	return font;
}

+(UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize{
	fontSize = [self adjustContentSizeForContentSizeCategory:fontSize];
	return [UIFont fontWithName:fontName size:fontSize];
}

@end
