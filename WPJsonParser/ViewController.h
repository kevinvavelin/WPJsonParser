//
//  ViewController.h
//  WPJsonParser
//
//  Created by Vavelin Kévin on 07/01/13.
//  Copyright (c) 2013 Vavelin Kévin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSArray *post;
    NSDictionary *contentOfPost;
}
@property (retain, nonatomic) IBOutlet UILabel *logLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
