#import "BatteryModule.h"

@implementation BatteryModule
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1, @1]
	];
}

-(void)load{
	UIDevice.currentDevice.batteryMonitoringEnabled = true;
}

-(void)willAppear{
	//Get Battery Percent
}
@end