//
//  ViewController.m
//  ArpMac
//
//  Created by Evgeniy Kapralov on 17/09/14.
//  Copyright (c) 2014 Kapralos Software. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"

@interface ViewController ()

@property (weak) IBOutlet UITextField* ipAddressTextField;
@property (weak) IBOutlet UILabel* macAddrLabel;
@property (weak) IBOutlet UILabel* routerIpAddressLabel;
@property (weak) IBOutlet UILabel* routerMacLabel;

- (IBAction)findPressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.routerIpAddressLabel.text = [Utils getDefaultGatewayIp];
    self.routerMacLabel.text = [Utils ipToMac:self.routerIpAddressLabel.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPressed:(id)sender
{
    self.macAddrLabel.text = [Utils ipToMac:self.ipAddressTextField.text];
}

@end
