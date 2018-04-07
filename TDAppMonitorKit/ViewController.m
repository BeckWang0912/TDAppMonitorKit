//
//  ViewController.m
//  TDAppMonitorKit
//
//  Created by Beck.Wang on 2018/4/7.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import "ViewController.h"
#import "TDFPSMonitor.h"
#import "TDResourceMonitor.h"
#import "TDAppFluencyMonitor.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [TD_FLUENCYMONITOR startMonitoring];
    [TD_FPSMONITOR startMonitoring];
    [TD_RESOURCEMONITOR startMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    cell.textLabel.text = [NSString stringWithFormat: @"%lu", (long)indexPath.row];
    if (indexPath.row > 0 && indexPath.row % 30 == 0) {
        usleep(2000000);
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    for (int idx = 0; idx < 100; idx++) {
        usleep(10000);
    }
}

#pragma mark - UITableView
- (UITableView*)tableView{
    if (!_tableView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -= 64;
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"cell"];
    }
    return _tableView;
}

@end

