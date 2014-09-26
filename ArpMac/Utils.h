//
//  Utils.h
//  ArpMac
//
//  Created by Evgeniy Kapralov on 17/09/14.
//  Copyright (c) 2014 Kapralos Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString*)ipToMac:(NSString*)ipAddress;
+ (NSString*)getDefaultGatewayIp;

@end
