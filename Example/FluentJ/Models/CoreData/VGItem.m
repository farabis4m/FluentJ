//
//  VGItem.m
//  FluentJ
//
//  Created by vlad gorbenko on 9/9/15.
//  Copyright (c) 2015 vlad gorbenko. All rights reserved.
//

#import "VGItem.h"
#import "VGItem.h"


@implementation VGItem

@dynamic name;
@dynamic user;

+ (NSDictionary *)keysForKeyPaths:(NSDictionary *)userInfo {
    return @{@"name" : @"name"};
}

@end
