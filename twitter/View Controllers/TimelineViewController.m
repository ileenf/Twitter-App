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

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

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
    
    [cell setMovie:tweetObj];
    

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


    } else if ([segue.identifier isEqualToString: @"ReplySegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController *) navigationController.topViewController;
        composeController.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell: [[sender superview] superview]];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        composeController.replyID = tweet.idStr;
        composeController.replyUsername = tweet.user.screenName;
        composeController.tweetType = @"reply";
        
    }
    else if ([[segue identifier] isEqualToString:@"ComposeTweet"]){

        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.tweetType = @"newTweet";
        
    }
   
}


@end
