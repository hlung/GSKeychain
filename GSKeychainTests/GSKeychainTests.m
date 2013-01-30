//
//  GSKeychainTests.m
//  GSKeychainTests
//
//  Created by Simon Whitaker on 16/07/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSKeychainTests.h"
#import "GSKeychain.h"

static NSString *testKey = nil;
static NSString *testSecret = nil;

@implementation GSKeychainTests

+ (void)initialize
{
    testKey = @"secret key";
    testSecret = [[NSDate date] description];
}

- (void)setUp
{
    [super setUp];
    
    // Precondition: secret doesn't exist in the keychain to begin with
    [[GSKeychain systemKeychain] removeSecretForKey:testKey];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEverything
{
    GSKeychain *kc = [GSKeychain systemKeychain];
    
    NSString *secret;
    
    // Make sure secretForKey returns nil
    secret = [kc secretForKey:testKey];
    STAssertNil(secret, @"secretForKey: returns nil when secret not set");
    
    [kc setSecret:testSecret forKey:testKey];
    secret = [kc secretForKey:testKey];
    STAssertEqualObjects(secret, testSecret, @"secretForKey: returns secret once set");
    
    NSString *newSecret = [testSecret stringByAppendingString:@"new!"];
    [kc setSecret:newSecret forKey:testKey];
    secret = [kc secretForKey:testKey];
    STAssertEqualObjects(secret, newSecret, @"secretForKey: returns new secret after update");
    
    [kc removeSecretForKey:testKey];
    secret = [kc secretForKey:testKey];
    STAssertNil(secret, @"secretForKey: returns nil when secret removed");
}

- (void)testRemoveAll
{
    GSKeychain *kc = [GSKeychain systemKeychain];
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    
    [kc setSecret:@"Some secret" forKey:key1];
    [kc setSecret:@"Another secret" forKey:key2];
    
    STAssertNotNil([kc secretForKey:key1], @"Sanity check: make sure secret is in keychain");
    STAssertNotNil([kc secretForKey:key2], @"Sanity check: make sure secret is in keychain");
    
    [kc removeAllSecrets];
    
    STAssertNil([kc secretForKey:key1], @"Secret for key1 was deleted by removeAllSecrets");
    STAssertNil([kc secretForKey:key2], @"Secret for key2 was deleted by removeAllSecrets");
}

@end
