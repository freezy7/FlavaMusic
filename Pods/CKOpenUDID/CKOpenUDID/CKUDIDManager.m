//
//  UDIDManager.m
//  KeychainDemo
//
//  Created by iimgal's MBP on 16/1/19.
//  Copyright © 2016年 iimgal. All rights reserved.
//

#import "CKUDIDManager.h"
#import <UIKit/UIPasteboard.h>
#import "OldOpenUDID.h"

#define CL_OPENID_KEYCHAIN_KEY      @"chelun.uuid"
#define CL_KEYCAIN_SERVICE          @"com.chelun.uuidservice"
#define CL_KEYCHAIN_ERROR_DOMAIN    @"CLKeychainUtilsErrorDomain"

@implementation CKUDIDManager

static NSString *staticUDID = nil;

+ (NSString*)createOpenUdid {
    CFUUIDRef uid = CFUUIDCreate(nil);
    CFStringRef uidstr = CFUUIDCreateString(nil, uid);
    NSString* rst = (NSString*) CFStringCreateCopy(NULL, uidstr);
    CFRelease(uid);
    CFRelease(uidstr);
    return [rst autorelease];
}

+ (NSString*) getOpenUdid {
    
    if (staticUDID) {
        return staticUDID;
    }
    
    NSString* keychainudid = nil;
    
    keychainudid = [[NSUserDefaults standardUserDefaults] objectForKey:CL_OPENID_KEYCHAIN_KEY];
    
    if (keychainudid == nil) {
        keychainudid = [self getPasswordForUsername:CL_OPENID_KEYCHAIN_KEY andServiceName:CL_KEYCAIN_SERVICE error:nil];
    }
    
    if (keychainudid == nil) {
        UIPasteboard*past = [[UIPasteboard pasteboardWithName:CL_KEYCAIN_SERVICE create:NO] retain];
        if (past != nil) {
            id val = [past valueForPasteboardType:CL_OPENID_KEYCHAIN_KEY];
            if (val != nil) {
                keychainudid = [NSKeyedUnarchiver unarchiveObjectWithData:val];
            }
        }
        [past release];
    }
    
    if (keychainudid == nil) {
        keychainudid = [OldOpenUDID value];
    }
    
    if (keychainudid == nil) {
        keychainudid = [self createOpenUdid];
    }
    
    [self saveOpenUdid:keychainudid];
    
    staticUDID = [keychainudid copy];
    
    return keychainudid;
}

+ (void)saveOpenUdid:(NSString *)openUdid {
    if (openUdid != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:openUdid forKey:CL_OPENID_KEYCHAIN_KEY];
        
        [self storeUsername:CL_OPENID_KEYCHAIN_KEY andPassword:openUdid forServiceName:CL_KEYCAIN_SERVICE updateExisting:YES error:nil];
        
        UIPasteboard *past = [[UIPasteboard pasteboardWithName:CL_KEYCAIN_SERVICE create:YES] retain];
        [past setPersistent:YES];
        [past setData:[NSKeyedArchiver archivedDataWithRootObject:openUdid] forPasteboardType:CL_OPENID_KEYCHAIN_KEY];
        [past release];
    }
}

+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error
{
    if (!username || !password || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: -2000 userInfo: nil];
        }
        return NO;
    }
    
    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingPassword = [self getPasswordForUsername: username andServiceName: serviceName error:&getError];
    
    if ([getError code] == -1999)
    {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.
        
        getError = nil;
        
        [self deleteItemForUsername: username andServiceName: serviceName error: &getError];
        
        if ([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
            return NO;
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    OSStatus status = noErr;
    
    if (existingPassword)
    {
        // We have an existing, properly entered item with a password.
        // Update the existing item.
        
        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            //Only update if we're allowed to update existing.  If not, simply do nothing.
            
            NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass,
                              kSecAttrService,
                              kSecAttrLabel,
                              kSecAttrAccount,
                              nil] autorelease];
            
            NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword,
                                 serviceName,
                                 serviceName,
                                 username,
                                 nil] autorelease];
            
            NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
            
            status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (NSString *) kSecValueData]);
        }
    }
    else
    {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.
        
        NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass,
                          kSecAttrService,
                          kSecAttrLabel,
                          kSecAttrAccount,
                          kSecValueData,
                          nil] autorelease];
        
        NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword,
                             serviceName,
                             serviceName,
                             username,
                             [password dataUsingEncoding: NSUTF8StringEncoding],
                             nil] autorelease];
        
        NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
        
        status = SecItemAdd((CFDictionaryRef) query, NULL);
    }
    
    if (status != noErr)
    {
        // Something went wrong with adding the new item. Return the Keychain error code.
        if (error != nil) {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: status userInfo: nil];
        }
        
        return NO;
    }
    
    return YES;
}

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    
    if (!username || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: -2000 userInfo: nil];
        }
        return nil;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    
    NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, nil] autorelease];
    
    NSMutableDictionary *query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    NSDictionary *attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
    
    [attributeResult release];
    [attributeQuery release];
    
    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: status userInfo: nil];
        }
        
        return nil;
    }
    
    // We have an existing item, now query for the password data associated with it.
    
    NSData *resultData = nil;
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
    
    status = SecItemCopyMatching((CFDictionaryRef) passwordQuery, (CFTypeRef *) &resultData);
    
    [resultData autorelease];
    [passwordQuery release];
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            // We found attributes for the item previously, but no password now, so return a special error.
            // Users of this API will probably want to detect this error and prompt the user to
            // re-enter their credentials.  When you attempt to store the re-entered credentials
            // using storeUsername:andPassword:forServiceName:updateExisting:error
            // the old, incorrect entry will be deleted and a new one with a properly encrypted
            // password will be added.
            if (error != nil) {
                *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: -1999 userInfo: nil];
            }
        }
        else {
            // Something else went wrong. Simply return the normal Keychain API error code.
            if (error != nil) {
                *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: status userInfo: nil];
            }
        }
        
        return nil;
    }
    
    NSString *password = nil;
    
    if (resultData) {
        password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
    }
    else {
        // There is an existing item, but we weren't able to get password data for it for some reason,
        // Possibly as a result of an item being incorrectly entered by the previous code.
        // Set the -1999 error so the code above us can prompt the user again.
        if (error != nil) {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: -1999 userInfo: nil];
        }
    }
    
    return [password autorelease];
}

+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: -2000 userInfo: nil];
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil] autorelease];
    
    NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
    
    OSStatus status = SecItemDelete((CFDictionaryRef) query);
    
    if (status != noErr)
    {
        if (error != nil) {
            *error = [NSError errorWithDomain: CL_KEYCHAIN_ERROR_DOMAIN code: status userInfo: nil];
        }
        
        return NO;
    }
    
    return YES;
}

@end
