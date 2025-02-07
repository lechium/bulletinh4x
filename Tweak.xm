#import <UIKit/UIKit.h>

@interface PBDialogContext : NSObject 
@property (nonatomic,readonly) id provider;              //@synthesize provider=_provider - In the implementation block
@property (nonatomic,readonly) NSString * identifier;                               //@synthesize identifier=_identifier - In the implementation block
+(id)contextWithViewController:(id)arg1 ;
+(id)contextWithViewService:(id)arg1 ;
+(id)contextWithViewServiceName:(id)arg1 className:(id)arg2 ;
-(void)_invalidate;
-(NSString *)identifier;
-(id)provider;
-(id)initWithIdentifier:(id)arg1 provider:(id)arg2 ;

@end

@interface PBSoftwareUpdateService : NSObject
+(id)sharedInstance;
-(void)_showOSUpdateUpToDateDialog:(BOOL)arg1;
@end

@interface PBCriticalAlertManager : NSObject 
+(id)sharedInstance;
-(id)overlayController;
-(void)presentAlertForKind:(long long)arg1 ;
-(void)dismissAlertForKind:(long long)arg1 ;
@end

@interface PBDialogManager : NSObject 
+(id)sharedInstance;
-(NSMutableDictionary *)identifiersToContexts;
-(NSMutableArray *)hiddenDialogAssertions;
-(void)overlayController:(id)arg1 willPresentSession:(id)arg2 ;
-(void)overlayController:(id)arg1 didPresentSession:(id)arg2 ;
-(void)overlayController:(id)arg1 willDismissSession:(id)arg2 withContext:(id)arg3 ;
-(void)overlayController:(id)arg1 didDismissSession:(id)arg2 ;
-(void)overlayController:(id)arg1 didCancelSession:(id)arg2 withContext:(id)arg3 ;
-(id)overlayController;
-(void)presentDialogWithContext:(id)arg1 options:(id)arg2 completion:(id)arg3 ;
-(void)dismissDialogWithContext:(id)arg1 options:(id)arg2 completion:(id)arg3 ;
-(BOOL)dismissActiveDialogAnimated:(BOOL)arg1 ;
-(void)dismissDialogWithContext:(id)arg1 options:(id)arg2 animated:(BOOL)arg3 completion:(id)arg4 ;
-(void)_setNotifyStateThatPineBoardIsShowingAnAlert:(BOOL)arg1 ;
-(BOOL)dismissActiveDialog;
@end

@interface PBUserNotificationViewControllerAlert: UIViewController
-(id)initWithTitle:(id)arg1 text:(id)arg2;
-(void)addButtonWithTitle:(id)arg1 type:(in)arg2 handler:(id)handler;
@end

@interface PBContentPresentingContainmentViewController: UIViewController

@property (nonatomic,readonly) BOOL allowsInteraction;
@property (assign,nonatomic) BOOL acceptsEventFocus;
@property (nonatomic,readonly) UIViewController * childViewController;
@property (nonatomic,readonly) BOOL expectsEventForwarding;
@property (assign,nonatomic) id contentDelegate;
@property (getter=isInterruptible,nonatomic,readonly) BOOL interruptible;
-(id)initWithChildViewController:(id)arg1 allowsInteraction:(BOOL)arg2 expectsEventForwarding:(BOOL)arg3;
-(void)presentContentAnimated:(BOOL)arg1 clientOptions:(id)arg2 withCompletion:(void(^)(void))arg3 ;
-(void)dismissContentAnimated:(BOOL)arg1 clientOptions:(id)arg2 withCompletion:(void(^)(void))arg3 ;

@end

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

@interface PineBoard: UIApplication

- (id)bulletinService;

@end

@interface PBApplication : FBSystemApp

- (id)bulletinService;

@end

@interface PBSBulletin: NSObject

@property (nonatomic, strong) id message;
@property (nonatomic, strong) id serviceIdentifier;
@property (nonatomic, strong) id viewControllerClassName;

@end
/*
%hook PBDialogManager

-(void)overlayController:(id)arg1 willPresentSession:(id)arg2  { %log; %orig; }
-(void)overlayController:(id)arg1 didPresentSession:(id)arg2  { %log; %orig; }
-(void)overlayController:(id)arg1 willDismissSession:(id)arg2 withContext:(id)arg3  { %log; %orig; }
-(void)overlayController:(id)arg1 didDismissSession:(id)arg2  { %log; %orig; }
-(void)overlayController:(id)arg1 didCancelSession:(id)arg2 withContext:(id)arg3  { %log; %orig; }
//-(id)overlayController  { %log; return %orig; }
-(void)presentDialogWithContext:(id)arg1 options:(id)arg2 completion:(id)arg3  { %log; %orig; }
-(void)dismissDialogWithContext:(id)arg1 options:(id)arg2 completion:(id)arg3   { %log; %orig; }
-(BOOL)dismissActiveDialogAnimated:(BOOL)arg1  { %log; return %orig; }
-(void)dismissDialogWithContext:(id)arg1 options:(id)arg2 animated:(BOOL)arg3 completion:(id)a  { %log; %orig; }
-(void)_registerDialogHiddenAssertion:(id)arg1 { %log; %orig; }
-(void)_deregisterDialogHiddenAssertion:(id)arg1  { %log; %orig; }
%end

%hook PBUserNotificationViewControllerAlert

-(id)initWithTitle:(id)arg1 text:(id)arg2 { %log; return %orig; }
-(void)addButtonWithTitle:(id)arg1 type:(float)arg2 handler:(id)handler { %log; %orig; }

%end

%hook PBContentPresentingContainmentViewController

-(id)initWithChildViewController:(id)arg1 allowsInteraction:(BOOL)arg2 expectsEventForwarding:(BOOL)arg3 { %log; return %orig; }
-(void)presentContentAnimated:(BOOL)arg1 clientOptions:(id)arg2 withCompletion:(id)arg3 { %log;  %orig; }
-(void)dismissContentAnimated:(BOOL)arg1 clientOptions:(id)arg2 withCompletion:(id)arg3 { %log;  %orig; }

%end
*/

