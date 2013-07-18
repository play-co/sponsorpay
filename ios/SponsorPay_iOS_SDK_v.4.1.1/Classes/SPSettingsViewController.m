//
//  SPSettingsViewController.m
//  SponsorPaySample
//
//  Created by David on 9/14/12.
//  Copyright (c) 2012 SponsorPay. All rights reserved.
//

#import "SPSettingsViewController.h"

@interface SPSettingsViewController ()

@end

@implementation SPSettingsViewController

@synthesize additionalParameters;

@synthesize keyTextField;
@synthesize valueTextField;

@synthesize paramsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)doneButtonTapped:(id)sender
{
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)addButtonTapped:(id)sender
{
    if(keyTextField.text && ![keyTextField.text isEqualToString:@""]) {
        [additionalParameters addValue:valueTextField.text forKey:keyTextField.text];
        [self.paramsTableView reloadData];
        self.keyTextField.text = @"";
        self.valueTextField.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [additionalParameters.keysArray count];
}

#define CELL_IDENTIFIER @"CustomParamsCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    // Configure the cell...
    if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER] autorelease];
    
    cell.textLabel.text = [additionalParameters objectDescriptionForIndex:indexPath.row];
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [additionalParameters removeObjectForIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     /*
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }*/
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.keyTextField.text = [additionalParameters keyAtIndex:indexPath.row];
    self.valueTextField.text = [additionalParameters objectAtIndex:indexPath.row];
}



#pragma mark - Housekeeping

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
