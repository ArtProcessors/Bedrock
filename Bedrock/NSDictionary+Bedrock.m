//
//  NSDictionary+Bedrock.m
//  Bedrock
//
//  Created by Nick Forge on 23/05/2016.
//  Copyright © 2016 Nick Forge. All rights reserved.
//

#import "NSDictionary+Bedrock.h"
#import "NSArray+Bedrock.h"
#import "BedrockMacros.h"

@implementation NSDictionary (Bedrock)

- (NSDictionary *)br_allEntriesWhere:(BOOL (^)(id, id))block
{
	NSMutableDictionary *result = self.mutableCopy;
	[result br_removeEntriesWhere:^BOOL(id key, id object) {
		return block(key, object) == NO;
	}];
	return result.copy;
}

- (NSArray *)br_arrayByMapping:(id (^)(id, id))block
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		id mappedObject = block(key, obj);
		if (mappedObject != nil) {
			[result addObject:mappedObject];
		}
	}];
	return result.copy;
}

- (NSDictionary *)br_dictionaryByMappingObjects:(id (^)(id, id))block
{
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		id mappedObject = block(key, obj);
		if (mappedObject != nil) {
			[result setObject:mappedObject forKey:key];
		}
	}];
	return result.copy;
}

- (NSDictionary *)br_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
	NSMutableDictionary *result = self.mutableCopy;
	[dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[result setObject:obj forKey:key];
	}];
	return result.copy;
}

- (id)br_deepCopy
{
	return [self br_dictionaryByMappingObjects:^id(id key, id object) {
		if ([object respondsToSelector:@selector(br_deepCopy)]) {
			return [object br_deepCopy];
		}
		if ([object respondsToSelector:@selector(copy)]) {
			return [object copy];
		}
		return object;
	}].copy;
}

- (nullable id)br_nestedObjectForKeyPath:(NSString *)keyPath
{
	NSArray<NSString *> *components = [keyPath componentsSeparatedByString:@"."];
	if (components.count == 0) return nil;
	if (components.count == 1) {
		id firstObject = components.firstObject;
		return [self objectForKey:firstObject];
	}
	id firstObject = components.firstObject;
	id object = [self objectForKey:firstObject];
	NSDictionary *objectAsDictionary = AsClass(object, NSDictionary);
	if (objectAsDictionary != nil) {
		NSString *tailKeyPath = [[components br_subarrayFromIndex:1] componentsJoinedByString:@"."];
		return [objectAsDictionary br_nestedObjectForKeyPath:tailKeyPath];
	} else {
		return nil;
	}
}

- (nullable id)br_objectForKey:(NSString *)key ifItIsKindOfClass:(Class)class defaultValue:(nullable id)defaultValue
{
	id obj = self[key];
	if (!obj) {
		return defaultValue;
	}
	else if ([obj isKindOfClass:class]) {
		return obj;
	}
	else {
		return defaultValue;
	}
}

- (nullable NSString *)br_stringForKey:(NSString *)key
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSString class] defaultValue:nil];
}

- (nullable NSString *)br_stringForKey:(NSString *)key defaultValue:(NSString *)value
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSString class] defaultValue:value];
}

- (NSInteger)br_integerForKey:(NSString *)key
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:nil] integerValue];
}

- (NSInteger)br_integerForKey:(NSString *)key defaultValue:(NSInteger)value
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:@(value)] integerValue];
}

- (BOOL)br_boolForKey:(NSString *)key
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:nil] boolValue];
}

- (BOOL)br_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:@(defaultValue)] boolValue];
}

- (double)br_doubleForKey:(NSString *)key
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:nil] doubleValue];
}

- (double)br_doubleForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
	return [[self br_objectForKey:key ifItIsKindOfClass:[NSNumber class] defaultValue:@(defaultValue)] doubleValue];
}

- (nullable NSArray *)br_arrayForKey:(NSString *)key
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSArray class] defaultValue:nil];
}

- (nullable NSArray *)br_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSArray class] defaultValue:defaultValue];
}

- (nullable NSDictionary *)br_dictionaryForKey:(NSString *)key
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSDictionary class] defaultValue:nil];
}

- (nullable NSDictionary *)br_dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
	return [self br_objectForKey:key ifItIsKindOfClass:[NSDictionary class] defaultValue:defaultValue];
}

- (NSString *)br_singleLineDescription
{
	NSArray<NSString *> *entryDescriptions = [self br_arrayByMapping:^id (id key, id obj) {
		return [NSString stringWithFormat:@"%@: %@", key, obj];
	}];
	return [NSString stringWithFormat:@"{%@}", [entryDescriptions componentsJoinedByString:@", "]];
}

@end


@implementation NSMutableDictionary (Bedrock)

- (void)br_removeEntriesWhere:(BOOL (^)(id, id))block
{
	NSMutableArray *keysToRemove = [NSMutableArray new];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if (block(key, obj)) {
			[keysToRemove addObject:key];
		}
	}];
	[self removeObjectsForKeys:keysToRemove];
}

@end
