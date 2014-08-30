## Core Text Label 
An iOS library that lets you get started rendering basic Core Text in your apps. It's essentially a subclass of UILabel that allows you to set kerning, line height, & multiple fonts.

## A few words
Make sure to add the Core Text framework before adding the class to your project.
Currently supporting iOS 6.0+.

## As easy as pie
```objective-c
	NMCustomLabel *label = [[NMCustomLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	label.htmlString.text = [NSString stringWithFormat:@"Tacos are <span class='%@'>delicious</span>, <span class='ital_style'>seriously</span>", NMCustomLabelStyleBoldKey];
	[label.htmlString setDefaultStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12] color:[UIColor colorWithWhite:153/255.0 alpha:1.0]]];
	[label.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] color:[UIColor colorWithWhite:53/255.0 alpha:1.0]] forKey:@"bold_style"];
	[label.htmlString setStyle:[NMCustomLabelStyle styleWithFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:12] color:[UIColor colorWithWhite:153/255.0 alpha:1.0]] forKey:@"ital_style"];
	label.htmlString.kern = -0.5;
	label.htmlString.lineHeight = 12;
	[self.view addSubview:label];
```

## About Digg
This library was originally written by @rhaining at [Digg](http://digg.com/), a small team based out of [betaworks](http://betaworks.com/) in New York City. Digg delivers the most interesting and talked about stories on the Internet right now.

## About this project
This library was introduced as a part Rob's talk at the [Brooklyn iOS Dev Meetup](http://www.meetup.com/The-Brooklyn-iPhone-and-iPad-Developer-Meetup/). See slides & more at [bit.ly/bkiosmeetup](http://bit.ly/bkiosmeetup).

If you're using this class, I'd love to [hear about it](https://github.com/rhaining)!

## License Info
See enclosed [LICENSE.md](LICENSE.md).