//
//  SampleTests.m
//  analytics-sample-ios
//
//  Created by Daniel Band on 28/08/14.
//  Copyright (c) 2014 5dlab GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackingInstance.h"
#import "Connector.h"

@interface SampleTests : XCTestCase

@property (nonatomic, strong) TrackingInstance *sample;

@end

@implementation SampleTests

- (void)setUp
{
  [super setUp];
  Connector *connector = [Connector new];
  connector.url = @"http://events.neurometry.com/sample/v01/event";
  self.sample = [[TrackingInstance alloc] initWithConnector:connector];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testTokenAvailability
{
  XCTAssertNotNil(self.sample.installToken, @"Installtoken should be set");
  XCTAssertNotNil(self.sample.sessionToken, @"SessionToken should be set");
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  XCTAssertNotNil([defaults objectForKey:kInstallToken], @"Installtoken should be set in the userdefaults");
}

- (void)testConnectorIsSet
{
  XCTAssertNotNil(self.sample.connector, @"Connector should not be nil");
}

- (void)testTrack
{
  [self.sample stop];
  
  [self.sample track:@"testevent" category:@"testcategory"];
  NSUInteger events = [self.sample.connector.eventQueue count];
  XCTAssertEqual(events, 1, @"Eventqueue should contain 1 entry but contains %ld", events);
}

- (void)testMergeParams
{
  NSString *client = @"testId";
  NSNumber *clientVersion = @6;
  NSString *platform = @"iOS";
  NSNumber *contentId = @99;
  NSString *contentType = @"session";
  NSString *module = @"testModule";
  NSString *parameter1 = @"parameter1";
  NSString *parameter2 = @"parameter2";
  NSString *parameter3 = @"parameter3";
  NSString *parameter4 = @"parameter4";
  NSString *parameter5 = @"parameter5";
  NSString *parameter6 = @"parameter6";
  NSString *email = @"email";
  NSString *locale = @"de";
  NSString *addReferer = @"test_referer";
  NSString *addPlacement = @"test_add";
  NSNumber *longitude = @100;
  NSNumber *latitude = @100;
  
  
  NSDictionary *params = @{@"client": client, @"client_version": clientVersion, @"platform": platform,
                               @"content_id": contentId, @"content_type": contentType, @"module": module,
                               @"parameter1": parameter1, @"parameter2": parameter2, @"parameter3": parameter3,
                               @"parameter4": parameter4,  @"parameter5": parameter5, @"parameter6": parameter6,
                               @"email": email, @"locale": locale, @"add_referer": addReferer,
                               @"add_placement": addPlacement, @"longitude": longitude, @"latitude": latitude};
  
  NSDictionary *userParams = [self.sample mergeParams:params eventName:@"ping" eventCategory:@"session"];
  
  XCTAssertTrue([userParams[@"client"] isEqualToString:client],
                @"Strings are not equal but should be %@ %@", client, userParams[@"client"]);
  XCTAssertTrue([userParams[@"client_version"] isEqualToNumber:clientVersion],
                @"Numbers are not equal but should be %@ %@", clientVersion, userParams[@"client_version"]);
  XCTAssertTrue([userParams[@"platform"] isEqualToString:platform],
                @"Strings are not equal but should be %@ %@", platform, userParams[@"platform"]);
  XCTAssertTrue([userParams[@"content_id"] isEqualToNumber:contentId],
                @"Numbers are not equal but should be %@ %@", contentId, userParams[@"content_id"]);
  XCTAssertTrue([userParams[@"module"] isEqualToString:module],
                @"Strings are not equal but should be %@ %@", module, userParams[@"module"]);
  XCTAssertTrue([userParams[@"parameter1"] isEqualToString:parameter1],
                @"Strings are not equal but should be %@ %@", parameter1, userParams[@"parameter1"]);
  XCTAssertTrue([userParams[@"parameter2"] isEqualToString:parameter2],
                @"Strings are not equal but should be %@ %@", parameter2, userParams[@"parameter2"]);
  XCTAssertTrue([userParams[@"parameter3"] isEqualToString:parameter3],
                @"Strings are not equal but should be %@ %@", parameter3, userParams[@"parameter3"]);
  XCTAssertTrue([userParams[@"parameter4"] isEqualToString:parameter4],
                @"Strings are not equal but should be %@ %@", parameter4, userParams[@"parameter4"]);
  XCTAssertTrue([userParams[@"parameter5"] isEqualToString:parameter5],
                @"Strings are not equal but should be %@ %@", parameter5, userParams[@"parameter5"]);
  XCTAssertTrue([userParams[@"parameter6"] isEqualToString:parameter6],
                @"Strings are not equal but should be %@ %@", parameter6, userParams[@"parameter6"]);
  XCTAssertNil(userParams[@"email"], @"email should not be set");
  XCTAssertNil(userParams[@"locale"], @"locale should not be set");
  XCTAssertNil(userParams[@"add_referer"], @"add_referer should not be set");
  XCTAssertNil(userParams[@"add_placement"], @"add_placement should not be set");
  XCTAssertNil(userParams[@"latitude"], @"latitude should not be set");
  XCTAssertNil(userParams[@"longitude"], @"longitude should not be set");
  
  
  userParams = [self.sample mergeParams:params eventName:@"session_start" eventCategory:@"session"];
  
  XCTAssertTrue([userParams[@"email"] isEqualToString:email],
                @"Strings are not equal but should be %@ %@", email, userParams[@"email"]);
  XCTAssertTrue([userParams[@"locale"] isEqualToString:locale],
                @"Strings are not equal but should be %@ %@", locale, userParams[@"locale"]);
  XCTAssertTrue([userParams[@"add_referer"] isEqualToString:addReferer],
                @"Strings are not equal but should be %@ %@", addReferer, userParams[@"add_referer"]);
  XCTAssertTrue([userParams[@"add_placement"] isEqualToString:addPlacement],
                @"Strings are not equal but should be %@ %@", addPlacement, userParams[@"add_placement"]);
  XCTAssertTrue([userParams[@"latitude"] isEqualToNumber:latitude],
                @"Strings are not equal but should be %@ %@", latitude, userParams[@"latitude"]);
  XCTAssertTrue([userParams[@"longitude"] isEqualToNumber:longitude],
                @"Strings are not equal but should be %@ %@", longitude, userParams[@"longitude"]);
}


- (void)testAddKeyValueTo
{
  NSMutableDictionary *keyValue = [NSMutableDictionary new];
  [self.sample addKey:nil value:nil to:keyValue];
  XCTAssertEqual([keyValue count], 0, @"Dict should be empty");
  
  keyValue = [NSMutableDictionary new];
  [self.sample addKey:@"testkey" value:nil to:keyValue];
  XCTAssertEqual([keyValue count], 0, @"Dict should be empty");
  
  keyValue = [NSMutableDictionary new];
  [self.sample addKey:nil value:@"testValue" to:keyValue];
  XCTAssertEqual([keyValue count], 0, @"Dict should be empty");
  
  keyValue = [NSMutableDictionary new];
  [self.sample addKey:@"testkey" value:@"testValue" to:keyValue];
  XCTAssertTrue([keyValue[@"testkey"] isEqualToString:@"testValue"],
                @"Key %@ does not return value %@", @"testKey", @"testValue");
}

- (void)testRandomToken
{
  XCTAssertEqual([[self.sample randomToken:4] length], 4, @"Token should have a length of 4");
  XCTAssertEqual([[self.sample randomToken:5] length], 6, @"Token should have a length of 6");
  XCTAssertEqual([[self.sample randomToken:6] length], 7, @"Token should have a length of 7");
  XCTAssertEqual([[self.sample randomToken:7] length], 8, @"Token should have a length of 8");
  XCTAssertEqual([[self.sample randomToken:8] length], 9, @"Token should have a length of 9");
  XCTAssertEqual([[self.sample randomToken:9] length], 11, @"Token should have a length of 11");
  
  XCTAssertEqual([[self.sample randomToken:12] characterAtIndex:4], '-', @"The fourth character should be a -");
}


@end