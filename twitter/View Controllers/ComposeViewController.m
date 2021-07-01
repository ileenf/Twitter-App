//
//  ComposeViewController.m
//  twitter
//
//  Created by Ileen Fan on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UILabel *countRemaining;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetView.delegate  = self;
    // Do any additional setup after loading the view.
    
    self.tweetView.layer.borderWidth = 1;
    self.tweetView.layer.borderColor = CGColorCreateGenericRGB(47/255.0, 124/255.0, 246/255.0, 1);
    self.tweetView.delegate = self;
}

- (IBAction)cancelTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sendTweet:(id)sender {
    
    if (self.tweetView.text.length == 0) {
        [UIView animateWithDuration: 2 animations:^{
            self.tweetView.layer.borderColor = CGColorCreateGenericRGB(1, 0, 20/255.0, 1);
        }];
    } else {
        
        if ([self.tweetType isEqualToString: @"newTweet"]){
            [[APIManager shared] postStatusWithText:self.tweetView.text completion:^(Tweet *tweet, NSError *error) {
                if(tweet){
                    //success
                    //Delegate
                    [self.delegate didTweet:tweet];
                    [self dismissViewControllerAnimated:true completion:nil];
                    
                }else{
                    //error
                    //Show an alert
                    NSLog(@"Failed to post tweet");
                }
            }];
            
        } else if ([self.tweetType isEqualToString: @"reply"]){
            
            [[APIManager shared] postReplyWithText:self.tweetView.text replyToUsername:self.replyUsername replyID:self.replyID completion:^(Tweet *tweet, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    NSLog(@"IT WORKS");
                    [self.delegate didTweet:tweet];
                    [self dismissViewControllerAnimated:true completion:nil];
                }
            }];
            
        }
        
    }
    
    
    
    
    
    
    

    
}







- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit + 1;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.countRemaining.text = [NSString stringWithFormat:@"%ld", 140 - self.tweetView.text.length ];
    self.tweetView.layer.borderColor = CGColorCreateGenericRGB(47/255.0, 124/255.0, 246/255.0, 1);
    if (self.tweetView.text.length >= 140) {
        self.tweetView.layer.borderColor = CGColorCreateGenericRGB(247/255.0, 24/255.0, 46/255.0, 1);
    }

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
