//
//  NSObject+FluentJ.m
//  Pods
//
//  Created by vlad gorbenko on 9/6/15.
//
//

#import "NSObject+FluentJ.h"

#import "NSObject+Properties.h"

#import "FJPropertyDescriptor.h"

#import "FJValueTransformer.h"
#import "FJModelValueTransformer.h"
#import "NSValueTransformer+PredefinedTransformers.h"
#import "NSObject+PredefinedTransformers.h"

#import "NSDictionary+Init.h"

@implementation NSObject (FluentJ)

#pragma mark - Import

+ (id)importValues:(id)values userInfo:(NSDictionary *)userInfo error:(NSError **)error {
    return [self importValues:values context:nil userInfo:userInfo error:error];
}

+ (id)importValues:(id)values context:(id)context userInfo:(NSDictionary *)userInfo error:(NSError **)error {
    NSMutableArray *items = [NSMutableArray array];
    for(id value in values) {
        id item = [self importValue:value userInfo:userInfo error:error];
        if(item) {
            [items addObject:item];
        }
    }
    return items;
}

+ (id)importValue:(id)value userInfo:(NSDictionary *)userInfo error:(NSError **)error {
    return [self importValue:value context:nil userInfo:userInfo error:error];
}

+ (id)importValue:(id)values context:(id)context userInfo:(NSDictionary *)userInfo error:(NSError **)error {
    if(!values) {
        return nil;
    }
//    NSSet *properties = [[self class] properties];
//    NSDictionary *keys = [[self class] keysForKeyPaths:userInfo] ?: [self keysWithProperties:properties];
//    NSArray *allKeys = [keys allKeys];
    id item = [[[self class] alloc] init];
    [item updateWithValue:values context:context userInfo:userInfo error:error];
//    for(FJPropertyDescriptor *propertyDescriptor in properties) {
//        if(![allKeys containsObject:propertyDescriptor.name]) {
//            continue;
//        }
//        [item willImportWithUserInfo:userInfo];
//        id value = values[keys[propertyDescriptor.name]];
//        if([value isKindOfClass:[NSNull class]]) {
//            continue;
//        }
//        BOOL isCollection = [propertyDescriptor.typeClass conformsToProtocol:@protocol(NSFastEnumeration)];
//        NSValueTransformer *transformer = [self transformerWithPropertyDescriptor:propertyDescriptor];
//        if(transformer && !isCollection) {
//            value = [transformer transformedValue:value];
//        } else {
//            NSDictionary *subitemUserInfo = [userInfo dictionaryWithKeyPrefix:NSStringFromClass([self class])];
//            if(isCollection) {
//                NSAssert(transformer, ([NSString stringWithFormat:@"You should provide transformer for property: %@", propertyDescriptor.name]));
//                if([transformer isKindOfClass:FJModelValueTransformer.class]) {
//                    FJModelValueTransformer *modelTransformer = (FJModelValueTransformer *)transformer;
//                    modelTransformer.userInfo = subitemUserInfo;
//                    modelTransformer.context = context;
//                }
//                id subitems = [transformer transformedValue:value];
//                id oldValue = [item valueForKey:propertyDescriptor.name];
//                if([oldValue count]) {
//                    [oldValue addObjectsFromArray:subitems];
//                    value = nil;
//                } else {
//                    value = [[propertyDescriptor.typeClass alloc] initWithArray:subitems];
//                }
//            } else {
//                value = [propertyDescriptor.typeClass importValue:value userInfo:subitemUserInfo error:error];
//            }
//        }
//        if(value) {
//            [item setValue:value forKey:propertyDescriptor.name];
//        }
//    }
//    [item didImportWithUserInfo:userInfo];
    return item;
}

#pragma mark - Update

- (void)updateWithValue:(id)values context:(id)context userInfo:(NSDictionary *)userInfo error:(NSError **)error {
    if(!values) {
        return;
    }
    NSSet *properties = [[self class] properties];
    NSDictionary *keys = [[self class] keysForKeyPaths:userInfo] ?: [[self class] keysWithProperties:properties];
    NSArray *allKeys = [keys allKeys];
    [self willImportWithUserInfo:userInfo];
    for(FJPropertyDescriptor *propertyDescriptor in properties) {
        if(![allKeys containsObject:propertyDescriptor.name]) {
            continue;
        }
        id value = values[keys[propertyDescriptor.name]];
        if([value isKindOfClass:[NSNull class]]) {
            continue;
        }
        BOOL isCollection = [propertyDescriptor.typeClass conformsToProtocol:@protocol(NSFastEnumeration)];
        NSValueTransformer *transformer = [[self class] transformerWithPropertyDescriptor:propertyDescriptor];
        if(transformer && !isCollection) {
            value = [transformer transformedValue:value];
        } else {
            NSDictionary *subitemUserInfo = [userInfo dictionaryWithKeyPrefix:NSStringFromClass([self class])];
            if(isCollection) {
                NSAssert(transformer, ([NSString stringWithFormat:@"You should provide transformer for property: %@", propertyDescriptor.name]));
                if([transformer isKindOfClass:FJModelValueTransformer.class]) {
                    FJModelValueTransformer *modelTransformer = (FJModelValueTransformer *)transformer;
                    modelTransformer.userInfo = subitemUserInfo;
                    modelTransformer.context = context;
                }
                id subitems = [transformer transformedValue:value];
                id oldValue = [self valueForKey:propertyDescriptor.name];
                if([oldValue count] && [subitems count]) {
                    if([NSStringFromClass([oldValue class]) containsString:@"Mutable"]) {
                        [oldValue addObjectsFromArray:subitems];
                        value = nil;
                    } else {
                        NSMutableArray *newValues = [NSMutableArray array];
//                        id mutableCollection = [[[[oldValue class] alloc] init] mutableCopy];
                        [newValues addObjectsFromArray:[oldValue allObjects]];
                        [newValues addObjectsFromArray:subitems];
                        value = [[[oldValue class] alloc] initWithArray:newValues];
                    }
                } else {
                    value = [[propertyDescriptor.typeClass alloc] initWithArray:subitems];
                }
            } else {
                id subvalue = [self valueForKey:propertyDescriptor.name];
                if(subvalue) {
                    [subvalue updateWithValue:value context:context userInfo:subitemUserInfo error:error];
                    value = nil;
                } else {
                    value = [propertyDescriptor.typeClass importValue:value userInfo:subitemUserInfo error:error];
                }
            }
        }
        if(value) {
            [self setValue:value forKey:propertyDescriptor.name];
        }
    }
    [self didImportWithUserInfo:userInfo];
}

#pragma mark - Export

- (id)exportValuesWithKeys:(NSArray *)keys {
    return nil;
}

- (id)exportValuesWithKeys:(NSArray *)keys error:(NSError **)error {
    return nil;
}

+ (NSMutableDictionary *)modelTransformers {
    return [NSMutableDictionary dictionary];
}

#pragma mark - Notifications

- (void)willImportWithUserInfo:(NSDictionary *)userInfo {
}

- (void)didImportWithUserInfo:(NSDictionary *)userInfo {
}

#pragma mark - Serialization methods

+ (NSDictionary *)keysForKeyPaths:(NSDictionary *)userInfo {
    return nil;
}

#pragma mark - Utils

+ (NSDictionary *)keysWithProperties:(NSSet *)properties {
    NSMutableDictionary *keys = [NSMutableDictionary dictionary];
    for(FJPropertyDescriptor *propertyDescriptor in properties) {
        [keys setValue:propertyDescriptor.name forKey:propertyDescriptor.name];
    }
    return keys;
}

@end
