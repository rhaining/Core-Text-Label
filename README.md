## Core Text Label 
An iOS class that lets you get started rendering basic Core Text in your apps. It's essentially a subclass of UILabel that allows you to set kerning, line height, & multiple fonts.

## A few words
Make sure to add the Core Text framework before adding the class to your project.
I built the sample project using iOS 5.1, but there's no reason it shouldn't work going back to iOS 3.2 I think [but I've only tested the class back to 4.3].

## As easy as pie
```
	NMCustomLabel *label = [[NMCustomLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	label.text = @"Tacos are <b>delicious</b>, <i>seriously</i>";
	label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	label.fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
	label.fontItalic = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:12];
	label.kern = -0.5;
	label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
	label.textColorBold = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
	label.lineHeight = 12;
	[self.view addSubview:label];
```

## License
Licensed under [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## About News.me
[News.me](http://News.me/) is a small team based out of [betaworks](http://betaworks.com/) in New York City. We build applications that improve the way people find and talk about the news.

We have an [iPhone app](http://news.me/iphone-download?source=about), an [iPad app](http://news.me/ipad-download?source=about), and a [daily email](http://www.news.me/#email-signup) that deliver the best stories shared by your friends on Twitter and Facebook.

## About this project
This class was introduced as a part Rob's talk at the [Brooklyn iOS Dev Meetup](http://www.meetup.com/The-Brooklyn-iPhone-and-iPad-Developer-Meetup/). See slides & more at [bit.ly/bkiosmeetup](http://bit.ly/bkiosmeetup).

If you're using this class, I'd love to [hear about it](https://github.com/rhaining)!