//
//  FavoriteUnLoginTipVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/23.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class FavoriteUnLoginTipVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    func setView(){
        self.view.backgroundColor = UIColor.whiteColor()
        let tipLabel = UILabel(frame: CGRectMake((self.view.bounds.width - 200)/2, 100, 200, 40))
        tipLabel.font = UIFont.systemFontOfSize(12)
        tipLabel.text = "登录后才能查看收藏信息"
        tipLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(tipLabel)
        
        let bnLogin = UIButton(type: UIButtonType.Custom)
        bnLogin.backgroundColor = UIColor.redColor()
        bnLogin.frame = CGRectMake((self.view.bounds.width - 100)/2, 150, 100, 40)
        bnLogin.titleLabel?.textColor = UIColor.blueColor()
        bnLogin.titleLabel?.text = "登录"
        bnLogin.setTitle("登录", forState: UIControlState.Normal)
        bnLogin.addTarget(self, action: "ToLoginVC", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(bnLogin)
        
        self.navigationController?.title = "播放历史"
    }
    
    func ToLoginVC(){
        let s = UIStoryboard(name: "Main", bundle: nil)
        let tab = s.instantiateViewControllerWithIdentifier("loginTab") as? LoginUITabBarController
        self.navigationController?.pushViewController(tab!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated)
        if LoginTool.isLogin == true {
            self.navigationController?.popViewControllerAnimated(true)
//            for v in self.navigationController!.viewControllers {
//                if v.isKindOfClass(UserCenterVC){
//                    v.performSegueWithIdentifier("ToFavoriteVC", sender: nil)
//                    break
//                }
//            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
