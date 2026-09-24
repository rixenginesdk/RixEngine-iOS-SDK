//
//  ViewController.m
//  RixEngineSPMDemo
//
//  Created by YXk on 2026/8/27.
//

#import "ViewController.h"
#import <AlxAds/AlxAds-Swift.h>

@interface ViewController ()

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RixEngine SPM ObjC Demo";
    
    // UI Label
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 100)];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor systemBlueColor];
    self.statusLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.statusLabel.text = @"Initializing RixEngine SDK via SPM...";
    [self.view addSubview:self.statusLabel];
    
    // 初始化 SDK (通过 SPM 引入的 AlxAds 模块)
    [AlxSdk initializeSDKWithToken:@"test_token" sid:@"test_sid" appId:@"test_app_id"];
    
    self.statusLabel.text = [NSString stringWithFormat:@"✅ RixEngine SDK Initialized Successfully\n(Objective-C SPM Integration)\nSDK Version: %@", [AlxSdk getSDKVersion]];
}

@end
