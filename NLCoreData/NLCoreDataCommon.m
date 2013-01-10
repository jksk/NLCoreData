//
//  NLCoreDataCommon.c
//  NLCoreDataExample
//
//  Created by Jesper Skrufve on 30/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NLCoreDataCommon.h"

const struct NLCoreDataExceptionsStruct NLCoreDataExceptions = {
	.predicate			= @"Predicate Exception",
	.count				= @"Count Exception",
	.parameter			= @"Parameter Exception",
	.merge				= @"Merge Exception",
	.fileExist			= @"File does not exist",
	.fileCopy			= @"Could not copy file",
	.encryption			= @"Encryption Exception",
	.persistentStore	= @"Persistent Store Exception",
	.permanentID		= @"Obtain Permanent ID Exception"
};
