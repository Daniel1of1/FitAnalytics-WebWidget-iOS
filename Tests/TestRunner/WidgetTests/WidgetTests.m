//
//  WidgetTests.m
//  WidgetTests
//
//  Created by FitAnalytics on 14/06/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WidgetTestCase.h"

@interface WidgetTests : WidgetTestCase
@end

@implementation WidgetTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWidgetContainerLoad {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
        NSLog(@"widget load");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testJavascriptEval {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
        return [self->widget evaluateJavaScriptAsync:@"String(1 + 1)"];
    })
    .then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"2");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testDriverInstall {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(){
        return [self->widget evaluateJavaScriptAsync:@"JSON.stringify(window.__driver)"];
    }).then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"{}");
        return [self->widget evaluateJavaScriptAsync:@"JSON.stringify(!!window.__widgetManager)"];
    }).then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"true", @"widget manager not present");
        return [self->widget testHasManager];
    }).then(^(NSString *res){
        XCTAssertEqualObjects(res, @"true", @"widget manager not present");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetMessageCallback {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];
    
    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(){
        return [self->viewController sendProductLoadMessage:@"widgetpreview-upper-m" details:@{ @"test": @"test" }];
    }).then(^(NSArray *res) {
        NSLog(@"Response: %@", res);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetCreateWithSerial {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];
    
    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        NSLog(@"initialized %@", res);
        return [self->viewController widgetCreate:@"widgetpreview-upper-m" options:nil];
    }).then(^(NSArray *res) {
        NSLog(@"created %@", [res objectAtIndex:0]);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetCreateThenConfigureWithSerial {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];
    
    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        NSLog(@"initialized %@", res);
        return [self->viewController widgetCreate:nil options:nil];
    }).then(^(NSString *res) {
        return [self->viewController widgetReconfigure:@"widgetpreview-upper-m" options: @{
            @"shopCountry": @"US",
            @"shopLanguage": @"en",
            @"manufacturedSizes": @{
                @"S": @YES,
                @"M": @YES,
                @"L": @NO,
                @"XL": @YES
            },
            @"userId": @"ios-test-0001"
        }];
    }).then(^(NSArray *res) {
        NSLog(@"loaded %@", [res objectAtIndex:0]);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetCreateWithOptionsThenOpen {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        NSLog(@"driver %@", res);
        return [self->viewController widgetCreate:@"widgetpreview-upper-m" options:@{
           @"shopCountry": @"US",
           @"shopLanguage": @"en",
           @"manufacturedSizes": @{
               @"S": @YES,
               @"M": @YES,
               @"L": @NO,
               @"XL": @YES
           },
           @"userId": @"ios-test-0001"
        }];
    }).then(^(NSArray *res) {
        NSLog(@"create %@", res);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        return [self->viewController widgetOpen];
    }).then(^(NSArray *res) {
        NSLog(@"open %@", res);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetCreateThenOpenWithOptions {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        return [self->viewController widgetCreate:nil options:@{
            @"shopCountry": @"US",
            @"shopLanguage": @"en",
            @"userId": @"ios-test-0001"
        }];
    }).then(^(NSArray *res) {
        return [self->viewController widgetOpenWithOptions:@"widgetpreview-upper-m" options:@{
            @"manufacturedSizes": @{
                @"S": @YES,
                @"M": @YES,
                @"L": @NO,
                @"XL": @YES
            }
        }];
    }).then(^(NSArray *res) {
        NSLog(@"open %@", res);
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testWidgetMultipleReconfigures {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        return [self->viewController widgetCreate:nil options:@{
            @"shopCountry": @"US",
            @"shopLanguage": @"en",
        }];
    }).then(^(NSArray *res) {
        return [self->viewController widgetReconfigure:@"widgetpreview-upper-m" options:nil];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
        return [self->viewController widgetReconfigure:@"widgetpreview-upper-w" options:nil];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-w");
        // only change sizes for the current propduct
        return [self->viewController widgetReconfigure:nil options:@{
            @"manufacturedSizes": @{
                @"S": @YES,
                @"M": @YES,
                @"L": @NO,
                @"XL": @YES
            }
        }];
    }).then(^(NSArray *res) {
        XCTAssertNil(nil);
        return [self->viewController widgetReconfigure:@"widgetpreview-shoes-u" options:@{
            @"manufacturedSizes": [NSNull null]
        }];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-shoes-u");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

// Simulate a situation where the network is failing from the start
- (void)testWidgetLoadWithNetworkError {
    if (![self isNethooksConfigured]) {
        return;
    }
    

    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    // FIREWALL on
    [self makeRequestAsync:@"enable"]
    .then(^(){
        // TCP-RESET on
        return [self makeRequestAsync:@"block-reset/out/443"];
    }).then(^(){
         // status
         return [self makeRequestAsync:@"status"];
     }).then(^(NSString *res){
        NSLog(@"STATUS: %@", res);
        return [self->viewController widgetLoad];
    }).then(^(NSError *err) {
        NSLog(@"LOAD %@", err);
        XCTFail();
        [self makeRequestAsync:@"disable"];
        [expectation fulfill];
    }).catch(^(NSError *error) {
        // This should actually happen; the TCP reset should trigger immediate request failure
        NSLog(@"Error: %@", error);
        [self makeRequestAsync:@"disable"];
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        [self makeRequestAsync:@"disable"];
        XCTAssertNil(error);
    }];
}

// Simulate a situation where the network is working initially, but then stops working
// after the widget container is loaded
// Note: currently this one fails
- (void)testWidgetReconfigureWithNetworkError {
    if (![self isNethooksConfigured]) {
        return;
    }
    
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    // FIREWALL on
    [self->viewController widgetLoad]
    .then(^(){
        NSLog(@"LOAD");
        return [self->widget initializeDriver];
    }).then(^(NSString *res) {
        NSLog(@"INIT: %@", res);
        return [self->viewController widgetCreate:nil options:@{
            @"shopCountry": @"US",
            @"shopLanguage": @"en",
        }];
    }).then(^(){
        return [self makeRequestAsync:@"enable"];
    }).then(^(){
        // TCP-RESET on
        return [self makeRequestAsync:@"block-reset/out/443"];
    }).then(^(NSArray *res) {
        return [self->viewController widgetReconfigure:@"widgetpreview-upper-m" options:nil];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"widgetpreview-upper-m");
    }).then(^(){
        [self makeRequestAsync:@"disable"];
        [expectation fulfill];
    }).catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [self makeRequestAsync:@"disable"];
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        [self makeRequestAsync:@"disable"];
        XCTAssertNil(error);
    }];
}

@end
