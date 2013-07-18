//
//  SPLogViewController.m
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPLogViewController.h"

@interface SPLogViewController ()

@end

@implementation SPLogViewController

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == [SPLogger defaultLogger]
        && [keyPath isEqualToString:@"bufferedMessagesString"]) {
        
        [self performSelectorOnMainThread:@selector(updateLogView)
                               withObject:nil waitUntilDone:NO];
    }
}

- (void)updateLogView
{
    self.logMessagesTextView.text =
    [SPLogger defaultLogger].bufferedMessagesString;
    [self scrollLogViewToEnd];
}

- (void)scrollLogViewToEnd
{
    NSUInteger currentLogLength = [SPLogger defaultLogger].bufferedMessagesString.length;
    if (currentLogLength) {
        NSRange newMessageRange = NSMakeRange(currentLogLength - 1, 1);
        [self.logMessagesTextView scrollRangeToVisible:newMessageRange];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.logMessagesTextView.backgroundColor =
    [UIColor colorWithPatternImage: [UIImage imageNamed:@"lined_paper.png"]];

    
    [self updateLogView];
    
    [[SPLogger defaultLogger] addObserver:self
                               forKeyPath:@"bufferedMessagesString"
                                  options:NSKeyValueObservingOptionOld
                                  context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_logMessagesTextView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [[SPLogger defaultLogger] removeObserver:self
                                  forKeyPath:@"bufferedMessagesString"];
    [self setLogMessagesTextView:nil];
    [super viewDidUnload];
}

@end
