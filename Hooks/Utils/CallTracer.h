
@interface CallTracer: NSObject {
	NSMutableDictionary* args;
	NSString* className;
	NSString* methodName;
}

@property (retain) NSDictionary *args;
@property (retain) NSString *className;
@property (retain) NSString *methodName;
@property (retain) NSDictionary *argsAndReturnValue;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth;

// Plist objects are string, number, boolean, date, data, dictionary and array.
- (void) addArgFromPlistObject:(id) arg withKey:(NSString *)key;
- (void) addReturnValueFromPlistObject:(id) result;

- (NSData *) serializeArgsAndReturnValue;


@end
