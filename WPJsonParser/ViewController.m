//
//  ViewController.m
//  WPJsonParser
//
//  Created by Vavelin Kévin on 07/01/13.
//  Copyright (c) 2013 Vavelin Kévin. All rights reserved.
//

#import "ViewController.h"
#import "WPJsonParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.logLabel.frame.size.height);
    WPJsonParser *json = [[WPJsonParser alloc] initWithCommand:@"get_recent_posts" ofURL:@"www.spi0n.com"];
    NSString *content = [json getDescription];
    self.logLabel.text = content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_logLabel release];
    [_scrollView release];
    [super dealloc];
}
@end
