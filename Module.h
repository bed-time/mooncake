#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Module : UIView
@property NSUUID *uniqueIdentifier;

//Private Functions (DON'T USE)
+(NSArray<NSArray<NSNumber*>*>*)getPaddedAndTrimmedShape;
+(CGSize)getShapeSize;

//Utility Functions (USE, BUT DON'T OVERRIDE)
-(BOOL)darkmodeEnabled;

//Functions to Override
+(NSArray<NSArray<NSNumber*>*>*)getShape;

-(void)load;
-(void)loadInBackground;

-(void)willAppear;
-(void)didAppear;
-(void)willDisappear;
-(void)didDisappear;
@end