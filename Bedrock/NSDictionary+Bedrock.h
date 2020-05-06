//
//  NSDictionary+Bedrock.h
//  Bedrock
//
//  Created by Nick Forge on 23/05/2016.
//  Copyright © 2016 Nick Forge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (Bedrock)


//
// Filtering/Selecting/Finding
//

- (NSDictionary<KeyType, ObjectType> *)br_allEntriesWhere:(BOOL (^)(KeyType key, ObjectType obj))block;


//
// Mapping
//

// Entries that return nil won't be added to the resulting array.
- (NSArray *)br_arrayByMapping:(nullable id (^)(KeyType key, ObjectType obj))block;

// Will return a dictionary with the original keys, and objects that are the returned values of <block>.
- (NSDictionary<KeyType, id> *)br_dictionaryByMappingObjects:(id (^)(KeyType key, ObjectType obj))block;


//
// Merging
//

// If both <self> and <dictionary> have entries for a particular key, the entry in <dictionary> will
// take precedence.
- (NSDictionary<KeyType, ObjectType> *)br_dictionaryByAddingEntriesFromDictionary:(NSDictionary<KeyType, ObjectType> *)dictionary;


//
// Copying
//

// Will return a "deep copy". When called on an NSArray or NSDictionary, it will
// call -br_deepCopy on each object if it responds to -br_deepCopy, or -copy otherwise.
// Note that this won't be able to deep copy array or dictionary properties on objects
// _within_ an array or dictionary, unless the object itself implements -br_deepCopy.
- (instancetype)br_deepCopy;


//
// Nested traversal
//

// <keyPath> is split by "." characters, and then each path component is used to
// try and traverse a nested dictionary using objectForKey:. If any of the values
// returned while traversing the nested dictionary are either nil or not an
// NSDictionary, the method will return nil.
- (nullable id)br_nestedObjectForKeyPath:(NSString *)keyPath;


//
// Parsing
//

- (nullable NSString *)br_stringForKey:(KeyType)key;
- (nullable NSString *)br_stringForKey:(KeyType)key defaultValue:(NSString *)value;

- (NSInteger)br_integerForKey:(KeyType)key;
- (NSInteger)br_integerForKey:(KeyType)key defaultValue:(NSInteger)integer;

- (BOOL)br_boolForKey:(KeyType)key;
- (BOOL)br_boolForKey:(KeyType)key defaultValue:(BOOL)defaultValue;

- (double)br_doubleForKey:(KeyType)key;
- (double)br_doubleForKey:(KeyType)key defaultValue:(BOOL)defaultValue;

- (nullable NSArray *)br_arrayForKey:(KeyType)key;
- (nullable NSArray *)br_arrayForKey:(KeyType)key defaultValue:(NSArray *)defaultValue;

- (nullable NSDictionary *)br_dictionaryForKey:(KeyType)key;
- (nullable NSDictionary *)br_dictionaryForKey:(KeyType)key defaultValue:(NSDictionary *)defaultValue;

- (nullable ObjectType)br_objectForKey:(KeyType)key ifItIsKindOfClass:(Class)class defaultValue:(nullable id)defaultValue;


//
// Descriptions
//

// Generates a concisely formatted description of the dictionary contents on a single line, e.g.
//
// @{@"a": @1, @"b": @2}.br_singleLineDescription => @"{a: 1, b: 2}"
//
- (NSString *)br_singleLineDescription;


@end


@interface NSMutableDictionary<KeyType, ObjectType> (Bedrock)


//
// Removing Entries
//

- (void)br_removeEntriesWhere:(BOOL(^)(KeyType key, ObjectType object))block;


@end

NS_ASSUME_NONNULL_END
