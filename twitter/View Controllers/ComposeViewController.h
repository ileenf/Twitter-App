//
//  ComposeViewController.h
//  twitter
//
//  Created by Ileen Fan on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *tweetType;
@property (nonatomic, strong) NSString *replyID;
@property (nonatomic, strong) NSString *replyUsername;




@end

NS_ASSUME_NONNULL_END
