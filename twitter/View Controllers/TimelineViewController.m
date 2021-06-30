//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImage+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)loadTweets {
                
                [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
                    if (tweets) {
                        NSLog(@"😎😎😎 Successfully loaded home timeline");
                        self.arrayOfTweets = tweets;
                        [self.tableView reloadData];
                        
                        //NSLog(@"%@", self.arrayOfTweets);
                //            for (NSDictionary *dictionary in tweets) {
                //                NSString *text = dictionary[@"text"];
                //                NSLog(@"%@", text);
                //            }
                    } else {
                        NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                    }
                    [self.refreshControl endRefreshing];
                    
                }];
        
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweetObj = self.arrayOfTweets[indexPath.row];
    User *user = tweetObj.user;
    
    cell.tweetAuthor.text = user.name;
    cell.screenName.text = [NSString stringWithFormat:@"@%@", user.screenName];
    cell.tweetDate.text = tweetObj.createdAtString;
    cell.tweetText.text = tweetObj.text;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweetObj.retweetCount];
    cell.likeCount.text = [NSString stringWithFormat:@"%d", tweetObj.favoriteCount];
    cell.tweet = tweetObj;
    
    NSString *URLString = tweetObj.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.profilePic.image = [UIImage imageWithData:urlData];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell.tweet.favorited) {
        cell.likeCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];
    
    }
    else {
        cell.likeCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    }
    
    [cell.favoriteIcon setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [cell.favoriteIcon setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    cell.favoriteIcon.selected = cell.tweet.favorited;
    
    if (cell.tweet.retweeted) {
        cell.retweetCount.textColor = [[UIColor alloc] initWithRed:58.0/255.0 green:258.0/255.0 blue:79.0/255.0 alpha:1];
    
    }
    else {
        cell.retweetCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    }
    
    [cell.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [cell.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    cell.retweetIcon.selected = cell.tweet.retweeted;
    
    return cell;
    
}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        
        
    } else {
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    }
   
}



@end
