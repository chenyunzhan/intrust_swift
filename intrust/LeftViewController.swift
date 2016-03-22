//
//  LeftViewController.swift
//  intrust
//
//  Created by cloud on 16/1/22.
//  Copyright © 2016年 cloud. All rights reserved.
//

import UIKit
import Alamofire
import FontAwesome_swift
import SwiftyJSON

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var mainViewController: UIViewController!
    var userDic: NSDictionary!
    var tableData: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = UIImageView(image: UIImage(named: "slide_back_image"))
    
        self.view .addSubview(backImage)

        
        backImage.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
        }
        
        
        
        let logoutButton = UIButton()
        
        logoutButton.setTitle("退出登录", forState: UIControlState.Normal)
        logoutButton.setImage((UIImage (named: "slide_logout")), forState: UIControlState.Normal)
        
        self.view.addSubview(logoutButton)
        
        logoutButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        let bookButton = UIButton()
        bookButton.setTitle("通讯录", forState: UIControlState.Normal)
        bookButton.setImage((UIImage (named: "slide_contacts")), forState: UIControlState.Normal)
        bookButton.titleLabel?.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        self.view.addSubview(bookButton)
        
        bookButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(logoutButton.snp_right).offset(20)
            make.bottom.equalTo(logoutButton)
        }
        
        if(userDic != nil) {
            let photoData = NSData(base64EncodedString: userDic!["photo"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            
            let photoImage = UIImageView(image: UIImage(data: photoData!))
            
            photoImage.layer.cornerRadius = 40
            photoImage.layer.masksToBounds = true
            
            self.view .addSubview(photoImage)

            
            photoImage.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(80)
                make.left.equalTo(self.view).offset(50)
                make.height.equalTo(80)
                make.width.equalTo(80)
            }
            
            
            let userNameLabel = UILabel()
            userNameLabel.text = self.userDic["full_name"] as? String
            self.view .addSubview(userNameLabel)

            userNameLabel.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(photoImage).offset(8)
                make.left.equalTo(photoImage.snp_right).offset(15)
//                make.height.equalTo(80)
//                make.width.equalTo(80)
            }
            
            
            let userCodeLabel = UILabel()
            userCodeLabel.text = self.userDic["user_code"] as? String
            self.view.addSubview(userCodeLabel)
            
            userCodeLabel.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(userNameLabel.snp_bottom).offset(8)
                make.left.equalTo(userNameLabel)
            })
            
            
            let splitLineView = UIView()
            splitLineView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(splitLineView)
            
            splitLineView.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(photoImage.snp_bottom).offset(20)
                make.left.equalTo(self.view).offset(10)
                make.right.equalTo(self.view).offset(0)
                make.height.equalTo(1)
            })
            
            
            let tableView = UITableView()
            tableView.backgroundColor = UIColor.clearColor()
            tableView.dataSource = self
            tableView.delegate = self
            self.view.addSubview(tableView)
            
            tableView.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(splitLineView).offset(8)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-100)
            })
        }
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = self.tableData[indexPath.row]["title"] as? String
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Alamofire.request(.GET, AppDelegate.baseURLString + "/x/mobsrv/tabbar", parameters: ["proxy": self.tableData[indexPath.row]["code"]!!])
            .responseJSON { response in
                print(response.request)
                
                
                var viewControllers = [ViewController]()
                let json = JSON(response.result.value!["aaData"]!!).arrayValue
                for item in json {
                    let command = CommandModel(fromDictionary: item.dictionaryObject!)
                    if command.icon == "icon-comments-alt" {
                        command.icon = "icon-comments"
                    }
                    let imageStr = command.icon!.stringByReplacingOccurrencesOfString("icon", withString: "fa")
                    let viewController = ViewController()
                    viewController.command = command
                    viewController.systemDic = self.tableData[indexPath.row] as! NSDictionary
                    let image = UIImage.fontAwesomeIconWithName(FontAwesome.fromCode(imageStr)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
                    
                    viewController.tabBarItem = UITabBarItem(title: command.title, image: image, tag: 0)
                    viewControllers.append(viewController)
                }
                
                let nvc = self.slideMenuController()?.mainViewController as! UINavigationController
                let mainViewController = nvc.viewControllers[0] as! MainViewController
                mainViewController.viewControllers = viewControllers;
                self.slideMenuController()?.closeLeft()
                
        }
    }

}
