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
    

    
    
}

// Did Tap Favorite
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.likeCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];
            
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
           
        }];
    }
    
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.likeCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
           
        }];

        
    }
    
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    

    [self.favoriteIcon setSelected: self.tweet.favorited];

        
}

//Retweet
- (IBAction)didTapRetweet:(id)sender {
    
    if (self.tweet.retweeted == NO){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:11.0/255.0 green:228.0/255.0 blue:79.0/255.0 alpha:1];
            
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            
        }];
    }
    
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
           
        }];

        
    }
    
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // TODO: Update cell UI
 


    [self.retweetIcon setSelected: self.tweet.retweeted];

}


- (void)setMovie:(Tweet *)tweetObj{
    
    User *user = tweetObj.user;

    self.tweetAuthor.text = user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetDate.text = tweetObj.createdAtString;
    self.tweetText.text = tweetObj.text;
    self.retweetCount.text = [NSString stringWithFormat:@"%d", tweetObj.retweetCount];
    self.likeCount.text = [NSString stringWithFormat:@"%d", tweetObj.favoriteCount];
    self.tweet = tweetObj;

    NSString *URLString = tweetObj.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    self.profilePic.image = [UIImage imageWithData:urlData];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.tweet.favorited) {
        self.likeCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];

    }
    else {
        self.likeCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    }

    [self.favoriteIcon setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [self.favoriteIcon setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    self.favoriteIcon.selected = self.tweet.favorited;

    if (self.tweet.retweeted) {
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:58.0/255.0 green:258.0/255.0 blue:79.0/255.0 alpha:1];

    }
    else {
        self.retweetCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    }

    [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    self.retweetIcon.selected = self.tweet.retweeted;
    
    
    
    
    
}


@end
