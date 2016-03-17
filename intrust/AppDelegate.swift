//
//  AppDelegate.swift
//  intrust
//
//  Created by cloud on 16/1/22.
//  Copyright © 2016年 cloud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FontAwesome_swift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    static let baseURLString = "http://www.enfo.com.cn:38080"


    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        
        
        
        
        
        Alamofire.request(.GET, AppDelegate.baseURLString + "/x/mobsrv/login", parameters: ["username": "liuhao", "password":"000000"])
            .responseJSON { response in
                print(response.request)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                
                
                Alamofire.request(.GET, AppDelegate.baseURLString + "/x/mobsrv/proxys", parameters: nil)
                    .responseJSON { response in
                        

                        if response.result.isSuccess {
                            let json = JSON(response.result.value!).arrayValue
                            let firstSystemDic = json[0].dictionaryObject
                            
                            
                            
                            Alamofire.request(.GET, AppDelegate.baseURLString + "/x/mobsrv/tabbar", parameters: ["proxy": firstSystemDic!["code"]!])
                                .responseJSON { response in
                                    print(response.request)
                                    var result = [CommandModel]()
                                    var viewControllers = [ViewController]()
                                    let json = JSON(response.result.value!["aaData"]!!).arrayValue
                                    for item in json {
                                        let command = CommandModel(fromDictionary: item.dictionaryObject!)
                                        let imageStr = command.icon.stringByReplacingOccurrencesOfString("icon", withString: "fa")
                                        let viewController = ViewController()
                                        viewController.command = command
                                        viewController.systemDic = firstSystemDic
                                        let image = UIImage.fontAwesomeIconWithName(FontAwesome.fromCode(imageStr)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))

                                        viewController.tabBarItem = UITabBarItem(title: command.title, image: image, tag: 0)
                                        result.append(command)
                                        viewControllers.append(viewController)
                                    }
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                                    let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
                                    
                                    mainViewController.viewControllers = viewControllers;
                                    
                                    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                                    
                                    UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                                    
                                    UINavigationBar.appearance().setBackgroundImage(UIImage(named: "top_nav")!, forBarMetrics: .Default);
                                    
                                    //        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_nav"] forBarMetrics:UIBarMetricsDefault];
                                    
                                    leftViewController.mainViewController = nvc
                                    
                                    let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                                    
                                    self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                                    self.window?.rootViewController = slideMenuController
                                    self.window?.makeKeyAndVisible()
                            }
                        }else{
 
                        }
                        
                        

                }
        }
        
        
        

        
        return true
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

