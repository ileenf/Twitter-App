//
//  DetailsViewController.m
//  twitter
//
//  Created by Ileen Fan on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showDetails];
}

-(void)showDetails {
    self.accountName.text = self.tweet.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    self.tweetDate.text = self.tweet.createdAtDate;
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.numFavorites.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profilePic.image = [UIImage imageWithData:urlData];
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    self.favoriteButton.selected = self.tweet.favorited;

    
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    self.retweetButton.selected = self.tweet.retweeted;
}
- (IBAction)tapRetweet:(id)sender {
    
    if (self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
            
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            
        }];
    }
    
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            
        }];

        
    }
    
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    [self.retweetButton setSelected: self.tweet.retweeted];
    
}

- (IBAction)tapFavorite:(id)sender {
    
    if (self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
            
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            
        }];
    }
    
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //self.numFavorites.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
           
        }];

        
    }
    
    self.numFavorites.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];


    [self.favoriteButton setSelected: self.tweet.favorited];
    

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
