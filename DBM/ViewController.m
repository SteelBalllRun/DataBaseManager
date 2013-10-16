//
//  ViewController.m
//  DBM
//
//  Created by Baitian on 13-5-22.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "ViewController.h"
#import "TestResObj.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[AopCache getInstance] startCache];
    [[AopCache getInstance] setWithCapacity:2];
    m_record=[[Record alloc]initWithKeyString:@"test"];
    
    
    TestResObj* tmp_resObj=[[TestResObj alloc]init];
    
    [tmp_resObj setData_str:@"hehehehehe"];
    [[AopCache getInstance] record:m_record saveRecordIntoCache:tmp_resObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
