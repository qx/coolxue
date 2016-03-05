//
//  HistoryViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadMoreFooterViewDelegate,HistoryTVCellDelegate{
    func playVedio(vedio: Vedio) {
        self.currVedio = vedio
        let url = "http://www.icoolxue.com/video/play/url/"+String(self.currVedio!.id)
        getVedioPlayUrl(url)
    }
    func footerRefreshTableData(newVedio: Vedio) {
        self.albumList.append(newVedio)
        self.productTableView.reloadData()
    }
    var currVedio:Vedio?
    @IBOutlet weak var productTableView: UITableView!
    var albumList:Array<Vedio> = []
    var vedioList:Array<Vedio> = []
    var history_url = "http://www.icoolxue.com/video/log/my/1/10"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HistoryTVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "HistoryTVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension

        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        
        let footerView:LoadMoreFooterView = LoadMoreFooterView.loadMoreFooterView
        footerView.delegate = self
        self.productTableView.tableFooterView = footerView
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated)
        print("viewWillAppear")
//        if LoginTool.isNeedUserLogin == true {
//            var alert:UIAlertView = UIAlertView(title: "提示", message: "亲，请登录！", delegate: self, cancelButtonTitle: "确定")
//            alert.show()
//            self.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
//        }else if LoginTool.isLogin == true {
//            self.getHistoryData(self.history_url)
//        }else if LoginTool.isAutoLogin == false {
//            LoginTool.autoLogin()
//        }
        if LoginTool.isLogin == true {
            self.getHistoryData(self.history_url)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHistoryData(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            do {
               let bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
                //print(bdict)
                let code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                    self.albumList.removeAll(keepCapacity: true)
                    self.vedioList.removeAll(keepCapacity: true)
                    let dict = bdict["data"] as! NSDictionary
                    let c_array = dict["data"] as! NSArray
                    if c_array.count > 0 {
                        for dict in c_array{
                            //print(dict["video"])
                            let currAlbum = Vedio(dictVedio: dict["album"] as! NSDictionary)
                            self.albumList.append(currAlbum)
                            let currVedio = Vedio(dictVedio: dict["video"] as! NSDictionary)
                            self.vedioList.append(currVedio)
                        }
                        self.productTableView.reloadData()
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
        return self.albumList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTVCellID", forIndexPath: indexPath) as? HistoryTVCell
        cell?.delegate = self
        cell!.vedio = self.vedioList[indexPath.row] as Vedio
        let album = self.albumList[indexPath.row] as Vedio
        cell!.nameLabel.text = album.name
        cell!.authorLabel.text = "作者："+album.author
        cell!.palyTimesLabel.text = "播放次数：\(album.playTimes)"
        var imgurl:NSURL = NSURL(string: "")!
        if album.defaultCover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:album.defaultCover)!
        }else if album.cover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:album.cover)!
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
        let vedio:Vedio = self.albumList[indexPath.row]
        self.performSegueWithIdentifier("ToVedioListVC", sender: vedio)
    }
    
    func getVedioPlayUrl(path:String){
        print("request url = \n\(path)")
        let headerParam:Dictionary<String,String> = ["referer":"http://www.icoolxue.com"]
        HttpManagement.requestttt(path, method: "GET",bodyParam: nil,headParam:headerParam) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            do {
                let bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
                //print(bdict)
                let code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                    let vedio_url = bdict["data"] as? String
                    if vedio_url != nil {
                        self.currVedio?.vedioUrl = vedio_url
                        self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currVedio)
                    }else{
                        print("Failed to Get Url!!!!!!!!")
                        let alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
                }
            } catch {
                print(error)
            }
     
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VedioPlaySegueId" {
            if sender?.isKindOfClass(Vedio) == true {
                let adController:VedioPlayerViewController = segue.destinationViewController as! VedioPlayerViewController
                adController.channel = sender as? Vedio
            }
        }else if segue.identifier == "ToVedioListVC" {
            if sender?.isKindOfClass(Vedio) == true {
                let adController:VedioListVC = segue.destinationViewController as! VedioListVC
                adController.channel = sender as? Vedio
            }
        }
    }
}
