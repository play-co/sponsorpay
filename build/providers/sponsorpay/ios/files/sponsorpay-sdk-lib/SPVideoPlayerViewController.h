//
//  SPVideoPlayer.h
//  SPVideoPlayer
//
//  Created by Daniel Barden on 25/12/13.
//  Copyright (c) 2013 SponsorPay GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPVideoPlaybackStateDelegate;

@interface SPVideoPlayerViewController : UIViewController

@property (nonatomic, assign) BOOL showAlert;
@property (copy, nonatomic) NSString *alertMessage;
@property (nonatomic, strong) NSURL *clickThroughURL;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, weak) id<SPVideoPlaybackStateDelegate> delegate;

- (id)initWithVideo:(NSURL *)url
          showAlert:(BOOL)showAlert
       alertMessage:(NSString *)alertMessage
    clickThroughUrl:(NSURL *)clickThroughURL;

@end
