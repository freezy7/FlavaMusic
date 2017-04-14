//
//  BPNSStringAdditions.h
//  VGEUtil
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (vge)

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString *md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString *sha1Hash;

/**
 AES解密
 */
- (NSString *)aesDecryptBase64StringWithKeyString:(NSString*)keyString;

/**
 AES加密
 */
- (NSString *)aesEncryptBase64StringWithKeyString:(NSString*)keyString separateLines:(BOOL)separateLines;

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Returns a URL Encoded String
 */
- (NSString *)urlEncoded;

/**
 * Returns a URL query string. String after "?".
 */
- (NSString *)getUrlQueryString;

/**
 * Find a specific parameter from the url
 * key:e.g. "access_token="
 */
- (NSString *)getUrlParamValueForkey:(NSString *)key;

/**
 * Generate a url by combining the base url and parameters
 * httpMethod is GET by default
 */
- (NSURL *)serializeURLWithParams:(NSDictionary*)params;

/**
 * Generate a url by combining the base url and parameters
 */
- (NSURL *)serializeURLWithParams:(NSDictionary *)params httpMethod:(NSString *)httpMethod;


- (BOOL)validateWithRegex:(NSString *)regex;

@end
