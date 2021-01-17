#import "ModuleSlot.h"

@interface ModuleLayout : NSObject{
	NSMutableArray<NSMutableArray<ModuleSlot*>*> *layout;
	NSMutableDictionary<NSString*, ModuleSlot*> *slotForModuleID;
}

@property(readonly) NSMutableArray<Module*> *modules;
@property(readonly) CGSize size;

-(instancetype)initWithSize:(CGSize)size;

-(CGRect)boundsForModule:(Module*)module;
-(Module*)moduleForPosition:(CGPoint)position;

-(BOOL)expandRowCount:(int)rows;
-(BOOL)expandColumnCount:(int)columns;
-(BOOL)expandSize:(CGSize)size;
-(BOOL)addModule:(Module*)module atLocation:(CGPoint)location;
@end