//
//  XGCameraImageView.m
//  XinGe
//
//  Created by ligang on 15/11/5.
//  Copyright © 2015年 Tomy. All rights reserved.
//

#import "LGCameraImageView.h"
#import <AVFoundation/AVFoundation.h>
static CGFloat BOTTOM_HEIGHT = 60;

@interface LGCameraImageView()
@property (nonatomic) UIButton *useButton;
@property (nonatomic) UIButton *playBtn;
@property (nonatomic) UIImageView *photoDisplayView;
@property (nonatomic) UIWebView *videoPlayView;
@property (nonatomic) AVPlayer *playVideo;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end

@implementation LGCameraImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        [self setupBottomView];
    }
    return self;
}

- (void)setupBottomView {
    CGFloat width = 80;
    CGFloat margin = 20;
    
    // 显示照片的view   在imageToDisplay的set方法中设置frame和image
    UIImageView *photoDisplayView = [[UIImageView alloc] init];
    [self addSubview:photoDisplayView];
    _photoDisplayView = photoDisplayView;
    
    self.videoPlayView = [[UIWebView alloc]initWithFrame:self.bounds];
    [self addSubview:self.videoPlayView];
    self.videoPlayView.hidden = YES;
    
    
    // 底部View
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-BOTTOM_HEIGHT, self.frame.size.width, BOTTOM_HEIGHT)];
    controlView.backgroundColor = [UIColor colorWithRed:20/255.f green:20/255.f blue:20/255.f alpha:0.3];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:controlView];
    
    //‘重拍’按钮
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(margin, 0, width, controlView.frame.size.height);
    [cancalBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cancalBtn];
    
    //‘使用照片’按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.frame.size.width - margin - width, 0, width, controlView.frame.size.height);
    [doneBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:doneBtn];
    self.useButton = doneBtn;
    CGFloat pwid = 40;
    self.playBtn.frame = CGRectMake((controlView.frame.size.width-pwid)/2, (controlView.frame.size.height-pwid)/2, pwid, pwid);
    [controlView addSubview:self.playBtn];
    self.playBtn.hidden = YES;
    
}

//setter
- (void)setImageToDisplay:(UIImage *)imageToDisplay {
    _imageToDisplay = imageToDisplay;
    _photoDisplayView.hidden = NO;
    self.videoPlayView.hidden = !_photoDisplayView.hidden;
    self.playBtn.hidden =  YES;
    [self.useButton setTitle:@"使用照片" forState:UIControlStateNormal];
    if (imageToDisplay == nil) {
        return;
    }
    
    CGSize size;
    size.width = [UIScreen mainScreen].bounds.size.width;
    size.height = ([UIScreen mainScreen].bounds.size.width / imageToDisplay.size.width) * imageToDisplay.size.height;
    NSLog(@"%@",NSStringFromCGSize(size));
    CGFloat x = (self.frame.size.width - size.width) / 2;
    CGFloat y = (self.frame.size.height - size.height) / 2;
    _photoDisplayView.frame = CGRectMake(x, y, size.width, size.height);
    [_photoDisplayView setImage:imageToDisplay];
}

- (void)setMovieURL:(NSURL *)movieURL {
    _movieURL = movieURL;
    _photoDisplayView.hidden = YES;
    self.videoPlayView.hidden = YES;//!_photoDisplayView.hidden;
    self.playBtn.hidden =  NO;
    [self.useButton setTitle:@"使用视频" forState:UIControlStateNormal];
    [self nextPlay];
}

- (void)nextPlay {
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
    }
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.movieURL];
        self.playVideo = [AVPlayer playerWithPlayerItem:playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.playVideo];
        CGFloat navTop = ([self isX]) ? 88:64;
        self.playerLayer.frame = CGRectMake(0, navTop, self.frame.size.width, self.frame.size.height - navTop);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.playVideo play];
        });
        [self.layer insertSublayer:self.playerLayer atIndex:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playVideo.currentItem];

    
}
- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(didPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.selected = YES;
    }
    return _playBtn;
}
- (void)didPlayBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.playVideo play];
    }else {
        [self.playVideo pause];
    }
}


- (void)pausePlayerAndShowNaviBar {
    [self.playVideo pause];
    self.playBtn.selected = NO;
    [self.playVideo.currentItem seekToTime:CMTimeMake(0, 1)];
}


- (BOOL)isX {
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
}

- (void)cancel1 {
    if ([_delegate respondsToSelector:@selector(xgCameraImageViewCancleBtnTouched)]) {
        [_delegate xgCameraImageViewCancleBtnTouched];
    }
    [self removeFromSuperview];
}

- (void)doneAction {
    if ([_delegate respondsToSelector:@selector(xgCameraImageViewSendBtnTouched)]) {
        [_delegate xgCameraImageViewSendBtnTouched];
    }
}

@end
