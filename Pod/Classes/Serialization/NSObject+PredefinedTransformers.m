//
//  NSObject+PredefinedTransformers.m
//  Pods
//
//  Created by vlad gorbenko on 9/10/15.
//
//

#import "NSObject+PredefinedTransformers.h"

#import "NSObject+FluentJ.h"

#import "NSValueTransformer+PredefinedTransformers.h"

#import "FJPropertyDescriptor.h"

@implementation NSObject (PredefinedTransformers)

+ (NSValueTransformer *)transformerWithPropertyDescriptor:(FJPropertyDescriptor *)propertyDescriptor {
    NSDictionary *transformers = [self modelTransformers];
    NSValueTransformer *transformer = transformers[propertyDescriptor.name];
    if(!transformer) {
        if(propertyDescriptor.typeClass != nil) {
            if(propertyDescriptor.typeClass == NSNumber.class) {
                transformer = [NSValueTransformer valueTransformerForName:FJNumberValueTransformer];
            } else if(propertyDescriptor.typeClass == NSURL.class) {
                transformer = [NSValueTransformer valueTransformerForName:FJURLValueTransformer];
            } else if(propertyDescriptor.typeClass == NSString.class) {
                transformer = [NSValueTransformer valueTransformerForName:FJEmptyValueTransformer];
            }
        } else if(propertyDescriptor.type != NULL) {
            if(strcmp(propertyDescriptor.type, @encode(BOOL)) == 0) {
                transformer = [NSValueTransformer valueTransformerForName:FJBoolValueTransformer];
            } else {
                transformer = [NSValueTransformer valueTransformerForName:FJEmptyValueTransformer];
            }
        }
    }
    return transformer;
}

@end
