# SecurityStore

SecurityStore is a simple wrapper for accessing keychain iOS.It is simple to use like NSUserDefault.

## Adding to Your Project

Simply add the following to your Podfile if you're using CocoaPods:

``` 
pod 'SecurityStore'
```

To manually add to your project:

Add `SecurityStore.h`, `SecurityStore.m` to your project.

SecurityStore requires ARC.

## Working with the Keychain

SecurityStore has the following class methods for working with the system keychain:

```objective-c
+ (instancetype)standardSecurityStore;
- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(NSString *)value
           forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;
```
