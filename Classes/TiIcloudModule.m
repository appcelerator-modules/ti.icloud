/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiIcloudModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiIcloudModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"08f54473-ee58-40da-bc00-154cfdc1ac2c";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.icloud";
}

#pragma mark Cleanup 

-(void)dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark Public APIs

#pragma mark Events

-(void)storeUpdated:(NSNotification*)notification
{
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    NSLog(@"[INFO] iCloud Change Detected; firing event...");
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSArray* keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    switch ([reason integerValue])
    {
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
#endif
}

-(void)_listenerAdded:(NSString*)type count:(int)count
{
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    listenerCount++;
    if (listenerCount == 1)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeUpdated:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:[NSUbiquitousKeyValueStore defaultStore]];
    }
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)_listenerRemoved:(NSString*)type count:(int)count
{
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    listenerCount--;
    if (listenerCount == 0)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                      object:[NSUbiquitousKeyValueStore defaultStore]];
    }
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

#pragma mark Disk Synchronization

-(id)sync:(id)args
{
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return NUMBOOL([[NSUbiquitousKeyValueStore defaultStore] synchronize]);
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return NUMBOOL(NO);
#endif
}

#pragma mark Data Setters

-(void)setString:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSString);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString* value = [TiUtils stringValue:[args objectAtIndex:1]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setString:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)setBool:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    bool value = [TiUtils boolValue:[args objectAtIndex:1]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setBool:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)setDictonary:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSDictionary);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSDictionary* value = [args objectAtIndex:1];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setDictionary:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}


-(void)setList:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSArray);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSArray* value = [args objectAtIndex:1];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setArray:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)setInt:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    // NOTE: We coerce the int to a double...
    double value = [TiUtils doubleValue:[args objectAtIndex:1]];
    // so that we can still store it in iCloud! (There is no "setInt" method yet.)
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setDouble:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)setDouble:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    double value = [TiUtils doubleValue:[args objectAtIndex:1]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setDouble:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

-(void)setObject:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    id value = [args objectAtIndex:1];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

#pragma mark Data Getters

-(id)getString:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getBool:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return NUMBOOL([[NSUbiquitousKeyValueStore defaultStore] boolForKey:key]);
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getDictonary:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [[NSUbiquitousKeyValueStore defaultStore] dictionaryForKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getList:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getInt:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    // NOTE: iCloud doesn't have a "intForKey" method, so we instead grab it as a double.
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return NUMINT([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:key]);
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getDouble:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return NUMDOUBLE([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:key]);
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getObject:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

-(id)getAll:(id)args
{
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    return [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
    return nil;
#endif
}

#pragma mark Data Removers

-(void)remove:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString* key = [TiUtils stringValue:[args objectAtIndex:0]];
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
#else
    NSLog(@"[ERROR] iCloud module compiled without support for iOS 5.0! Nothing will work unless you recompile the module!");
#endif
}

@end
