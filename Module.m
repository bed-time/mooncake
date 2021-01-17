#import "Module.h"
#import "Mooncake.h"

@implementation Module
-(instancetype)init{
	self = [super init];

	self.uniqueIdentifier = [Mooncake.sharedInstance generateUniqueIdentifier];

	return self;
}

//Private Functions (DON'T USE)
+(NSArray<NSArray<NSNumber*>*>*)getPaddedAndTrimmedShape{
	NSArray<NSArray<NSNumber*>*> *base = [self getShape];
	NSMutableArray<NSMutableArray<NSNumber*>*> *clean = [[NSMutableArray alloc] init];

	int maxWidth = 0;
	for(int i = 0; i < base.count; i++){
		if(base[i].count > maxWidth) maxWidth = base[i].count;
	}

	for(int i = 0; i < base.count; i++){
		NSMutableArray *padded = base[i].mutableCopy;
		while(padded.count < maxWidth) [padded addObject:@0];

		[clean addObject:padded];
	}

	BOOL isEmpty;
	do{
		if(clean.count <= 0) break;

		isEmpty = true;
		for(NSNumber *val in clean.firstObject) if([val boolValue]){
			isEmpty = false;
			break;
		}

		if(isEmpty) [clean removeObjectAtIndex:0];
	} while(isEmpty);

	do{
		if(clean.count <= 0) break;

		isEmpty = true;
		for(NSNumber *val in clean.lastObject) if([val boolValue]){
			isEmpty = false;
			break;
		}

		if(isEmpty) [clean removeLastObject];
	} while(isEmpty);

	do{
		if(maxWidth <= 0) break;

		isEmpty = true;
		for(NSMutableArray<NSNumber*> *val in clean) if([val.firstObject boolValue]){
			isEmpty = false;
			break;
		}

		if(isEmpty) for(NSMutableArray<NSNumber*> *val in clean) [val removeObjectAtIndex:0];
	} while(isEmpty);

	do{
		if(maxWidth <= 0) break;

		isEmpty = true;
		for(NSMutableArray<NSNumber*> *val in clean) if([val.lastObject boolValue]){
			isEmpty = false;
			break;
		}

		if(isEmpty) for(NSMutableArray<NSNumber*> *val in clean) [val removeLastObject];
	} while(isEmpty);

	return clean;
}

+(CGSize)getShapeSize{
	NSArray<NSArray<NSNumber*>*> *shape = [self getPaddedAndTrimmedShape];
	return CGSizeMake(shape.count > 0 ? shape[0].count : 0, shape.count);
}

//Utility Functions (USE, BUT DON'T OVERRIDE)
-(BOOL)darkmodeEnabled{
	return self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
}

//Functions to Override
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1]
	];
}

-(void)willAppear{}
-(void)didAppear{}
-(void)willDisappear{}
-(void)didDisappear{}
@end