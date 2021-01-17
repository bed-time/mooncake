#import "ModuleLayout.h"

@implementation ModuleLayout
-(instancetype)init{
	self = [super init];
	
	self->_size = CGSizeZero;
	layout = [[NSMutableArray alloc] init];
	slotForModuleID = [[NSMutableDictionary alloc] init];
	self->_modules = [[NSMutableArray alloc] init];

	//Load From Preferences

	return self;
}

-(instancetype)initWithSize:(CGSize)size{
	self = [self init];

	[self expandSize:size];

	return self;
}

-(CGRect)boundsForModule:(Module*)module{
	return slotForModuleID[module.uniqueIdentifier.UUIDString].bounds;
}

-(Module*)moduleForPosition:(CGPoint)position{
	if(position.y < layout.count && position.x < layout[(int)position.y].count && layout[(int)position.y][(int)position.x] != ModuleSlot.null) return layout[(int)position.y][(int)position.x].module;
	else return NULL;
}

-(BOOL)expandRowCount:(int)rows{
	return [self expandSize:CGSizeMake(self.size.width, rows)];
}

-(BOOL)expandColumnCount:(int)columns{
	return [self expandSize:CGSizeMake(columns, self.size.height)];
}

-(BOOL)expandSize:(CGSize)size{
	if(size.width < self.size.width || size.height < self.size.height) return false;

	while(layout.count < size.height) [layout addObject:[[NSMutableArray alloc] init]];

	for(NSMutableArray<ModuleSlot*> *row in layout){
		while(row.count < size.width) [row addObject:ModuleSlot.null];
	}

	self->_size = size;

	return true;
}

-(BOOL)addModule:(Module*)module atLocation:(CGPoint)location{
	if([self.modules containsObject:module]) return false;

	if(location.x < 0 || location.y < 0 || location.x + [module.class getShapeSize].width > self.size.width || location.y + [module.class getShapeSize].height > self.size.height) return false;

	NSArray<NSArray<NSNumber*>*> *shape = [module.class getPaddedAndTrimmedShape];
	
	NSMutableArray<NSValue*> *locations = [[NSMutableArray alloc] init];
	for(int x = location.x; x < location.x + [module.class getShapeSize].width; x++){
		for(int y = location.y; y < location.y + [module.class getShapeSize].height; y++){
			if(![shape[y - (int)location.y][x - (int)location.x] boolValue]) continue;

			if([self moduleForPosition:CGPointMake(x, y)]) return false;
			CGPoint point = CGPointMake(x, y);
			[locations addObject:[NSValue valueWithBytes:&point objCType:@encode(CGPoint)]];
		}
	}

	ModuleSlot *slot = [[ModuleSlot alloc] initWithModule:module];
	slot.location = location;
	slot.locations = locations;
	[self.modules addObject:module];
	slotForModuleID[module.uniqueIdentifier.UUIDString] = slot;

	for(NSValue *val in locations){
		CGPoint location;
		[val getValue:&location];

		layout[(int)location.y][(int)location.x] = slot;
	}

	return true;
}
@end