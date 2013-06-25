//
//  Data.m
//  CollectionViewPracs
//
//  Created by Ha Minh Vuong on 6/22/13.
//  Copyright (c) 2013 Ha Minh Vuong. All rights reserved.
//

#import "Data.h"

@interface Data()
@property (nonatomic, strong) NSArray *array;
@end

@implementation Data

+ (id)sharedInstance
{
    static Data *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
//        _array = [instance makeArrayOfString];
    });
    return instance;
}

+ (NSArray *)data
{
    Data *data = [Data sharedInstance];
    NSArray *array = data.array;
    if (nil == array) {
        data.array = [data makeArrayOfString];
    }
    return array;
}


- (NSArray *)makeArrayOfString
{
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    for (int j = 0; j < 10; j++) {
        NSMutableArray *marr = [NSMutableArray new];
        marray[j] = marr;
        for (int i = 0; i < 5; i++) {
            marr[i] = [NSString stringWithFormat:@"%d.%d", j, i];
        }
    }
    return [NSArray arrayWithArray:marray];
}

@end
