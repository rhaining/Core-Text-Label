//
//  NMTextHelper.m
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

#import "NMTextHelper.h"

@implementation NMTextHelper

+(NSRegularExpression *)regExWithPattern:(NSString *)pattern{
    NSRegularExpressionOptions regExOptions = NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regExOptions error:&error];
    if(!regex){
        NSLog(@"error creating regex of pattern %@: %@", pattern, error);
    }
    return regex;
}

+(NSRegularExpression *)usernameRegEx{
    static NSRegularExpression *usernameRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usernameRegEx = [self regExWithPattern:@"(@.+?)(?:[^0-9A-Za-z_\\.]|$)"];
    });
	return usernameRegEx;
}
+(NSRegularExpression *)usernameEndRegEx{
    static NSRegularExpression *usernameEndRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usernameEndRegEx = [self regExWithPattern:@"[^0-9A-Za-z_\\.]"];
    });
	return usernameEndRegEx;
}
+(NSRegularExpression *)hashtagRegEx{
    static NSRegularExpression *hashtagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hashtagRegEx = [self regExWithPattern:@"[^0-9A-Za-z]"];
    });
	return hashtagRegEx;
}
+(NSRegularExpression *)tagRegEx{
    static NSRegularExpression *tagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tagRegEx = [self regExWithPattern:@"<.+?>"];
    });
	return tagRegEx;
}
+(NSRegularExpression *)spanTagRegEx{
    static NSRegularExpression *spanTagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spanTagRegEx = [self regExWithPattern:@"<span (.+?)>.+?</span>"];
    });
	return spanTagRegEx;
}
+(NSRegularExpression *)markTagRegEx{
    static NSRegularExpression *markTagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        markTagRegEx = [self regExWithPattern:@"<mark>.+?</mark>"];
    });
	return markTagRegEx;
}
+(NSRegularExpression *)shortTagRegEx{
    static NSRegularExpression *shortTagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shortTagRegEx = [self regExWithPattern:@"</?[b-z][a-z]?>"];
    });
	return shortTagRegEx;
}
+(NSRegularExpression *)anchorTagRegEx{
    static NSRegularExpression *anchorTagRegEx;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anchorTagRegEx = [self regExWithPattern:@"<a (.+?)>.+?</a>"];
    });
	return anchorTagRegEx;
}
+(NSCharacterSet *)emojiCharacterSet{
    static NSCharacterSet *emojiCharacterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"😄😊😃☺😉😍😘😚😳😌😁😜😝😒😏😓😔😞😖😥😰😨😣😢😭😂😲😱😠😡😪😷👿👽💛💙💜💗💚❤💔💓💘✨🌟💢❕❔💤💨💦🎶🎵🔥💩👍👎👌👊✊✌👋✋👐👆👇👉👈🙌🙏☝👏💪🚶🏃👫💃👯🙆🙅💁🙇💏💑💆💇💅👦👧👩👨👶👵👴👱👲👳👷👮👼👸💂💀👣💋👄👂👀👃☀☔☁⛄🌙⚡🌀🌊🐱🐶🐭🐹🐰🐺🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐎🐫🐑🐘🐍🐦🐤🐔🐧🐛🐙🐠🐟🐳🐬💐🌸🌷🍀🌹🌻🌺🍁🍃🍂🌴🌵🌾🐚🎍💝🎎🎒🎓🎏🎆🎇🎐🎑🎃👻🎅🎄🎁🔔🎉🎈💿📀📷🎥💻📺📱📠☎💽📼🔊📢📣📻📡➿🔍🔓🔒🔑✂🔨💡📲📩📫📮🛀🚽💺💰🔱🚬💣🔫💊💉🏈🏀⚽⚾🎾⛳🎱🏊🏄🎿♠♥♣♦🏆👾🎯🀄🎬📝📖🎨🎤🎧🎺🎷🎸〽👟👡👠👢👕👔👗👘👙🎀🎩👑👒🌂💼👜💄💍💎☕🍵🍺🍻🍸🍶🍴🍔🍟🍝🍛🍱🍣🍙🍘🍚🍜🍲🍞🍳🍢🍡🍦🍧🎂🍰🍎🍊🍉🍓🍆🍅🏠🏫🏢🏣🏥🏦🏪🏩🏨💒⛪🏬🌇🌆🏧🏯🏰⛺🏭🗼🗻🌄🌅🌃🗽🌈🎡⛲🎢🚢🚤⛵✈🚀🚲🚙🚗🚕🚌🚓🚒🚑🚚🚃🚉🚄🚅🎫⛽🚥⚠🚧🔰🎰🚏💈♨🏁🎌🇯🇵🇰🇷🇨🇳🇺🇸🇫🇷🇪🇸🇮🇹🇷🇺🇬🇧🇩🇪1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣#⃣⬆⬇⬅➡↗↖↘↙◀▶⏪⏩🆗🆕🔝🆙🆒🎦🈁📶🈵🈳🉐🈹🈯🈺🈶🈚🈷🈸🈂🚻🚹🚺🚼🚭🅿♿🚇🚾㊙㊗🔞🆔✳✴💟🆚📳📴💹💱♈♉♊♋♌♍♎♏♐♑♒♓⛎🔯🅰🅱🆎🅾🔲🔴🔳🕛🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚⭕❌©®™"];
    });
	return emojiCharacterSet;
}

+(NSCharacterSet *)alphaNumericCharacterSet{
    static NSCharacterSet *alphaNumericCharacterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alphaNumericCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    });
	return alphaNumericCharacterSet;
}

#pragma mark - base RTL  (arabic+persian+etc)
+(BOOL)textIsBaseRTL:(NSString *)text {
	text = nil;
	if(text && text.length > 0){
		NSString *isoLangCode = (__bridge_transfer NSString*)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)text, CFRangeMake(0, text.length));
		NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:isoLangCode];
		return (direction == NSLocaleLanguageDirectionRightToLeft);
	}else{
		return NO;
	}
}

@end
