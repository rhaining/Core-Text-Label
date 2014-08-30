//
//  NMCustomLabel.m
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

#import "NMCustomLabel.h"
#import "NMTextHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface NMCustomLabel()
@property (nonatomic, readonly) CTFramesetterRef framesetter;
@property (nonatomic, readonly) CTFrameRef ctFrame;

@property (nonatomic, readonly) BOOL recogOutOfBounds;
@end

@implementation NMCustomLabel

@synthesize htmlString = _htmlString;

-(void)setDefaults{
	self.backgroundColor = [UIColor whiteColor];
	self.numberOfLines = 0;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment{
	[super setTextAlignment:textAlignment];
    self.htmlString.textAlignment = textAlignment;
}
-(instancetype)initWithFrame:(CGRect)frame{
	if(self = [super initWithFrame:frame]){
		[self setDefaults];
	}
	return self;
}
- (instancetype)init{
    if (self = [super init]) {
		[self setDefaults];
    }
    return self;
}
-(void)dealloc{
	if(self.framesetter){ CFRelease(self.framesetter); }
	if(self.ctFrame){ CFRelease(self.ctFrame); }
}
-(void)redraw{
	[self clearAttrString];
	[self setNeedsDisplay];
}
-(void)clearAttrString{
	[self.htmlString clearAttributedString];
}
-(NSString *)cleanText{
	return self.htmlString.cleanText;
}
-(void)setTextColor:(UIColor *)textColor{
	[self.htmlString.defaultStyle setTextColor:textColor];
}
-(UIColor *)textColor{
	return self.htmlString.defaultStyle.textColor;
}
-(void)setText:(NSString *)_text{
	if([self.text isEqualToString:_text]){
		return;
	}
	
	[super setText:_text];
	[self clearAttrString];

	self.htmlString.text = _text;
	
	if(self.text && self.text.length > 0){
		BOOL isBaseRTL = [NMTextHelper textIsBaseRTL:self.text];
		if(self.textAlignment == NSTextAlignmentLeft && isBaseRTL){
			self.textAlignment = NSTextAlignmentRight;
		}else if(self.textAlignment == NSTextAlignmentRight && !isBaseRTL){
			self.textAlignment = NSTextAlignmentLeft;
		}
	}else{
		if(self.framesetter){
			CFRelease(self.framesetter);
			_framesetter = nil;
		}
	}
	[self setNeedsDisplay];
}

-(NMHTMLString *)htmlString{
	if(!_htmlString){
		_htmlString = [[NMHTMLString alloc] init];
		_htmlString.delegate = self;
	}
	return _htmlString;
}

-(void)createAttributedString{
	[self.htmlString createAttributedString];
}
-(void)createAttributedStringIfNeeded{
	if(!self.htmlString.attributedString){
		[self createAttributedString];
	}
}

- (CGSize)sizeThatFits:(CGSize)size{
	if(!self.text || self.text.length == 0){
		return CGSizeZero;
	}

	if(size.width < 1){ size.width = CGFLOAT_MAX; }
	if(size.height < 1){ size.height = CGFLOAT_MAX; }
	
	[self createAttributedStringIfNeeded];
	
	CGSize suggestedSize = CGSizeZero;

    suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(self.framesetter, CFRangeMake(0, self.htmlString.length), NULL, size, NULL);
	suggestedSize.width = ceil(suggestedSize.width);
	suggestedSize.height = ceil(suggestedSize.height);

	if(self.numberOfLines > 0 && self.htmlString.lineHeight > 0){
		if(suggestedSize.height / self.htmlString.lineHeight > self.numberOfLines){
			suggestedSize.height = self.numberOfLines * self.htmlString.lineHeight;
		}
	}
	return suggestedSize;
}

- (void)drawTextInRect:(CGRect)rect{
	if(!self.text || self.text.length == 0){
		return;
	}
	
	[self createAttributedStringIfNeeded];

    CGFloat contentHeight = [self sizeThatFits:rect.size].height;
    if(contentHeight < rect.size.height){
        switch (self.verticalAlign) {
            case kNMAlignCenter:
                rect.origin.y = (rect.size.height - contentHeight) / 2.0;
                rect.size.height = contentHeight;
                break;
            case kNMAlignBottom:
                rect.origin.y = rect.size.height - contentHeight;
                rect.size.height = contentHeight;
                break;
            default:
                break;
        }
    }
    
    [self.attributedText drawWithRect:rect options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) context:nil];
    
    if([NMCustomLabel attributedStringSupportsImages:self.attributedText]){
        if(self.ctFrame){
            CFRelease(self.ctFrame);
            _ctFrame = nil;
        }
        
        CGMutablePathRef framePath = CGPathCreateMutable();
        CGRect frameRect = rect;
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(context){
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            CGAffineTransform reverseT = CGAffineTransformIdentity;
            reverseT = CGAffineTransformScale(reverseT, 1.0, -1.0);
            reverseT = CGAffineTransformTranslate(reverseT, 0.0, -self.bounds.size.height);
            
            CGPathAddRect(framePath, NULL, CGRectApplyAffineTransform(frameRect, reverseT));
            _ctFrame = CTFramesetterCreateFrame(self.framesetter, CFRangeMake(0, [self.htmlString length]), framePath, NULL);
            
            [self drawImagesForFrame:self.ctFrame fromAttributedString:self.attributedText context:context];
        }else{
            NSLog(@"no context for custom label drawTextInRect");
        }
        
        CFRelease(framePath);
    }

	if(!_pressRecog){
        _pressRecog = [NMCustomLabel newLongPressGestureRecognizer];
        self.pressRecog.delegate = self;
		[self addGestureRecognizer:self.pressRecog];
	}
}
+(UILongPressGestureRecognizer *)newLongPressGestureRecognizer{
    UILongPressGestureRecognizer *pressRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPress:)];
    pressRecog.minimumPressDuration = 0.05;
    pressRecog.delaysTouchesBegan = YES;
    pressRecog.delaysTouchesEnded = YES;
    pressRecog.cancelsTouchesInView = YES;
    return pressRecog;
}

