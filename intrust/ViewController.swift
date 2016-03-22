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
import FontAwesome_swift
import MGSwipeTableCell



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate{
    
    var command: CommandModel!
    var systemDic: NSDictionary!
    var collectionData: NSMutableArray!
    var tableData: NSMutableArray!
    var rowCmdArray: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "f2f2f2")

        
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
                    let leftVC = self.slideMenuController()?.leftViewController as! LeftViewController
                    leftVC.userDic = userDic
                    leftVC.viewDidLoad()
                    let photoData = NSData(base64EncodedString: userDic!["photo"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    photoButton.setBackgroundImage(UIImage(data: photoData!), forState: UIControlState.Normal)
                    nameButton.setTitle(userDic!["full_name"] as? String, forState: UIControlState.Normal)
                    codeButton.setTitle(userDic!["user_code"] as? String, forState: UIControlState.Normal)

            }
            
            
            
            Alamofire.request(.GET, AppDelegate.baseURLString + command.url, parameters: nil)
                .responseJSON { response in
                    print(response.request)
                    let json = JSON(response.result.value!["aaData"]!!).arrayValue
                    
                    
                    let collectionData = NSMutableArray()
      
                    if json.count > 0  {
                        for index in 0...json.count-1 {
                            var collectItem = json[index]
                            var collectItemDic = collectItem.dictionaryObject
                            let rowItems = JSON(collectItemDic!["items"]!).arrayValue
                            let rowCollectionData = NSMutableArray()
                            for rowItem in rowItems {
                                let colCollectionData = NSMutableArray()
                                for colItem in rowItem.arrayValue {
                                    let command = CommandModel(fromDictionary: colItem.dictionaryObject!)
                                    
                                    colCollectionData.addObject(command)
                                    
                                }
                                rowCollectionData.addObject(colCollectionData)
                            }
                            collectionData.addObject(rowCollectionData)
                        }
                    }
                    
                    self.collectionData = collectionData

                    
                    var topConstraint: Constraint? = nil
                    var offset = 0

                    
                    if self.collectionData.count > 0 {
                        for index in 0...self.collectionData.count-1 {
                            let collectView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout.init());
                            collectView.tag = index
                            collectView.delegate = self
                            collectView.dataSource = self
                            collectView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
                            collectView.backgroundColor = UIColor.clearColor()
                            self.view.addSubview(collectView)
                            
                            collectView.snp_makeConstraints { (make) -> Void in
                                topConstraint = make.top.equalTo(homeBackImage.snp_bottom).constraint
                                make.width.equalTo(homeBackImage)
                                
                                make.height.equalTo(self.collectionData[index].count*44)
                            }
                            topConstraint?.updateOffset(offset)
                            offset += self.collectionData[index].count*44+8
                            
                            self.view.layoutIfNeeded()
                        }
                    }
                    
                    

//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
            }

        } else if (command.id == "T_CNFG") {

        } else {
            if (command.id == "T_BOOK") {
                command.url = "/x/mobsrv/user/list"
            }
            
            
            Alamofire.request(.GET, AppDelegate.baseURLString + command.url, parameters: nil)
                .responseJSON { response in
                    
                print(response.request)
                
                let cellDicArray = JSON(response.result.value!["aaData"]!!).arrayValue
                let cellModel = JSON(response.result.value!["colnames"]!!).dictionaryObject
                    
                let tableData = NSMutableArray()
                for cellDic in cellDicArray {
                    let command = CellModel(fromDictionary: cellDic.dictionaryObject!, cellDic: cellModel!)
                    tableData .addObject(command)
                }
                   
                let rowCmdDicArray = JSON(response.result.value!["rowCmd"]!!).arrayValue
                let rowCmdArray = NSMutableArray()
                for rowCmdDic in rowCmdDicArray {
                    let command = CommandModel(fromDictionary: rowCmdDic.dictionaryObject!)
                    rowCmdArray .addObject(command)
                }
                    
                self.tableData = tableData
                self.rowCmdArray = rowCmdArray
                    
                    
                let tableView = UITableView()
                tableView.delegate = self
                tableView.dataSource = self
                self.view .addSubview(tableView)
                    
                tableView.snp_makeConstraints { (make) -> Void in
                    make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(4, 4, 4, 4))
                }
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.collectionData[collectionView.tag].count
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionData[collectionView.tag][section].count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "CommandCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as UICollectionViewCell
        

        let commandButton = UIButton()
        var commandModel: CommandModel!
        commandModel = self.collectionData[collectionView.tag][indexPath.section][indexPath.row] as! CommandModel
        commandButton.setTitle(commandModel.title, forState: UIControlState.Normal)
        commandButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        commandButton.userInteractionEnabled = false
        
        
        if commandModel.icon == "icon-eye-open" {
            commandModel.icon = "icon-eye"
        } else if commandModel.icon == "icon-comment-alt" {
            commandModel.icon = "icon-comment"
        }
        
        let imageStr = commandModel.icon!.stringByReplacingOccurrencesOfString("icon", withString: "fa")
        
        
        let image = UIImage.fontAwesomeIconWithName(FontAwesome.fromCode(imageStr)!, textColor: Util.colorWithHexString(commandModel.iconclor), size: CGSizeMake(30, 30))
        commandButton.setImage(image, forState: UIControlState.Normal)
        
        
        cell.addSubview(commandButton)
        
        
        commandButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(cell).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((collectionView.frame.width)/CGFloat(self.collectionData[collectionView.tag][indexPath.section].count)-1, 44-1)
        

    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let command = self.collectionData[collectionView.tag][indexPath.section][indexPath.row] as! CommandModel
        let viewController = ViewController()
        viewController.command = command
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {

        let reuseIdentifier = "programmaticCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        
        let cellMode = self.tableData[indexPath.row] as! CellModel
        cell.textLabel?.text = cellMode.title
        cell.detailTextLabel!.text = "Detail text"

        if(self.rowCmdArray.count > 1) {
            let rightButtons = NSMutableArray()
            for index in 1...(self.rowCmdArray.count-1) {
                let command = self.rowCmdArray[index]
                
                var buttonColor: UIColor
                switch index {
                case 1:
                    buttonColor = UIColor(hex: "ff3b30")
                case 2:
                    buttonColor = UIColor(hex: "ff9c00")
                case 3:
                    buttonColor = UIColor(hex: "b2b2b2")
                default:
                    buttonColor = UIColor(hex: "999999")
                }
                let button = MGSwipeButton(title: command.title, backgroundColor: buttonColor)
                rightButtons .addObject(button)
            }
            cell.rightButtons = rightButtons as [AnyObject]
            cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        }
        
        return cell
    }


}

