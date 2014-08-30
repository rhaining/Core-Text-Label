//
//  NMCustomLabelStyle.h
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
#import <CoreText/CoreText.h>

extern NSString * const NMCustomLabelStyleDefaultKey;
extern NSString * const NMCustomLabelStyleBoldKey;
extern NSString * const NMCustomLabelStyleItalicKey;
extern NSString * const NMCustomLabelStyleMarkKey;

@interface NMCustomLabelStyle : NSObject <NSCopying> 

@property (nonatomic, copy) NSString *fontName;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat imageVerticalOffset;

@property (nonatomic, readonly) UIFont *font;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, readonly) NSShadow *shadow;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowBlurRadius;
@property (nonatomic, strong) UIColor *shadowColor;

+(id)styleWithFont:(UIFont *)font color:(UIColor *)color;
+(id)styleWithImage:(UIImage *)image verticalOffset:(CGFloat)verticalOffset;
+(id)styleWithImage:(UIImage *)image;

-(void)setFont:(UIFont *)font;

@end