+(BOOL)attributedStringSupportsImages:(NSAttributedString *)string{
	__block BOOL supportsImages = NO;
    [string enumerateAttribute:kNMImageInfoAttributeName inRange:NSMakeRange(0, [string length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
		supportsImages = YES;
		*stop = YES;
	}];
	return supportsImages;
}

//borrowed from https://github.com/adamjernst/AEImageAttributedString/blob/master/AEImageAttributedString/AEImageAttributedString.m
-(void)drawImagesForFrame:(CTFrameRef)frame fromAttributedString:(NSAttributedString *)string context:(CGContextRef)context{
    CGRect rect = CGPathGetBoundingBox(CTFrameGetPath(frame));
	CFArrayRef lines = CTFrameGetLines(frame);
	if(!lines){
		return;
	}
    
	if(context){
		[string enumerateAttribute:kNMImageInfoAttributeName inRange:NSMakeRange(0, [string length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
			NSDictionary *attributes = (NSDictionary *)value;
			UIImage *image = attributes[kNMImageAttributeName];
			CGFloat verticalOffset = [attributes[kNMImageVerticalOffsetAttributeName] floatValue];
			
			if(!image){
				return;
			}
			
			CGRect imageRect = {
				.origin = rect.origin,
				.size = image.size
			};
			
			for (CFIndex i = 0; i < CFArrayGetCount(lines); i++) {
				CTLineRef line = CFArrayGetValueAtIndex(lines, i);
				CFRange r = CTLineGetStringRange(line);
				NSInteger localIndex = range.location - r.location;
				if (localIndex >= 0 && localIndex < r.length) {
					imageRect.origin.x += CTLineGetOffsetForStringIndex(line, range.location, NULL);
					CGPoint lineOrigin;
					CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &lineOrigin);
					imageRect.origin.x += lineOrigin.x;
					imageRect.origin.y += lineOrigin.y - 2.0f;
					break;
				}
			}
			imageRect.origin.y += verticalOffset;
			
			CGContextDrawImage(context, imageRect, image.CGImage);
		}];
	}else{
		NSLog(@"no context for custom label drawImages");
	}
}

-(CGFloat)stringIndexAtLocation:(CGPoint)location{
	CFArrayRef lines = CTFrameGetLines(self.ctFrame);
	CFIndex numLines = CFArrayGetCount(lines);
	CGPoint origins[numLines];//the origins of each line at the baseline
	CFRange range = CFRangeMake(0, numLines);
	CTFrameGetLineOrigins(self.ctFrame, range, origins);
	for (CFIndex i = 0; i < numLines; i++){
		CGPoint origin = origins[i];
		if(location.y >= origin.y && location.y < origin.y + self.htmlString.lineHeight){
			CFIndex lineIndex = numLines-i-1;
			CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, lineIndex); 
			CFIndex stringIndex = CTLineGetStringIndexForPosition(line, CGPointMake(location.x, 0));
			return stringIndex;
		}
	}
	return -1;
}
-(void)performActionOnHighlightedText{
	if([self.delegate respondsToSelector:@selector(customLabel:didSelectText:type:)]){
		[self.delegate customLabel:self didSelectText:self.htmlString.highlightedText type:self.htmlString.highlightedTextType];
	}
}
-(void)resetHighlightedText{
	[self.htmlString resetHighlightedText];
	[self createAttributedString];
	[self setNeedsDisplay];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recog shouldReceiveTouch:(UITouch *)touch{
	CGPoint location = [touch locationInView:self];
	self.htmlString.highlightedTextIndex = [self stringIndexAtLocation:location];
	[self.htmlString resetAttributedString];
	return self.htmlString.highlightedText != nil;
}

-(void)didPress:(UILongPressGestureRecognizer *)recog{
	CGPoint location = [recog locationInView:self];
	
	if(!CGRectContainsPoint(self.bounds, location)){
		_recogOutOfBounds = YES;
	}

	switch (recog.state) {
		case UIGestureRecognizerStateBegan:
			_recogOutOfBounds = NO; //reset.
			if(self.htmlString.highlightedTextIndex == NSNotFound){
				self.htmlString.highlightedTextIndex = [self stringIndexAtLocation:location];
				[self createAttributedString];
			}
			if(self.htmlString.highlightedText){
				if([self.delegate respondsToSelector:@selector(customLabelDidBeginTouch:recog:)]){
					[self.delegate customLabelDidBeginTouch:self recog:recog];
				}
			}else{
				if([self.delegate respondsToSelector:@selector(customLabelDidBeginTouchOutsideOfHighlightedText:recog:)]){
					[self.delegate customLabelDidBeginTouchOutsideOfHighlightedText:self recog:recog];
				}
			}
			[self setNeedsDisplay];
			break;
		
		case UIGestureRecognizerStateChanged:
			if([self.delegate respondsToSelector:@selector(customLabel:didChange:)]){
				[self.delegate customLabel:self didChange:recog];
			}
			if(self.recogOutOfBounds){
				[self resetHighlightedText];
				if([self.delegate respondsToSelector:@selector(customLabelDidEndTouchOutsideOfHighlightedText:recog:)]){
					[self.delegate customLabelDidEndTouchOutsideOfHighlightedText:self recog:recog];
				}
			}
			break;
		
		case UIGestureRecognizerStateEnded:
			if(self.htmlString.highlightedText && !self.recogOutOfBounds){
				[self performActionOnHighlightedText];
			}
			//no break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
			if(self.htmlString.highlightedText && !self.recogOutOfBounds){
				if([self.delegate respondsToSelector:@selector(customLabelDidEndTouch:recog:)]){
					[self.delegate customLabelDidEndTouch:self recog:recog];
				}
			}else{
				if([self.delegate respondsToSelector:@selector(customLabelDidEndTouchOutsideOfHighlightedText:recog:)]){
					[self.delegate customLabelDidEndTouchOutsideOfHighlightedText:self recog:recog];
				}
			}
			[self resetHighlightedText];

			break;
			
		default:
			break;
	}
}

#pragma mark - NMHTMLStringDelegate
-(void)htmlStringDidUpdateAttributedString:(NMHTMLString *)htmlString{
    self.attributedText = self.htmlString.attributedString;

	if(self.framesetter){
		CFRelease(self.framesetter);
	}
    _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)(self.htmlString.attributedString));
}
-(void)htmlStringDidUpdateColor:(NMHTMLString *)htmlString{
	[self redraw];
}

-(void)htmlStringShouldEnableUserInteraction:(NMHTMLString *)htmlString{
	self.userInteractionEnabled = YES;
}


@end





