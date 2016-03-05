//
//  SearchViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/31.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    var currVedio:Vedio?
    var mysearchBar:UISearchBar!
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Vedio> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "VedioListTabVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "VedioListTabVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        
        mysearchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 40))
        mysearchBar.delegate = self
        self.productTableView.tableHeaderView = mysearchBar
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText=\(searchText)")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        print("searchBar.text = \(searchBar.text)")
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        print("searchBar.text = \(searchBar.text)")
        var url = "http://www.icoolxue.com/search/video/1/10?q="+searchBar.text!
        print("search url =\(url)")
        getSearchData(url)
        mysearchBar.resignFirstResponder()
    }
    
    func getSearchData(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
                do {
            var bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
                //print(bdict)
                var code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                    var dict = bdict["data"] as! NSDictionary
                    var c_array = dict["data"] as! NSArray
                    if c_array.count > 0 {
                        for dict in c_array{
                            var channel = Vedio(dictVedio: dict as! NSDictionary)
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
        self.currVedio = self.channelList[indexPath.row]
        let channel_url = "http://www.icoolxue.com/video/play/url/"+String(self.currVedio!.id)
        getVedioPlayUrl(channel_url)
    }
    
    func getVedioPlayUrl(path:String){
        print("request url = \n\(path)")
        var headerParam:Dictionary<String,String> = ["referer":"http://www.icoolxue.com"]
        HttpManagement.requestttt(path, method: "GET",bodyParam: nil,headParam:headerParam) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            do {
            var bdict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as!NSDictionary
            //print(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var vedio_url = bdict["data"] as? String
                if vedio_url != nil {
                    self.currVedio?.vedioUrl = vedio_url
                    self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currVedio)
                }else{
                    print("Failed to Get Url!!!!!!!!")
                    var alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
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
        if sender?.isKindOfClass(Vedio) == true {
            let adController:VedioPlayerViewController = segue.destinationViewController as! VedioPlayerViewController
            adController.channel = sender as? Vedio
        }
    }
}
