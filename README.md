# bulletinh4x
Tweak to craft Bulletins for notifications on jailbroken tvOS


To use this library add the Dependency 'com.nito.bulletinh4x'

Inside your project you will need to add minimal headers for NSDistributedNotificationCenter

the following is sufficient, you can also put it in a separate header file if you would like.
```objective-c
@interface NSDistributedNotificationCenter : NSNotificationCenter

+ (id)defaultCenter;
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;

@end
```
From there you can call a notificaiton like the following ANYWHERE from your code to create a bulletin notification.
```objective-c
NSMutableDictionary *dict = [NSMutableDictionary new];
dict[@"message"] = @"Your Message";
dict[@"title"] = @"Your Title";
dict[@"timeout"] = @2;
UIImage *image = [UIImage imageNamed:@"notifIcon"];
NSData *imageData = UIImagePNGRepresentation(image);;
if (imageData){
    dict[@"imageData"] = imageData;
}

[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.nito.bulletinh4x/displayBulletin" object:nil userInfo:dict];
```

The following types are supported for images: URLs, IDs & raw data (illustrated above), I actually have yet to test the URL method, but assuming it just takes a URL in NSString format. 

The key to send to specific a URL is @"imageURL"
The key to specify an "ID" is "imageID" These ID's represent assets available on tvOS by default and include images like the remote, bluetooth, etc. The list of ID's i have discovered is listed below:
```objective-c
PBSSystemBulletinImageIDAlert
PBSSystemBulletinImageIDAudio
PBSSystemBulletinImageIDB39
PBSSystemBulletinImageIDBluetooth
PBSSystemBulletinImageIDController
PBSSystemBulletinImageIDKeyboard
PBSSystemBulletinImageIDMusic
PBSSystemBulletinImageIDPairing
PBSSystemBulletinImageIDPodcast
PBSSystemBulletinImageIDRemote
PBSSystemBulletinImageIDRemoteBatteryWarning
PBSSystemBulletinImageIDRemoteCharging
PBSSystemBulletinImageIDScreenSharing
PBSSystemBulletinImageIDTV
PBSSystemBulletinImageIDVolume
```


