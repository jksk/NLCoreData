//
//  NLCoreDataCommon.h
//  NLCoreDataExample
//
//  Created by Jesper Skrufve on 30/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define SET_PREDICATE_WITH_VARIADIC_ARGS \
	NSPredicate* predicate = nil; \
	if ([predicateOrString isKindOfClass:[NSString class]]) { \
		va_list args; \
		va_start(args, predicateOrString); \
		predicate = [NSPredicate predicateWithFormat:predicateOrString arguments:args]; \
		va_end(args); \
	} \
	else if ([predicateOrString isKindOfClass:[NSPredicate class]]) \
		predicate = predicateOrString; \
	else if (predicateOrString) \
		[NSException raise:NLCoreDataExceptions.predicate format:@"invalid predicate: %@", predicateOrString];
#else
#define SET_PREDICATE_WITH_VARIADIC_ARGS \
	NSPredicate* predicate = nil; \
	if ([predicateOrString isKindOfClass:[NSString class]]) { \
		va_list args; \
		va_start(args, predicateOrString); \
		predicate = [NSPredicate predicateWithFormat:predicateOrString arguments:args]; \
		va_end(args); \
	} \
	else if ([predicateOrString isKindOfClass:[NSPredicate class]]) \
		predicate = predicateOrString;
#endif

extern const struct NLCoreDataExceptionsStruct
{
	__unsafe_unretained NSString* predicate;
	__unsafe_unretained NSString* count;
	__unsafe_unretained NSString* parameter;
	__unsafe_unretained NSString* merge;
	__unsafe_unretained NSString* fileExist;
	__unsafe_unretained NSString* fileCopy;
	__unsafe_unretained NSString* encryption;
	__unsafe_unretained NSString* persistentStore;
	__unsafe_unretained NSString* permanentID;
} NLCoreDataExceptions;
