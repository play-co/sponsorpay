//
//  SPSettingsViewController.h
//  SponsorPaySample
//
//  Created by David on 9/14/12.
//  Copyright (c) 2012 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCustomParamsUtil.h"

@interface SPSettingsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {

    SPCustomParamsUtil *additionalParameters;
    
    UITextField *keyTextField;
    UITextField *valueTextField;
    
    UITableView *paramsTableView;

}

@property (assign) SPCustomParamsUtil *additionalParameters;

@property (retain) IBOutlet UITextField *keyTextField;
@property (retain) IBOutlet UITextField *valueTextField;
@property (retain) IBOutlet UITableView *paramsTableView;

-(IBAction)doneButtonTapped:(id)sender;
-(IBAction)addButtonTapped:(id)sender;
-(IBAction)textFieldReturn:(id)sender;

@end
