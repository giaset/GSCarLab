//
//  AppDelegate.m
//
//  Created by  on 12-06-08.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>
#import "GSCodeRougeLabViewController.h"
#import <ResourceManager/ResourceManager.h>

@implementation AppDelegate

@synthesize window = _window;

- (id)init{
    self = [super init];
    
    [[CKStyleManager defaultManager]loadContentOfFileNamed:@"Stylesheet"];
    
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    
    [[CKConfiguration sharedInstance]setUsingARC:YES];
    
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    GSCodeRougeLabViewController* viewController = [[GSCodeRougeLabViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
