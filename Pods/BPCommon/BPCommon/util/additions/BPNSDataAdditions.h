//
//  BPNSDataAdditions.h
//  VGEUtil
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (vge)

/**
 * Calculate the md5 hash of this data using CC_MD5.
 *
 * @return md5 hash of this data
 */
@property (nonatomic, readonly) NSString *md5Hash;

/**
 * Calculate the SHA1 hash of this data using CC_SHA1.
 *
 * @return SHA1 hash of this data
 */
@property (nonatomic, readonly) NSString *sha1Hash;

/**
 * Create an NSData from a base64 encoded representation
 * Padding '=' characters are optional. Whitespace is ignored.
 * @return the NSData object
 */
+ (id)dataWithBase64EncodedString:(NSString *)string;

/**
 * Marshal the data into a base64 encoded representation
 *
 * @return the base64 encoded string
 */
- (NSString *)base64Encoded;

#pragma mark - AES encode/decode

- (NSData *)aesEncodedWithKey:(NSString *)key;

- (NSData *)aesDecodedWithKey:(NSString *)key;

- (NSData *)aesDecodedWithKeyByECBMode:(NSString *)key;

- (NSData *)aesEncoded;

- (NSData *)aesDecoded;

+ (NSData *)compressData:(NSData *)uncompressedData;
+ (NSData *)decompressData:(NSData *)compressedData;

@end
