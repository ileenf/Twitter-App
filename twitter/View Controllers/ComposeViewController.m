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

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetView.delegate  = self;
    // Do any additional setup after loading the view.
}

- (IBAction)cancelTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sendTweet:(id)sender {
    
    
    
    
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
