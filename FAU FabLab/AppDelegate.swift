//
//  AppDelegate.swift
//  FAU FabLab
//
//  Copyright (c) 2015 FAU MAD FabLab. All rights reserved.
//
import UIKit
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class var APP_VERSION: Int{
        return 2
    }

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Check if there is a new version available
        let versionCheckModel = VersionCheckModel()
        versionCheckModel.checkVersion()
        
        //create and register notifications
        let type: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound];
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        // UI Customization
        // set Global TintColor
        self.window?.tintColor = UIColor.fabLabGreen()
        // TintColor for all Buttons
        UIBarButtonItem.appearance().tintColor = UIColor.fabLabGreen()

        // NavBar appearance
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = UIColor.fabLabGreenNavBar()
        navBarAppearance.barTintColor = UIColor.fabLabBlue()
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // TableViewCell appearance
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.fabLabGreen().colorWithAlphaComponent(0.1)
        UITableViewCell.appearance().selectedBackgroundView = selectedBackground
        
        return true
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
    
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        PushToken.token = deviceTokenString
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification messge: [NSObject : AnyObject]) {

        if let apn = messge["aps"] as? Dictionary<String, AnyObject>{
            if let cat = apn["category"] as? String{
                if(cat == TriggerPushType.DOOR_OPENS_NEXT_TIME.rawValue){
                    if let alertMsg = apn["alert"] as? String{
                        let alert = UIAlertController(title: "Fablab wurde geöffnet".localized, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Coole Sache".localized, style: UIAlertActionStyle.Default, handler: nil))
                        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //Fetch autocompletions for product search
        SearchHelpModel.sharedInstance.fetchAutocompleteEntries();
        //Fetch categories for product serach
        CategoryModel.sharedInstance.fetchCategories { (error) -> Void in }
        //Load the product map
        ProductLocationModel.sharedInstance.loadProductMap({ result in })
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

