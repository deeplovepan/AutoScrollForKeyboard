//
//  ViewController.m
//  AutoScrollForKeyboard
//
//  Created by Pan Peter on 13/10/1.
//  Copyright (c) 2013年 Pan Peter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
{
    UITextField *activeField;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
  

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.backgroundColor = [UIColor orangeColor];
    
    UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, 100, 30)];
    [self.scrollView addSubview:textField1];
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    textField1.delegate = self;
    
    UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 350, 100, 30)];
    [self.scrollView addSubview:textField2];
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    textField2.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, self.scrollView.contentInset.top, 0, 0 );
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
    
}


- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    
    CGRect aRect = self.scrollView.frame;
    aRect.size.height = self.scrollView.frame.size.height - kbSize.height;
    
    
    
    int dif =  self.scrollView.contentInset.top  + activeField.frame.origin.y + activeField.frame.size.height - aRect.size.height;
        
    if(dif > 0 ) {
        CGPoint scrollPoint = CGPointMake(0.0, -self.scrollView.contentInset.top +  dif + 5);
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    }
    
    [UIView commitAnimations];
    
    
    
}

#pragma mark - UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    activeField = textField;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}



@end
