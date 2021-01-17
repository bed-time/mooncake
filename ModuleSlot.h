#import <Foundation/Foundation.h>
#import "Module.h"

@interface ModuleSlot : NSObject
@property(class, readonly) ModuleSlot *null;

@property NSUUID *uniqueIdentifier;
@property(readonly, nonatomic) Module *module;
@property(nonatomic) CGPoint location;
@property NSArray<NSValue*> *locations;
@property(readonly, nonatomic) CGSize size;
@property(readonly) CGRect bounds;

-(instancetype)initWithModule:(Module*)module;
@end