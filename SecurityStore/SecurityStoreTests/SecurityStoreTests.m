//
//  SecurityStoreTests.m
//  SecurityStoreTests
//
//  Created by Hunter Zhang on 16/1/23.
//  Copyright © 2016年 Hunter Zhang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SecurityStore.h"

@interface SecurityStoreTests : XCTestCase

@end

@implementation SecurityStoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    SecurityStore* store = [SecurityStore standardSecurityStore];
    NSString* originalPassword = @"123456";
    [store setObject:originalPassword forKey:@"password"];
    NSString* password = [store objectForKey:@"password"];
    XCTAssertEqualObjects(originalPassword, password, @"password is not equal");
    [store removeObjectForKey:@"password"];
    password = [store objectForKey:@"password"];
    XCTAssertNil(password,@"remove item fails");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
