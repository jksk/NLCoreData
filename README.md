NLCoreData is meant as a drop-in wrapper for most of your Core Data needs on iOS (untested on OS X).
Requires ARC. Requres iOS 5+.

## Goals
* Write less code.
* Make code more readable.
* More compile-time checks.

You access convenience methods for insertion, deletion, counting and fetching through class
and instance methods on your NSManagedObject subclasses.

You no longer access objects by typing an NSString with an entity name, instead you use the entity class.
Instead of @"Person", use [Person class]. This provides a compile-time typo check.


## NLCoreData is not for you if
* you need more than one persistent store.
* you don't want to subclass NSManagedObject


## Initialization
If your Core Data model is named to something other than the name of your main bundle, you need to set the model name
before first use. Typically in application:didFinishLaunchingWithOptions:.

	[[NLCoreData shared] setModelName:@"MyCoreDataModel"];

You have to option to supply a pre-seeded sqlite database. First, check so that Core Data isn't initialized yet.
Typically in application:didFinishLaunchingWithOptions: on your first run:

	if ([[NLCoreData shared] storeExists] == NO)
		[[NLCoreData shared] usePreSeededFile:pathToMyFile];


## Contexts
NLCoreData provides three lazily loaded NSManagedObjectContexts. For the main (UI) thread, use:

	NSManagedObjectContext* context = [NSManagedObjectContext mainContext];

If you're doing some heavy lifting, and don't want to block the main thread, use:

	NSManagedObjectContext* context = [NSManagedObjectContext backgroundContext];

Sometimes you may want to skip context synchronicity and simply change stored values. You can access the context for the persistent store with:

	NSManagedObjectContext* context = [NSManagedObjectContext storeContext];

To save a context:

	BOOL success = [context save];

This doesn't persist values outside of their own context. To ensure an object is persisted, use:

	BOOL success = [context saveNested];

or:

	[context saveNestedAsynchronous];
	
The backgroundContext and the storeContext are run on private dispatch queues, so any operations on them should be wrapped in a performBlock:

	NSManagedObjectContext* context = [NSManagedObjectContext backgroundContext];
	[context performBlock:^{
		
		// insert or fetch new data here.
	}];
	
As always, never pass NSManagedObjects between contexts, use the objectID's instead.

## Methods
If you want to fetch all Person objects in the main context:

	NSArray* results = [Person fetchWithPredicate:nil];

If you want to delete all Person objects and persist the change:

	[Person deleteWithRequest:nil context:[NSManagedObjectContext storeContext]];

If you want to count all Person objects that match the predicate myPredicate (in the main context):

	NSUInteger count = [Person countWithPredicate:myPredicate];


## Fetching
You can fetch either an array of objects or a single object. If you want all Person objects in the main context:

	NSArray* results = [Person fetchWithPredicate:nil];

If you want a single object in the shared context:

	Person* person = [Person fetchSingleWithPredicate:nil];

The single fetch can be useful if there is only one object of that type, or if you provide a predicate that you're certain only matches one object.

In some cases, you want to return a single object, or create one if it doesn't exist:

	Person* person = [Person fetchOrInsertSingleWithPredicate:nil];


## Fetch Requests
If you need to create an NSFetchRequest (e.g., for use in an NSFetchedResultsController),
you can do that with a provided convenience method:

	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntity:[Person class]];

The somewhat cumbersome setSortDescriptors: is augmented by sortByKey:ascending:
Though setSortDescriptors: is still available, don't use both on the same NSFetchRequest.

	[request sortByKey:@"myKeyPath" ascending:NO];
	[request sortByKey:@"mySecondaryKeyPath" ascending:YES];

You can also set a predicate inline:

	[request setPredicateOrString:@"myAttribute == YES"];

## Notes
* Make sure you subclass all your Core Data entities, and that the subclasses are named for their entity
	(i.e., if you have an entity named Person, you need a subclass named Person).
* I strongly recommend using mogenerator. It's quite excellent. Get it via homebrew or at http://rentzsch.github.com/mogenerator

## Setup
1. Add the NLCoreData folder to your project.

2. import "NLCoreData.h" where you need it (in prefix.pch for easy access).

3. Optionally, set modelName to what your model is named: [[NLCoreData shared] setModelName:@"MyModel"];

Step 3 is skippable if your model name is the same as your bundle/app name.
