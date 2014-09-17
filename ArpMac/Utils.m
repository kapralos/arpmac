//
//  Utils.m
//  ArpMac
//
//  Created by Evgeniy Kapralov on 17/09/14.
//  Copyright (c) 2014 Kapralos Software. All rights reserved.
//

#import "Utils.h"

#if (TARGET_IPHONE_SIMULATOR)
#import <net/if_types.h>
#import <net/route.h>
#import <netinet/if_ether.h>
#else
#import "if_types.h"
#import "route.h"
#import "if_ether.h"
#endif

#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <net/if_dl.h>

@interface Utils()

+ (void)logSockaddrInarp:(struct sockaddr_inarp)sockaddr;

@end

@implementation Utils

+ (NSString*)ipToMac:(NSString*)ipAddress
{
    NSString* res = nil;
    
    in_addr_t addr = inet_addr([ipAddress UTF8String]);
    
    size_t needed;
    char *buf, *next;
    
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    
    int mib[6];
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0)
        NSLog(@"route-sysctl-estimate");
    
    if ((buf = (char*)malloc(needed)) == NULL)
        NSLog(@"malloc");
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0)
        NSLog(@"retrieval of routing table");
    
    for (next = buf; next < buf + needed; next += rtm->rtm_msglen) {
        
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        
        [Utils logSockaddrInarp:*sin];
        
        if (addr != sin->sin_addr.s_addr || sdl->sdl_alen < 6)
            continue;
        
        u_char *cp = (u_char*)LLADDR(sdl);
        
        res = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
               cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        
        break;
    }
    
    free(buf);
    
    return res;
}

+ (void)logSockaddrInarp:(struct sockaddr_inarp)sockaddr
{
    printf("sockaddr_inarp:\n");
    printf("    sin_addr = %s\n", inet_ntoa(sockaddr.sin_addr));
    printf("    sin_family = %uc\n", sockaddr.sin_family);
    printf("    sin_len = %uc\n", sockaddr.sin_len);
    printf("    sin_other = %us\n", sockaddr.sin_other);
    printf("    sin_port = %us\n", sockaddr.sin_port);
    printf("    sin_srcaddr = %s\n", inet_ntoa(sockaddr.sin_srcaddr));
    printf("    sin_tos = %us\n", sockaddr.sin_tos);
}

@end
