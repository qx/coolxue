//
//  CategoryViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var ACategoryTableView: UITableView!
    @IBOutlet weak var BCategoryCollectionView: UICollectionView!
    var aCategoryList:Array<Category> = []
    var currACategoryList:Array<CategorySub> = []
    var cache_category_path = "/Documents/videoCategory"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ACategoryTableView.dataSource = self
        self.ACategoryTableView.delegate = self
        self.ACategoryTableView.showsVerticalScrollIndicator = false
        self.BCategoryCollectionView.dataSource = self
        self.BCategoryCollectionView.delegate = self
        
        //读取本地缓存
        self.aCategoryList = DataHelper.getVideoCategoryList(DataHelper.ReadDate(self.cache_category_path)) as! Array<Category>
        if self.aCategoryList.count > 0 && self.currACategoryList.count == 0 {
            self.currACategoryList = self.aCategoryList[0].subCategoryList!
            //选中第一个行
            self.ACategoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Bottom)
        }

        //有网络才请求数据
        if NetWorkHelper.is_network_ok == true {
            self.getCategoryData()
        } else {
            print("Network Connection: Unavailable")
            D3Notice.showText("没有可用网络！",time:D3Notice.longTime,autoClear:true)
        }
    }
    
    func getCategoryData(){
        let url = "http://www.icoolxue.com/category"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
//            var str = NSString(data: data, encoding: NSUTF8StringEncoding)
//            print(str)
            
            do {
                let bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
                let code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                    self.aCategoryList = DataHelper.getVideoCategoryList(bdict) as! Array<Category>
                    if self.aCategoryList.count > 0 {
                        if self.currACategoryList.count == 0 {
                            self.currACategoryList = self.aCategoryList[0].subCategoryList!
                        }
                        self.ACategoryTableView.reloadData()
                        //选中第一个行(table加载后才能调用)
                        self.ACategoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Bottom)
                        self.BCategoryCollectionView.reloadData()
                        //将文件保存到本地
                        DataHelper.CacheData(self.cache_category_path, data: data)
                    }
                }
            } catch {
                print(error)
            }
            
       
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aCategoryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("ACategoryCellID", forIndexPath: indexPath) 
        let data = self.aCategoryList[indexPath.row]
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = data.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let currACategory = self.aCategoryList[indexPath.row]
        self.currACategoryList = currACategory.subCategoryList!
        self.BCategoryCollectionView.reloadData()
    }
    
    //＝＝＝＝B分类
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currACategoryList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BCategoryCellID", forIndexPath: indexPath) as! CategoryCollectionViewCell
        let data = self.currACategoryList[indexPath.row]
        cell.categoryLabel.text = data.name
        let imgurl = NSURL(string: data.cover!)
        cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //print("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //print("cached finished")
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let subCategory:CategorySub = self.currACategoryList[indexPath.row]
        //performSegueWithIdentifier(identifier: String?, sender: AnyObject?)
        self.performSegueWithIdentifier("SubGategoryAlbumList", sender: subCategory)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(CategorySub) == true {
            let adController:subCategoryAlbumListViewController = segue.destinationViewController as! subCategoryAlbumListViewController
            adController.subCategory = sender as? CategorySub
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
