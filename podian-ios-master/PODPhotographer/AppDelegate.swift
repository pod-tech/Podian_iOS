//
//  AppDelegate.swift
//  PODPhotographer
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FacebookCore
import GoogleSignIn
import AVFoundation
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var locationManager:CLLocationManager!
    var window : UIWindow?
    var player: AVAudioPlayer?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
        self.determineMyCurrentLocation();
        GIDSignIn.sharedInstance().clientID = "44495372592-01t6ohop7crfo4ivqehe1vp2svg6s36q.apps.googleusercontent.com"
        
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Constant.deviceToken = token ?? ""

        if #available(iOS 10.0, *) { UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        let nav = UINavigationController.init(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = nav;
        UIView.appearance().isOpaque = false;
        return true;
    }
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ application: UIApplication,
                  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         print("deviceToken\(deviceToken)")
         Messaging.messaging().apnsToken = deviceToken as Data
     }

     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
         // Print full message.
         print(userInfo)

     }

     // This method will be called when app received push notifications in foreground
     @available(iOS 10.0, *)
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
     { completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        self.playSound()
     }


     // MARK:- Messaging Delegates
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
         InstanceID.instanceID().instanceID { (result, error) in
             if let error = error {
                 print("Error fetching remote instange ID: \(error)")
             } else if let result = result {
                 print("Remote instance ID token: \(result.token)")
                  Constant.deviceToken = result.token
             }
         }
     }


     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
         print("received remote notification")
     }
    
     // MARK: UISceneSession Lifecycle
     
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK:- To get the user current location delegate methods
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "NotificationSound", withExtension: "caf") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        if(Constant.currLat != userLocation.coordinate.latitude)
        {
            DispatchQueue.global(qos: .background).async {
                print("Run on background thread")
                LoginController.SaveUserTrackingData()
                DispatchQueue.main.async {
                    print("We finished that.")
                }
            }
        }
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        Constant.currLat = userLocation.coordinate.latitude
        Constant.currLng = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}

extension String {
    public init(deviceToken: Data) {
        self = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
    }
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do{
            
            if let jsonData = data {
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } else {
                // Lossless conversion of the string was not possible
                return nil
            }
        }
        catch let error{
            
        }
         return nil
    }
}

