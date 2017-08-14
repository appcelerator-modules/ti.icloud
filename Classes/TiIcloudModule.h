/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface TiIcloudModule : TiModule {
  int listenerCount;
}

- (NSNumber *)isSupported:(id __unused)args;

- (NSNumber *)sync:(id __unused)unused;

- (void)setString:(NSArray *)args;

- (void)setBool:(NSArray *)args;

- (void)setDictonary:(NSArray *)args;

- (void)setList:(NSArray *)args;

- (void)setInt:(NSArray *)args;

- (void)setDouble:(NSArray *)args;

- (void)setObject:(NSArray *)args;

- (NSString * _Nullable)getString:(NSArray *)args;

- (NSNumber *)getBool:(NSArray *)args;

- (NSDictionary * _Nullable)getDictonary:(NSArray *)args;

- (NSArray * _Nullable)getList:(NSArray *)args;

- (NSNumber *)getInt:(NSArray *)args;

- (NSNumber * _Nullable)getDouble:(NSArray *)args;

- (id _Nullable)getObject:(NSArray *)args;

- (NSDictionary * _Nullable)getAll:(NSArray *)args;

- (void)remove:(NSArray *)args;

@end

NS_ASSUME_NONNULL_END
