//
//  ViewController.m
//  AudioPlayMedieEditDemo
//
//  Created by ChenYuanfu on 2018/11/21.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import "ViewController.h"
#import "ios_audioqueue.h"

@interface ViewController ()
@property (nonatomic, strong)ios_audioqueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ios_audioqueue *queue = [ios_audioqueue new];
    self.queue = queue;
    [self setupUI];

}

- (void)setupUI {
    UIButton *startB = [[UIButton alloc] init];
    [startB setTitle:@"start" forState:UIControlStateNormal];
    [startB setFrame:CGRectMake(44, 44, 80, 44)];
    [startB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startB addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pause = [[UIButton alloc] init];
    [pause setTitle:@"pause" forState:UIControlStateNormal];
    [pause setFrame:CGRectMake(44, 108, 80, 44)];
    [pause addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [pause setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
    UIButton *resume = [[UIButton alloc] init];
    [resume setTitle:@"resume" forState:UIControlStateNormal];
    [resume setFrame:CGRectMake(44, 172, 80, 44)];
    [resume addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
    [resume setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
    UIButton *stop = [[UIButton alloc] init];
    [stop setTitle:@"stop" forState:UIControlStateNormal];
    [stop setFrame:CGRectMake(44, 236, 80, 44)];
    [stop addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [stop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
    [self.view addSubview:startB];
    [self.view addSubview:pause];
    [self.view addSubview:resume];
    [self.view addSubview:stop];
}

- (void)startPlay:(id)sender {
    [self.queue play];
}

- (void)pause:(id)sender {
    [self.queue pause];
}

- (void)resume:(id)sender {
    [self.queue resume];
}

- (void)stop:(id)sender {
    [self.queue stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
