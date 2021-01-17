#import "ModuleSlot.h"
#import "Mooncake.h"

@implementation ModuleSlot
+(instancetype)null{
	static ModuleSlot *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ModuleSlot alloc] init];
    });

    return sharedInstance;
}

-(instancetype)init{
	self = [super init];

	self->_size = CGSizeMake(1, 1);
	self.uniqueIdentifier = [Mooncake.sharedInstance generateUniqueIdentifier];

	return self;
}

-(instancetype)initWithModule:(Module*)module{
	self = [self init];

	self.module = module;

	return self;
}

-(void)setModule:(Module*)module{
	self->_module = module;
	/*self->_size = [module.class getDimensions];
	self->_bounds = CGRectMake(self.location.x, self.location.y, [module.class getDimensions].width, [module.class getDimensions].height);*/
	self->_size = [module.class getShapeSize];
	self->_bounds = CGRectMake(self.location.x, self.location.y, [module.class getShapeSize].width, [module.class getShapeSize].height);
}

-(void)setLocation:(CGPoint)location{
	self->_location = location;
	//self->_bounds = CGRectMake(self.location.x, self.location.y, self.module ? [self.module.class getDimensions].width : 1, self.module ? [self.module.class getDimensions].height : 1);
	self->_bounds = CGRectMake(self.location.x, self.location.y, self.module ? [self.module.class getShapeSize].width : 1, self.module ? [self.module.class getShapeSize].height : 1);
}
@end