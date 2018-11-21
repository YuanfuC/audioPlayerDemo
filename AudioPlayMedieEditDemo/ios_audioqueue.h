//
//  ios_audioqueue.h
//  AudioPlayMedieEditDemo
//
//  Created by ChenYuanfu on 2018/11/21.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ios_audioqueue : NSObject

- (void)play ;

- (void)startPlay;

- (void)pause;

- (void)resume;

- (void)stop;

@property (nonatomic, assign) float playtime;

@end
