//
//  TweetCell.m
//  twitter
//
//  Created by Ileen Fan on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    

    
    
}

// Did Tap Favorite
- (IBAction)didTapFavorite:(id)sender {
    // TODO: Update the local tweet model
    if (self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.likeCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];
            
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.likeCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];

        
    }
    
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    // TODO: Update cell UI
 


    [self.favoriteIcon setSelected: self.tweet.favorited];

    
    // TODO: Send a POST request to the POST favorites/create endpoint
    
}

//Retweet
- (IBAction)didTapRetweet:(id)sender {
    
    if (self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:258.0/255.0 blue:79.0/255.0 alpha:1];
            
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweetd the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];

        
    }
    
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // TODO: Update cell UI
 


    [self.retweetIcon setSelected: self.tweet.retweeted];

}



@end
