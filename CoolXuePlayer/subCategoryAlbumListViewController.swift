//
//  subCategoryAlbumListViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class subCategoryAlbumListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var subCategory:CategorySub?
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Vedio> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "VedioListTabVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "VedioListTabVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension

        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.getVedioData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
        let vedio = self.channelList[indexPath.row] as Vedio
        cell!.nameLabel.text = vedio.name
        cell!.authorLabel.text = "作者："+vedio.author
        cell!.palyTimesLabel.text = "播放次数：\(vedio.playTimes)"
        cell!.playCostLabel.text = "爱苦逼：\(vedio.playCost)"
        var imgurl:NSURL = NSURL(string: "")!
        if vedio.defaultCover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio.defaultCover)!
        }else if vedio.cover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio.cover)!
        }
        //print("imgurl=\(imgurl)")
        cell!.vedioImage.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //print("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //print("cached finished")
        })
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let channel:Vedio = self.channelList[indexPath.row]
        self.performSegueWithIdentifier("ToVedioListVC", sender: channel)
    }
    
    func getVedioData(){
        let url = "http://www.icoolxue.com/album/affix/\(self.subCategory!.value!)/1/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            do {
                let bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
                //print(bdict)
                let code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                    let dict = bdict["data"] as! NSDictionary
                    let c_array = dict["data"] as! NSArray
                    if c_array.count > 0 {
                        for dict in c_array{
                            //print(dict["video"])
                            let channel = Vedio(dictVedio: dict as! NSDictionary)
                            self.channelList.append(channel)
                        }
                        self.productTableView.reloadData()
                    }
                }

            } catch {
                print(error)
            }
                   }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToVedioListVC" {
            if sender?.isKindOfClass(Vedio) == true {
                let adController:VedioListVC = segue.destinationViewController as! VedioListVC
                adController.channel = sender! as? Vedio
            }
        }
    }
}
