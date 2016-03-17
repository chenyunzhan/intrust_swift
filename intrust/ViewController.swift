//
//  ViewController.swift
//  intrust
//
//  Created by cloud on 16/1/22.
//  Copyright © 2016年 cloud. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var command: CommandModel!
    var systemDic: NSDictionary!
    var collectionData: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (command.id == "T_HOME") {

            
            let homeBackImage = UIImageView(image: UIImage(named: "home_head_back_image"))
            let nameButton = UIButton()
            let photoButton = UIButton()
            let photoBackButton = UIButton()
            let codeButton = UIButton()
            
//            photoButton.setImage(UIImage(named: "home_head_photo"), forState: UIControlState.Normal)
            photoButton.backgroundColor = UIColor.clearColor()
            photoButton.layer.cornerRadius = 50
            photoButton.layer.masksToBounds = true
            photoButton.setBackgroundImage(UIImage(named: "home_head_photo"), forState: UIControlState.Normal)
            
            photoBackButton.layer.cornerRadius = 52
            photoBackButton.layer.masksToBounds = true
            photoBackButton.backgroundColor = UIColor.whiteColor()
            
            
            nameButton.setImage(UIImage(named: "home_head_name"), forState: UIControlState.Normal)
            
            codeButton.setImage(UIImage(named: "home_head_favourite"), forState: UIControlState.Normal)
            
            self.view.addSubview(homeBackImage)
            homeBackImage.addSubview(photoBackButton)
            homeBackImage.addSubview(photoButton)
            homeBackImage.addSubview(nameButton)
            homeBackImage.addSubview(codeButton)

    
            
            homeBackImage.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(0)
                make.left.equalTo(self.view).offset(0)
                make.bottom.lessThanOrEqualTo(self.view).offset(-20)
                make.right.equalTo(self.view).offset(0)
            }
            
            
            photoButton.snp_makeConstraints { (make) -> Void in
                make.center.equalTo(homeBackImage)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            
            photoBackButton.snp_makeConstraints { (make) -> Void in
                make.center.equalTo(homeBackImage)
                make.width.equalTo(104)
                make.height.equalTo(104)
            }
            
            nameButton.snp_makeConstraints { (make) -> Void in
                make.centerY.equalTo(homeBackImage)
                make.centerX.equalTo(homeBackImage).offset(-100)
                make.height.equalTo(30)
            }
            
            codeButton.snp_makeConstraints { (make) -> Void in
                make.centerY.equalTo(homeBackImage)
                make.centerX.equalTo(homeBackImage).offset(100)
                make.height.equalTo(30)
            }
            
            
            
            
            
            
            Alamofire.request(.GET, AppDelegate.baseURLString + "/x/mobsrv/user/info", parameters: ["code": "4202"])
                .responseJSON { response in
                    print(response.request)
                    
                    
                    let userDic = JSON(response.result.value!).dictionaryObject
                    let photoData = NSData(base64EncodedString: userDic!["photo"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    photoButton.setBackgroundImage(UIImage(data: photoData!), forState: UIControlState.Normal)
                    nameButton.setTitle(userDic!["full_name"] as? String, forState: UIControlState.Normal)
                    codeButton.setTitle(userDic!["user_code"] as? String, forState: UIControlState.Normal)

            }
            
            
            
            Alamofire.request(.GET, AppDelegate.baseURLString + command.url, parameters: nil)
                .responseJSON { response in
                    print(response.request)
                    let json = JSON(response.result.value!["aaData"]!!).arrayValue
      
                    for index in 0...json.count-1 {
                        var collectItem = json[index]
                        var collectItemDic = collectItem.dictionaryObject
                        let rowItems = JSON(collectItemDic!["items"]!).arrayValue


                        
                        
                        let collectionData = NSMutableArray()

                        
                        for rowItem in rowItems {
                            
                            let rowCollectionData = NSMutableArray()
                            
                            for colItem in rowItem.arrayValue {
                                let command = CommandModel(fromDictionary: colItem.dictionaryObject!)
                                
                                rowCollectionData .addObject(command)
                                print(colItem);


                            }
                            
                            collectionData.addObject(rowCollectionData)
                        }
                        
                        
                        self.collectionData = collectionData

                    }
                    
                    
                    for index in 0...self.collectionData.count-1 {
                        let collectView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout.init());
                        collectView.tag = index
                        collectView.delegate = self
                        collectView.dataSource = self
                        collectView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
                        
                        self.view.addSubview(collectView)
                        
                        
                        collectView.snp_makeConstraints { (make) -> Void in
                            make.top.equalTo(homeBackImage)
                            make.width.equalTo(homeBackImage)
                            make.height.equalTo(self.collectionData[index].count)
                        }
                    }
                    

                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }

        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionData[section].count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "CommandCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as UICollectionViewCell
        let commandButton = UIButton()
        
        
        let commandModel = self.collectionData[indexPath.section][indexPath.row]
        commandButton.setTitle(commandModel.title, forState: UIControlState.Normal)
        cell.addSubview(commandButton)
        return cell
        
    }


}

