//
//  FITAWebWidget.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FITAWebWidget;

NS_ASSUME_NONNULL_BEGIN

@protocol FITAWebWidgetHandler <NSObject>

/**
 * This method will be called when the widget container inside the WebView is successfully loaded
 * and is ready to accept commands.
 * @param widget The widget controller instance
 */
- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget;

/**
 * This method will be called when the widget container inside the WebView successfully loads
 * and is ready to accept commands.
 * @param widget The widget controller instance
 */
@optional
- (void)webWidgetInitialized:(FITAWebWidget *)widget;

/**
 * This method will be called when the widget inside the WebView fails to load or initialize for some reason.
 * @param widget The widget controller instance
 */
@optional
- (void)webWidgetDidFailLoading:(FITAWebWidget *)widget withError:(NSError *)error;

/**
 * This method will be called when the widget successfully loads the product info.
 * It means the product is supported and the widget should be able to provide
 * a size recommendation for it.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param details The details object
 */
@optional
- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(nullable NSDictionary *)details;

/**
 * This method will be called when the widget fails to load the product info or the product is not supported.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param details The details object
 */
@optional
- (void)webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(nullable NSDictionary *)details;

/**
 * This method will be called when the widget is successfully opened after the `open` method call.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 */
@optional
- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId;

/**
 * This method will be called when the user of the widget specifically requests closing of the widget by clicking on the close button.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param size The recommended size of the product, if there was a recommendation. `null` if there wasn't any recommendation.
 * @param details The details object.
 */
@optional
- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;

/**
 * This method will be called when the user of the widget specifically clicks on the add-to-cart inside the widget.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param size The size of the product that should be added to cart.
 * @param details The details object.
 */
@optional
- (void)webWidgetDidAddToCart:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;

/**
 * This method will be called after the `getRecommendation` call on the FITAWebWidget controller, when the widget has received and processed the size recommendation.
 * @param productId The ID of the product
 * @param size The recommended size of the product.
 * @param details The details object.
 */
@optional
- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;

@end

NS_ASSUME_NONNULL_END
