//
//  AppDelegate.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/20/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Stripe
import SDWebImage
import Firebase
import CoreData
import Alamofire
import UserNotifications
import FirebaseMessaging
import AVFoundation
import UserNotifications
import Firebase
import FirebaseInstanceID

//import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,GIDSignInDelegate, FIRMessagingDelegate{
 
    var window: UIWindow?
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
   
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let baseUrl:String      = "http://www.smarttecapps.com/foodiest/mobileapp_api/api"
    let ImagebaseUrl:String = "http://www.smarttecapps.com/foodiest/mobileapp_api/"
    let registerUser:String = "/registerUser"
    let loginUser:String = "/login"
    let addPaymentMethod:String = "/addPaymentMethod"
    let addDeliveryAddress:String = "/addDeliveryAddress"
    let getPaymentDetails:String = "/getPaymentDetails"
    let editUserProfile:String = "/editUserProfile"
    let verifyPhoneNo:String = "/verifyPhoneNo"
    let forgotPassword:String = "/forgotPassword"
    let changePassword:String = "/changePassword"
    let showRestaurants:String = "/showRestaurants"
    let getDeliveryAddresses:String = "/showDeliveryAddresses"
    let showRestaurantsMenu:String = "/showRestaurantsMenu"
    let showOrders:String = "/showOrders"
    let restaurantRatings:String = "/showRestaurantRatings"
    let placeOrder:String = "/placeOrder"
    let showRiderOrders:String = "/showRiderOrders"
    let updateRiderOrderStatus:String = "/updateRiderOrderStatus"
    let addUserLocation:String = "/addRiderLocation"
    let chat:String = "/chat"
    let getConversation:String = "/getConversation"
    let showMenuExtraItems:String = "/showMenuExtraItems"
    let showRiderTracking:String = "/showRiderTracking"
    let trackRiderStatus:String = "/trackRiderStatus"
    let showRiderOrdersBasedOnDate:String = "/showRiderOrdersBasedOnDate"
    let showRiderTimingBasedOnDate:String = "/showRiderTimingBasedOnDate"
    let addRiderTiming:String = "/addRiderTiming"
    let showOrderDetail:String = "/showOrderDetail"
    let deleteRiderTiming:String = "/deleteRiderTiming"
    let verifyCoupon:String = "/verifyCoupon"
    let addFavouriteRestaurant:String = "/addFavouriteRestaurant"
    let showFavouriteRestaurants:String = "/showFavouriteRestaurants"
    let showAppSliderImages:String = "/showAppSliderImages"
    let checkIn:String = "/checkIn"
    let showDeals:String = "/showDeals"
    let showDealBasedOnID:String = "/showDealBasedOnID"
    let showUserOnlineStatus:String = "/showUserOnlineStatus"
    let addRestaurantRating:String = "/addRestaurantRating"
    let showCountries:String = "/showCountries"
    let orderDeal:String = "/orderDeal"
    let showRestaurantDeals:String = "/showRestaurantDeals"
    let showOrdersBasedOnRestaurant:String = "/showOrdersBasedOnRestaurant"
    let updateRestaurantOrderStatus:String = "/updateRestaurantOrderStatus"
    let deletePaymentMethod:String = "/deletePaymentMethod"
    let deleteDeliveryAddress:String = "/deleteDeliveryAddress"
    let showRestaurantsAgainstSpeciality:String = "/showRestaurantsAgainstSpeciality"
    let showRestaurantsSpecialities:String = "/showRestaurantsSpecialities"
    let showRiderLocationAgainstOrder:String = "/showRiderLocationAgainstOrder"
    let updateRiderShiftStatus:String = "/updateRiderShiftStatus"
    let giveRatingsToRider:String = "/giveRatingsToRider"
    let showUpComingRiderShifts:String = "/showUpComingRiderShifts"
    let showRestaurantCompletedOrders:String = "/showRestaurantCompletedOrders"
    let showRiderRatings:String = "/showRiderRatings"
    let showRiderLocationAgainstOrderWithPusher:String = "/showRiderLocationAgainstOrderWithPusher"
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       //Thread.sleep(forTimeInterval: 2.0)
       
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.sharedManager().enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyAUywCFEGbnsB-1v-AH_wJ-GrTviuOLAQE")
        GMSServices.provideAPIKey("AIzaSyAUywCFEGbnsB-1v-AH_wJ-GrTviuOLAQE")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_6pRNASCoBOKtIshFeQd4XMUh"
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FIRApp.configure()

        UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey:"udid")
        if(UserDefaults.standard.string(forKey:"email") == nil  || UserDefaults.standard.string(forKey:"email") == ""){

            UserDefaults.standard.set("NO", forKey:"isLogin")

            UserDefaults.standard.set("", forKey:"email")
            UserDefaults.standard.set("", forKey:"pwd")
            UserDefaults.standard.set("", forKey:"uid")
            UserDefaults.standard.set("", forKey:"first_name")
            UserDefaults.standard.set("", forKey:"last_name")
            UserDefaults.standard.set("", forKey:"contactNO")
            UserDefaults.standard.set("", forKey:"aid")
            UserDefaults.standard.set("", forKey:"UserType")
            if(UserDefaults.standard.string(forKey: "location") == nil || UserDefaults.standard.string(forKey: "location") == "" ){



                if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){

                let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                let tabViewController:YourLocationViewController = (storyboard.instantiateViewController(withIdentifier: "YourLocationViewController") as? YourLocationViewController)!
                    UserDefaults.standard.set("", forKey:"center")
                    UserDefaults.standard.set("", forKey:"location")


                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                }else{

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController:YourLocationViewController = (storyboard.instantiateViewController(withIdentifier: "YourLocationViewController") as? YourLocationViewController)!
                    UserDefaults.standard.set("", forKey:"center")
                    UserDefaults.standard.set("", forKey:"location")


                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()

                }

            }else{
                if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!

                self.window?.rootViewController = tabViewController
                self.window?.makeKeyAndVisible()
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!

                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()

                }
            }
        }else{

            UserDefaults.standard.set("YES", forKey:"isLogin")
            if(UserDefaults.standard.string(forKey:"UserType") == "user"){
                if(UserDefaults.standard.string(forKey: "location") == nil){

                    if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){

                    let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                    let tabViewController:YourLocationViewController = (storyboard.instantiateViewController(withIdentifier: "YourLocationViewController") as? YourLocationViewController)!


                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabViewController:YourLocationViewController = (storyboard.instantiateViewController(withIdentifier: "YourLocationViewController") as? YourLocationViewController)!


                        self.window?.rootViewController = tabViewController
                        self.window?.makeKeyAndVisible()

                    }
                }else{
                    if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!

                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                    }else{


                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!

                        self.window?.rootViewController = tabViewController
                        self.window?.makeKeyAndVisible()

                    }
                }
            }else if(UserDefaults.standard.string(forKey:"UserType") == "rider"){
                if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID2") as? UITabBarController)!
                self.window?.rootViewController = tabViewController
                self.window?.makeKeyAndVisible()
                }else{

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID2") as? UITabBarController)!
                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                }

            }else{
                
                if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID3") as? UITabBarController)!
                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                }else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID3") as? UITabBarController)!
                    self.window?.rootViewController = tabViewController
                    self.window?.makeKeyAndVisible()
                }
                
                
            }
        
            
        }
      
         GIDSignIn.sharedInstance().clientID = "6481736747-mabu67j9eeb45ajkako4tds4b6l4etgr.apps.googleusercontent.com"
        // return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
        
    }
    
   
  
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//       let refreshedToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//
//        // Print it to console
//        print("APNs device token: \(refreshedToken)")
//        if(refreshedToken == nil){
//            UserDefaults.standard.set("", forKey:"DeviceToken")
//        }else{
//        UserDefaults.standard.set(refreshedToken, forKey:"DeviceToken")
//        }
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey:"DeviceToken")
        }else{
            
            UserDefaults.standard.set("", forKey:"DeviceToken")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground, received: \n \(notification.request.content)")
      print(notification.request.content.userInfo)
      
        let type  = notification.request.content.userInfo[AnyHashable("gcm.notification.type")] as? String
        //print(dic!)
       
        if(type == nil ){
            
        }else
        if(type == "Order has been successfully placed"){
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
        else
        if(type == "rider_review"){
            
            UserDefaults.standard.set(notification.request.content.userInfo[AnyHashable("gcm.notification.rider_user_id")] as! String, forKey:"notiRider")
            UserDefaults.standard.set(notification.request.content.userInfo[AnyHashable("gcm.notification.order_id")] as! String, forKey:"notiRiderOrderID")
            UserDefaults.standard.set(notification.request.content.userInfo[AnyHashable("gcm.notification.rider_name")] as! String, forKey:"notiRiderName")
            UserDefaults.standard.set("Yes", forKey:"RiderReview")
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: nil)
            
        }else if(type == "order_review"){
            StaticData.singleton.notiRestID = notification.request.content.userInfo[AnyHashable("gcm.notification.restaurant_id")] as? String
            UserDefaults.standard.set(StaticData.singleton.notiRestID!, forKey:"notiRest")
            UserDefaults.standard.set(notification.request.content.userInfo[AnyHashable("gcm.notification.restaurant_name")] as! String, forKey:"notiName")
            UserDefaults.standard.set(notification.request.content.userInfo[AnyHashable("gcm.notification.img")] as! String , forKey:"notiImg")
            UserDefaults.standard.set("Yes", forKey:"isReview")
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            
        }
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle tapped push from background, received: \n \(response.notification.request.content)")
     
        
       
        let type  = response.notification.request.content.userInfo[AnyHashable("gcm.notification.type")] as? String
      
        if(type == nil){
            
        }else
        if(type == "Order has been successfully placed"){
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
        else
            if(type == "rider_review"){
                
                UserDefaults.standard.set(response.notification.request.content.userInfo[AnyHashable("gcm.notification.rider_user_id")] as! String, forKey:"notiRider")
                UserDefaults.standard.set(response.notification.request.content.userInfo[AnyHashable("gcm.notification.order_id")] as! String, forKey:"notiRiderOrderID")
                UserDefaults.standard.set(response.notification.request.content.userInfo[AnyHashable("gcm.notification.rider_name")] as! String, forKey:"notiRiderName")
                UserDefaults.standard.set("Yes", forKey:"RiderReview")
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: nil)
                
            }else if(type == "order_review"){
                StaticData.singleton.notiRestID = response.notification.request.content.userInfo[AnyHashable("gcm.notification.restaurant_id")] as? String
                UserDefaults.standard.set(StaticData.singleton.notiRestID!, forKey:"notiRest")
                UserDefaults.standard.set(response.notification.request.content.userInfo[AnyHashable("gcm.notification.restaurant_name")] as! String, forKey:"notiName")
                UserDefaults.standard.set(response.notification.request.content.userInfo[AnyHashable("gcm.notification.img")] as! String , forKey:"notiImg")
                UserDefaults.standard.set("Yes", forKey:"isReview")
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                
        }
        
        completionHandler()
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }


   
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
        //            openURL:url
        //            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
        //            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
        //        ];
        
        let handled=FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || handled
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url,
//                                                                                                                                                                                                sourceApplication: sourceApplication,
//                                                                                                                                                                                                annotation: annotation)
//    }
    
    func showActivityIndicatory(uiView: UIView) {

       uiView.isUserInteractionEnabled = false
    
    }

    
   
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
 
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the
        
       
    }
 
 


}

