## Core Text Label 
An iOS class that lets you get started rendering basic Core Text in your apps. It's essentially a subclass of UILabel that allows you to set kerning, line height, & multiple fonts.

## A few words
Make sure to add the Core Text framework before adding the class to your project.
I built the sample project using iOS 5.1, but there's no reason it shouldn't work going back to iOS 3.2 I think [but I've only tested the class back to 4.3].

## As easy as pie
```objective-c
	NMCustomLabel *label = [[NMCustomLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	label.text = @"Tacos are <span class='bold_style'>delicious</span>, <span class='ital_style'>seriously</span>";
	[label setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]]];
	[label setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] color:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]] forKey:@"bold_style"];
	[label setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:12] color:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]] forKey:@"ital_style"];	
	label.kern = -0.5;
	label.lineHeight = 12;
	[self.view addSubview:label];
```

## About Digg
[Digg](http://digg.com/) is a small team based out of [betaworks](http://betaworks.com/) in New York City. Digg delivers the most interesting and talked about stories on the Internet right now.

We have an [iOS app](http://digg.com/ios-download) & a [web app](http://digg.com/).

## About this project
This class was introduced as a part Rob's talk at the [Brooklyn iOS Dev Meetup](http://www.meetup.com/The-Brooklyn-iPhone-and-iPad-Developer-Meetup/). See slides & more at [bit.ly/bkiosmeetup](http://bit.ly/bkiosmeetup).

If you're using this class, I'd love to [hear about it](https://github.com/rhaining)!

## License Info
Copyright 2012 News.me

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
