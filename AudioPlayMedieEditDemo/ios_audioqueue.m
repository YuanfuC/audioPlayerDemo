//
//  ios_audioqueue.m
//  AudioPlayMedieEditDemo
//
//  Created by ChenYuanfu on 2018/11/21.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import "ios_audioqueue.h"
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_COUNT 3
#define EVERY_READ_LENGHT 1000
#define MIN_SIZE_PER_FRAME 2000
void AudioPlayerAQInputCallback(void *input, AudioQueueRef outQ, AudioQueueBufferRef outQB);

@implementation ios_audioqueue {
    NSInputStream *inputStream;
    Byte *pcmDataBuffer;
    
    AudioStreamBasicDescription audioDcrpt;
    AudioQueueRef audioQueue;
    AudioQueueBufferRef buffers[QUEUE_BUFFER_COUNT];
    NSLock *syncLock;
}

- (void)play {
    [self initFile];
    [self initAudio];
    
    OSStatus status = AudioQueueStart(audioQueue, NULL);
    NSLog(@"Play status:%d",(int) status);
    for (int bufferIndex = 0; bufferIndex < QUEUE_BUFFER_COUNT; bufferIndex++) {
        [self enqueuePCMData:audioQueue buffer:buffers[bufferIndex]];
    }

}

- (void)pause {
    OSStatus status = AudioQueuePause(audioQueue);
    NSLog(@"pause status:%d",(int) status);
}

- (void)resume {
    OSStatus status = AudioQueueStart(audioQueue, NULL);
    NSLog(@"resume status:%d",(int) status);
}

- (void)stop {
    
    OSStatus status = AudioQueueStop(audioQueue, NO);
    NSLog(@"stop status:%d",(int) status);
    
    OSStatus status2 = AudioQueueFlush(audioQueue);
    NSLog(@"flush status:%d",(int) status2);
}

- (void)initFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words_bqb" ofType:@"pcm"];
    NSAssert(path, @"path not exist.");
    inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    pcmDataBuffer = malloc(EVERY_READ_LENGHT);
    [inputStream open];
    syncLock = [NSLock new];
}

- (void)initAudio {
    audioDcrpt.mSampleRate = 44100;
    audioDcrpt.mFormatID = kAudioFormatLinearPCM;
    audioDcrpt.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioDcrpt.mChannelsPerFrame = 1;
    audioDcrpt.mFramesPerPacket = 1;
    audioDcrpt.mBitsPerChannel = 16;
    audioDcrpt.mBytesPerFrame = (audioDcrpt.mBitsPerChannel/8) * audioDcrpt.mChannelsPerFrame;
    audioDcrpt.mBytesPerPacket = audioDcrpt.mBytesPerFrame ;
    OSStatus s1 = AudioQueueNewOutput(&audioDcrpt,
                        AudioPlayerAQInputCallback,
                        (__bridge void * )self,
                        nil,
                        nil,
                        0,
                        &audioQueue);
    NSLog(@"Output new status:%d", (int)s1);
    
    for (int index = 0; index < QUEUE_BUFFER_COUNT; index++) {
        OSStatus result = AudioQueueAllocateBuffer(audioQueue,  MIN_SIZE_PER_FRAME, &buffers[index]);
        NSLog(@"Buffer new status:%d index:%d", (int)result, index);
    }
}


- (void)enqueuePCMData:(AudioQueueRef)outQueue buffer:(AudioQueueBufferRef)outBuffer{
    [syncLock lock];
    size_t readLength = [inputStream read:pcmDataBuffer maxLength:EVERY_READ_LENGHT];
   // NSLog(@"Read raw data size :%zi", readLength);
    if (readLength == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"😄 Finish");
        });
        return;
    }
    outBuffer->mAudioDataByteSize = (uint32_t)readLength;
    memcpy((Byte *)outBuffer->mAudioData, pcmDataBuffer, readLength);
    AudioQueueEnqueueBuffer(outQueue, outBuffer, 0, NULL);
    
    AudioTimeStamp timpSt;
    AudioQueueGetCurrentTime(outQueue, NULL, &timpSt, NULL);
    self.playtime = timpSt.mSampleTime / 44100;
   // NSLog(@"%f", timpSt.mSampleTime/44100);
    
    [syncLock unlock];
}

@end

void AudioPlayerAQInputCallback(void *input, AudioQueueRef outQ, AudioQueueBufferRef outQB) {
    //NSLog(@"%s", __func__);
    ios_audioqueue *queue = (__bridge ios_audioqueue *)input;
    [queue enqueuePCMData:outQ buffer:outQB];
}
