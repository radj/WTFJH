#import <UIKit/UIApplication.h>
#import <UIKit/UIPasteboard.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <Security/SecItem.h>

@interface PlistObjectConverter: NSObject {

}

// Plist objects are string, number, boolean, date, data, dictionary and array.
// We need to convert anything that's not a plist object to a dictionnary so we can store it.
+ (NSString *) getSerializedNilValue;
+ (id) autoConvertNil: (id) pointer;
+ (NSDictionary *) convertURL:(NSURL *)aURL;
+ (NSDictionary *) convertNSURLRequest:(NSURLRequest *)request;
+ (NSDictionary *) convertNSURLResponse:(NSURLResponse *)response;
+ (NSDictionary *) convertNSCachedURLResponse:(NSCachedURLResponse *)response;
+ (NSDictionary *) convertNSURLAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
+ (NSDictionary *) convertNSURLProtectionSpace:(NSURLProtectionSpace *)pSpace;
+ (NSDictionary *) convertNSURLCredential: (NSURLCredential*) credential;
+ (NSDictionary *) convertNSHTTPCookie: (NSHTTPCookie*) cookie;
+ (NSDictionary *) convertUIPasteboard: (UIPasteboard*) pasteboard;
+ (NSArray *) convertDelegate: (id)delegate followingProtocol: (NSString*)protocol;
+ (NSDictionary *) convertNSError:(NSError *)error;
+ (NSDictionary *) convertNSURLSessionTask:(id)task;
+ (NSDictionary *) convertNSNetService:(NSNetService *)service;
+ (NSDictionary *) convertURLSessionConfiguration:(NSURLSessionConfiguration *)USC;

// Security framework objects
// TODO : Split PlistObjectConverter in multiple files
//+ (id) convertSecItemResult: (CFTypeRef*) result withQuery: (CFDictionaryRef) query;
+ (NSDictionary *) convertSecItemAttributesDict: (CFDictionaryRef) attributes;
+ (NSDictionary *) convertSecCertificateRef: (SecCertificateRef) certificate;
+ (NSDictionary *) convertSecTrustRef:(SecTrustRef) trust;
+ (NSDictionary *) convertSecIdentityRef: (SecIdentityRef) identity;
+ (NSDictionary *) convertSecKeyRef:(SecKeyRef) key;

+ (NSData *) convertCBuffer:(const void *) buffer withLength: (size_t) length;
@end
