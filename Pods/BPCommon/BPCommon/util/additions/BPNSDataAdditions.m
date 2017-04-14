//
//  BPNSDataAdditions.m
//  VGEUtil
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPNSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>
#import "FBEncryptorAES.h"
#import <zlib.h>
#import "BPCoreUtil.h"

@implementation NSData (vge)

- (NSString*)md5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)sha1Hash {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], (CC_LONG)[self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

// base64 code found on http://www.cocoadev.com/index.pl?BaseSixtyFour
static const char encodingTable[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSData*)dataWithBase64EncodedString:(NSString *)string {
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoded {
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [self length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        // Encode the bytes in the buffer to four characters,
        // including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length
                                         encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

#define kAESDataIV  @"20120716eclicks"
#define kAESDataKey @"##3edceclicks&&"

- (NSData *)aesEncodedWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [kAESDataIV dataUsingEncoding:NSUTF8StringEncoding];
    return [FBEncryptorAES encryptData:self key:keyData iv:iv];
}

- (NSData *)aesDecodedWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [kAESDataIV dataUsingEncoding:NSUTF8StringEncoding];
    return [FBEncryptorAES decryptData:self key:keyData iv:iv];
}

- (NSData *)aesDecodedWithKeyByECBMode:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [kAESDataIV dataUsingEncoding:NSUTF8StringEncoding];
    return [FBEncryptorAES decryptDataByECBMode:self key:keyData iv:iv];
}

- (NSData *)aesEncoded
{
    return [self aesEncodedWithKey:kAESDataKey];
}

- (NSData *)aesDecoded
{
    return [self aesDecodedWithKey:kAESDataKey];
}

+ (NSData *)compressData:(NSData *)uncompressedData
{
    if (!uncompressedData || [uncompressedData length] == 0)  {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = (uInt)[uncompressedData length];
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }

    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + [BPCoreUtil compressBufferExtra]];
    
    int deflateStatus;
    do
    {
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        zlibStreamStruct.avail_out = (uInt)((uLong)[compressedData length] - zlibStreamStruct.total_out);
        
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
    } while ( deflateStatus == Z_OK );
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        return nil;
    }

    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
    
}

+ (NSData *)decompressData:(NSData *)compressedData
{
    z_stream zStream;
    zStream.zalloc = Z_NULL ;
    zStream.zfree = Z_NULL ;
    zStream.opaque = Z_NULL ;
    zStream.avail_in = 0 ;
    zStream.next_in = 0 ;
    
    int status = inflateInit2 (&zStream, ( 15 + 32 ));
    if (status != Z_OK ) {
        return nil ;
    }
    
    Bytef *bytes = ( Bytef *)[compressedData bytes];
    NSUInteger length = [compressedData length];
    NSUInteger halfLength = length/ 2 ;
    NSMutableData *uncompressedData = [NSMutableData dataWithLength :length+halfLength];
    
    zStream.next_in = bytes;
    zStream.avail_in = (unsigned int)length;
    zStream.avail_out = 0 ;

    NSInteger bytesProcessedAlready = zStream.total_out ;
    while (zStream. avail_in!= 0) {
        if (zStream. total_out - bytesProcessedAlready >= [uncompressedData length]) {
            [uncompressedData increaseLengthBy:halfLength];
        }
        
        zStream. next_out = (Bytef *)[uncompressedData mutableBytes] + zStream.total_out -bytesProcessedAlready;
        zStream. avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out -bytesProcessedAlready));

        status = inflate (&zStream, Z_NO_FLUSH );
        if (status == Z_STREAM_END ) {
            break ;
        } else if (status != Z_OK ) {
            return nil ;
        }
    }

    status = inflateEnd (&zStream);
    if (status != Z_OK ) {
        return nil ;
    }

    [uncompressedData setLength : zStream. total_out -bytesProcessedAlready];  // Set real length
    return uncompressedData;
}

@end
