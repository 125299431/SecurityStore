# SecurityStore

SecurityStore is a simple wrapper like NSUserDefaults style for saving sensitive data using the system Keychain on iOS.

## Adding to Your Project

Simply add the following to your Podfile if you're using CocoaPods:

``` 
pod 'SecurityStore'
```

To manually add to your project:

Add `SecurityStore.h`, `SecurityStore.m` to your project.

SecurityStore requires ARC.

## Working with the Keychain like using NSUserDefaults

SecurityStore has the following class methods for working with the system keychain:

```objective-c
+ (instancetype)standardSecurityStore;
- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(NSString *)value
           forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;
```
