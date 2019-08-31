#import <UIKit/UIApplication.h>

@interface NSDistributedNotificationCenter : NSNotificationCenter

+ (id)defaultCenter;
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;

@end

@interface FBSystemApp : UIApplication 
@end

@interface PBBulletinService: NSObject

- (void)presentBulletin:(id)arg1 withCompletion:(id)arg2;

@end

@interface PBApplication : FBSystemApp

- (id)bulletinService;

@end

@interface PBSBulletin: NSObject

@property (nonatomic, strong) id message;
@property (nonatomic, strong) id serviceIdentifier;
@property (nonatomic, strong) id viewControllerClassName;

@end

%hook PBApplication

%new - (void)h4xDisplayBulletin:(id)note {

    NSDictionary *userInfo = [note userInfo];
    NSString *title = userInfo[@"title"];
    NSString *message = userInfo[@"message"];
    NSInteger timeout = [userInfo[@"timeout"] integerValue];
    NSString *imageKey = nil;
    NSArray *allKeys = [userInfo allKeys];

    id imageData = nil; //could be NSString or NSData

    if ([allKeys containsObject:@"imageData"]){
        imageKey = @"PBSSystemBulletinImageDataKey";
        imageData = userInfo[@"imageData"];
    } else if ([allKeys containsObject:@"imageURL"]){
        imageKey = @"PBSSystemBulletinImageURLKey";
        imageData = userInfo[@"imageURL"];
    } else if ([allKeys containsObject:@"imageID"]){
        imageKey = @"PBSSystemBulletinImageIDKey";
        imageData = userInfo[@"imageID"];
    }

    PBBulletinService *bs = [self bulletinService];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"PBSSystemBulletinStyleKey"] = @0;
    dict[@"PBSSystemBulletinTimeoutKey"] = [NSNumber numberWithInt:timeout];
    if (message) dict[@"PBSSystemBulletinMessageKey"] = message;
    if (title) dict[@"PBSSystemBulletinTitleKey"] = title; 
    if (imageData) dict[imageKey] = imageData;
    id bull = [[NSClassFromString(@"PBSBulletin") alloc] init];
    [bull setMessage: dict];
    [bull setServiceIdentifier: @"com.apple.TVSystemBulletinService"];
    [bull setViewControllerClassName: @"TVSBBulletinViewController"];
    [bs presentBulletin: bull withCompletion: nil];

}

- (void)finishSystemAppLaunch {
    
    %log;
    %orig;
    NSDistributedNotificationCenter* notificationCenter = [NSDistributedNotificationCenter defaultCenter];
    //adding an additional observer that isnt ReProvision specific, eventually that notification name will get pruned out to go with one that makes more sense for the project.
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.matchstic.ReProvision/displayBulletin" object:nil];
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.nito.bulletinh4x/displayBulletin" object:nil];
}

%end
