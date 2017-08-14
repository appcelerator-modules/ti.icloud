/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiIcloudModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiIcloudModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"08f54473-ee58-40da-bc00-154cfdc1ac2c";
}

- (NSString *)moduleId
{
  return @"ti.icloud";
}

#pragma mark Utility
- (NSUbiquitousKeyValueStore *)keyValueStore
{
  return [NSUbiquitousKeyValueStore defaultStore];
}

#pragma mark Public APIs

- (NSNumber *)isSupported:(id)args
{
  DEPRECATED_REMOVED(@"iCloud.isSupported()", @"2.0.0", @"2.0.0. iCloud is always supported in devices running iOS 5 and later. Since Titanium targets a higher minimum SDK version, this method becomes obsolete these days");
  return NUMBOOL(YES);
}

#pragma mark Events

- (void)storeUpdated:(NSNotification *)notification
{
  NSLog(@"[DEBUG] iCloud Change Detected; firing event...");
  NSDictionary *userInfo = [notification userInfo];
  NSNumber *reason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
  NSArray *keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
  switch ([reason integerValue]) {
  case NSUbiquitousKeyValueStoreServerChange:
    [self fireEvent:@"externalChange" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
    break;
  case NSUbiquitousKeyValueStoreInitialSyncChange:
    [self fireEvent:@"needsInitialSync" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
    break;
  case NSUbiquitousKeyValueStoreQuotaViolationChange:
    [self fireEvent:@"quotaViolated" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
    break;
  case NSUbiquitousKeyValueStoreAccountChange:
    [self fireEvent:@"accountChange" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
    break;
  default:
    NSLog(@"[ERROR] Unknown change reason sent from iCloud: %d!", [reason integerValue]);
    break;
  }
}

- (void)_listenerAdded:(NSString *)type count:(int)count
{
  listenerCount++;
  if (listenerCount == 1) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeUpdated:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[self keyValueStore]];
  }
}

- (void)_listenerRemoved:(NSString *)type count:(int)count
{
  listenerCount--;
  if (listenerCount == 0) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:[self keyValueStore]];
  }
}

#pragma mark Disk Synchronization

- (NSNumber *)sync:(id)unused
{
  return NUMBOOL([[self keyValueStore] synchronize]);
}

#pragma mark Data Setters

- (void)setString:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSString);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSString *value = [TiUtils stringValue:[args objectAtIndex:1]];

  [[self keyValueStore] setString:value forKey:key];
}

- (void)setBool:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  BOOL value = [TiUtils boolValue:[args objectAtIndex:1]];

  [[self keyValueStore] setBool:value forKey:key];
}

- (void)setDictonary:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSDictionary);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSDictionary *value = [args objectAtIndex:1];

  [[self keyValueStore] setDictionary:value forKey:key];
}

- (void)setList:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSArray);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSArray *value = [args objectAtIndex:1];

  [[self keyValueStore] setArray:value forKey:key];
}

- (void)setInt:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  // NOTE: We coerce the int to a double...
  double value = [TiUtils doubleValue:[args objectAtIndex:1]];
  // so that we can still store it in iCloud! (There is no "setInt" method yet.)

  [[self keyValueStore] setDouble:value forKey:key];
}

- (void)setDouble:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  double value = [TiUtils doubleValue:[args objectAtIndex:1]];

  [[self keyValueStore] setDouble:value forKey:key];
}

- (void)setObject:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  id value = [args objectAtIndex:1];

  [[self keyValueStore] setObject:value forKey:key];
}

#pragma mark Data Getters

- (NSString *)getString:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self keyValueStore] stringForKey:key];
}

- (NSNumber *)getBool:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return NUMBOOL([[self keyValueStore] boolForKey:key]);
}

- (NSDictionary *)getDictonary:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self keyValueStore] dictionaryForKey:key];
}

- (NSArray *)getList:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self keyValueStore] arrayForKey:key];
}

- (NSNumber *)getInt:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  // NOTE: iCloud doesn't have a "intForKey" method, so we instead grab it as a double.

  return NUMINT([[self keyValueStore] doubleForKey:key]);
}

- (NSNumber *)getDouble:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return NUMDOUBLE([[self keyValueStore] doubleForKey:key]);
}

- (id)getObject:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self keyValueStore] objectForKey:key];
}

- (NSDictionary *)getAll:(NSArray *)args
{
  return [[self keyValueStore] dictionaryRepresentation];
}

#pragma mark Data Removers

- (void)remove:(NSArray *)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  [[self keyValueStore] removeObjectForKey:key];
}

@end
