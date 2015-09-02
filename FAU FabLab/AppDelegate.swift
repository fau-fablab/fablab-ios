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

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let versionCheckModel = VersionCheckModel()
        versionCheckModel.checkVersion(PlatformType.APPLE, version: NSBundle.mainBundle().buildNumberAsInt!, onCompletion: {
            updateStatus in
            
            let title = "Update verfügbar"
            let message = "Neue Version : \(updateStatus.latestVersion!) \n Hinweis : \n \(updateStatus.updateMessage!)"
            
            switch (updateStatus.updateAvailable!){
                case .Required :
                    AlertView.showInfoView(title, message: "Update notwendig! \n\(message)")
                case .Optional :
                    AlertView.showInfoView(title, message: "Optionales Update \n\(message)")
                default:
                    return
            }
        })
        
        // Override point for customization after application launch.
        AutocompleteModel.sharedInstance.loadAutocompleteSuggestion();
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        // UI Customization
        // set Global TintColor
        self.window?.tintColor = UIColor.fabLabGreen()
        
        // NavBar
        var navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = UIColor.fabLabGreenNavBar()
        navBarAppearance.barTintColor = UIColor.fabLabBlue()
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // TableViewCell
        var selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.fabLabGreen().colorWithAlphaComponent(0.1)
        UITableViewCell.appearance().selectedBackgroundView = selectedBackground
        
        // TintColor for all Buttons
        UIBarButtonItem.appearance().tintColor = UIColor.fabLabGreen()
        
        return true
    }

    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        AutocompleteModel.sharedInstance.loadAutocompleteSuggestion();
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        PushToken.token = deviceTokenString
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification messge: [NSObject : AnyObject]) {
        println(messge);
        if let apn = messge["aps"] as? Dictionary<String, AnyObject>{
            if let cat = apn["category"] as? String{
                if(cat == TriggerPushType.DOOR_OPENS_NEXT_TIME.rawValue){
                    if let alertMsg = apn["alert"] as? String{
                        var alert = UIAlertController(title: "Fablab wurde geöffnet".localized, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

