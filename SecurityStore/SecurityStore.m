//
//  SecurityStore.m
//  SecurityStore
//
//  Created by Hunter Zhang on 16/1/23.
//  Copyright © 2016年 Hunter Zhang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//  to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "SecurityStore.h"
static const NSString* service = @"service";

@interface SecurityStore ()

@property (strong, nonatomic) NSMutableDictionary *mapping;

@end

@implementation SecurityStore

+ (instancetype)standardSecurityStore
{
    static SecurityStore *sharedSecurityStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSecurityStore = [[self alloc] init];
    });
    return sharedSecurityStore;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)objectForKey:(NSString *)defaultName
{
    return [self getObjectForKey:defaultName];
}

- (void)setObject:(id)value
           forKey:(NSString *)defaultName
{
    [self saveObjectForKey:value forKey:defaultName];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    [self deleteItem:defaultName];
}

-(void)saveObjectForKey:(NSString *)value
                 forKey:(NSString*)defaultName
{
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly; 
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecAttrAccount] = defaultName;
    
    //Check if this keychain item already exists.
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        NSLog(@"Error Code: %d", (int)sts);

    }else
    {
       
        keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding]; //Our password

        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code: %d", (int)sts);
    }
}

- (id)getObjectForKey:(NSString *)defaultName
{
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecAttrAccount] = defaultName;

    
    //Check if this keychain item already exists.
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    NSLog(@"Error Code: %d", (int)sts);
    
    if(sts == noErr)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *valueData = resultDict[(__bridge id)kSecValueData];
        NSString *value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
        return value;
    }
    return nil;
}

- (void)deleteItem:(NSString *)defaultName
{
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecAttrAccount] = defaultName;
    
    //Check if this keychain item already exists.
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        NSLog(@"Error Code: %d", (int)sts);
    }
}
@end
