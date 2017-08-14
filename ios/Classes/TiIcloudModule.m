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

#pragma mark -
#pragma mark Utility
- (NSUbiquitousKeyValueStore *)getStore
{
  return [NSUbiquitousKeyValueStore defaultStore];
}

#pragma mark -
#pragma mark Public APIs

- (id)isSupported:(id)args
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
  default:
    NSLog(@"[ERROR] Unknown change reason sent from iCloud: %d!", [reason intValue]);
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
                                               object:[self getStore]];
  }
}

- (void)_listenerRemoved:(NSString *)type count:(int)count
{
  listenerCount--;
  if (listenerCount == 0) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:[self getStore]];
  }
}

#pragma mark Disk Synchronization

- (id)sync:(id)args
{
  return NUMBOOL([[self getStore] synchronize]);
}

#pragma mark Data Setters

- (void)setString:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSString);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSString *value = [TiUtils stringValue:[args objectAtIndex:1]];

  [[self getStore] setString:value forKey:key];
}

- (void)setBool:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  BOOL value = [TiUtils boolValue:[args objectAtIndex:1]];

  [[self getStore] setBool:value forKey:key];
}

- (void)setDictonary:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSDictionary);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSDictionary *value = [args objectAtIndex:1];

  [[self getStore] setDictionary:value forKey:key];
}

- (void)setList:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSArray);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  NSArray *value = [args objectAtIndex:1];

  [[self getStore] setArray:value forKey:key];
}

- (void)setInt:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  // NOTE: We coerce the int to a double...
  double value = [TiUtils doubleValue:[args objectAtIndex:1]];
  // so that we can still store it in iCloud! (There is no "setInt" method yet.)

  [[self getStore] setDouble:value forKey:key];
}

- (void)setDouble:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  ENSURE_TYPE([args objectAtIndex:1], NSNumber);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  double value = [TiUtils doubleValue:[args objectAtIndex:1]];

  [[self getStore] setDouble:value forKey:key];
}

- (void)setObject:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);

  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  id value = [args objectAtIndex:1];

  [[self getStore] setObject:value forKey:key];
}

#pragma mark Data Getters

- (id)getString:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self getStore] stringForKey:key];
}

- (id)getBool:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return NUMBOOL([[self getStore] boolForKey:key]);
}

- (id)getDictonary:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self getStore] dictionaryForKey:key];
}

- (id)getList:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self getStore] arrayForKey:key];
}

- (id)getInt:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  // NOTE: iCloud doesn't have a "intForKey" method, so we instead grab it as a double.

  return NUMINT([[self getStore] doubleForKey:key]);
}

- (id)getDouble:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return NUMDOUBLE([[self getStore] doubleForKey:key]);
}

- (id)getObject:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  return [[self getStore] objectForKey:key];
}

- (id)getAll:(id)args
{
  return [[self getStore] dictionaryRepresentation];
}

#pragma mark Data Removers

- (void)remove:(id)args
{
  ENSURE_TYPE([args objectAtIndex:0], NSString);
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];

  [[self getStore] removeObjectForKey:key];
}

@end