//17+ PBApplication is changed to PineBoard theres probably a more elegant way to prevent all this duplicate code but, meh.
%hook PineBoard 


%new - (void)h4xDisplayAlert:(id)note {

      Class PBSoftwareUpdateService = NSClassFromString(@"PBSoftwareUpdateService");
      id bro = [PBSoftwareUpdateService sharedInstance];
      [bro _showOSUpdateUpToDateDialog:true];
}

%new - (void)h4xDisplayBulletin:(id)note {

    NSLog(@"[bh4x] h4xDisplayBulletin: %@", note);
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
    if (kCFCoreFoundationVersionNumber >= 1751.107){ //14
	NSString *infoPath = @"/Applications/TVSystemBulletinService.app/Info.plist";
	NSString *specialKey = @"UIViewServicePermittedViewControllerClasses";
	NSArray *filterArray = [NSDictionary dictionaryWithContentsOfFile:infoPath][specialKey];
	NSString *firstClass = [filterArray firstObject];
	//TODO: make this cache this result, just testing it out first
	[bull setViewControllerClassName:firstClass];
	//[bull setViewControllerClassName: @"TVSBInformationalBulletinViewController"];
    } else {
        [bull setViewControllerClassName: @"TVSBBulletinViewController"];
    }
    [bs presentBulletin: bull withCompletion: nil];

}

- (void)finishSystemAppLaunch {
    
    %log;
    %orig;
    NSDistributedNotificationCenter* notificationCenter = [NSDistributedNotificationCenter defaultCenter];
    //adding an additional observer that isnt ReProvision specific, eventually that notification name will get pruned out to go with one that makes more sense for the project.
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.matchstic.ReProvision/displayBulletin" object:nil];
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.nito.bulletinh4x/displayBulletin" object:nil];
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayAlert:) name:@"com.nito.bulletinh4x/bruh" object:nil];
}

%end

%hook PBApplication

/*

[1;36m[bh4x] [m[0;36mTweak.xm:91[m [0;30;46mDEBUG:[m -[<PBDialogManager: 0x28092fae0> presentDialogWithContext:<PBDialogContext: 0x280738cc0> options:{
    PBDialogOptionPresentForcedKey = 0;
    PBDialogOptionPresentWhileScreenSaverActiveKey = 0;
} completion:(null)]

*/

%new - (void)h4xDisplayAlert:(id)note {

      Class PBSoftwareUpdateService = NSClassFromString(@"PBSoftwareUpdateService");
      id bro = [PBSoftwareUpdateService sharedInstance];
      [bro _showOSUpdateUpToDateDialog:true];
}

%new - (void)h4xDisplayBulletin:(id)note {

    NSLog(@"[bh4x] h4xDisplayBulletin: %@", note);
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
    if (kCFCoreFoundationVersionNumber >= 1751.107){ //14
	NSString *infoPath = @"/Applications/TVSystemBulletinService.app/Info.plist";
	NSString *specialKey = @"UIViewServicePermittedViewControllerClasses";
	NSArray *filterArray = [NSDictionary dictionaryWithContentsOfFile:infoPath][specialKey];
	NSString *firstClass = [filterArray firstObject];
	//TODO: make this cache this result, just testing it out first
	[bull setViewControllerClassName:firstClass];
	//[bull setViewControllerClassName: @"TVSBInformationalBulletinViewController"];
    } else {
        [bull setViewControllerClassName: @"TVSBBulletinViewController"];
    }
    [bs presentBulletin: bull withCompletion: nil];

}

- (void)finishSystemAppLaunch {
    
    %log;
    %orig;
    NSDistributedNotificationCenter* notificationCenter = [NSDistributedNotificationCenter defaultCenter];
    //adding an additional observer that isnt ReProvision specific, eventually that notification name will get pruned out to go with one that makes more sense for the project.
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.matchstic.ReProvision/displayBulletin" object:nil];
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayBulletin:) name:@"com.nito.bulletinh4x/displayBulletin" object:nil];
    [notificationCenter addObserver:self  selector:@selector(h4xDisplayAlert:) name:@"com.nito.bulletinh4x/bruh" object:nil];
}

%end
