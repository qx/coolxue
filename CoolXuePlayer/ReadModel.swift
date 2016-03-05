
//
//  ReadModel.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/23.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class ReadModel:NSObject{
    var content:String = ""
    var id:Int = 0
    var lastItem:String = ""
    var newAdminReply:Bool = false
    var newUserReply:Bool = false
    var postTime:String = ""
    var status:String = ""
    override init(){
        
    }
    func setUserInfo(dict:NSDictionary){
        let content:String! = dict["content"] as? String
        let id:Int! = dict["id"] as? Int
        let lastItem:String! = dict["lastItem"] as? String
        let newAdminReply:Bool! = dict["newAdminReply"] as? Bool
        let newUserReply:Bool! = dict["newUserReply"] as? Bool
        let postTime:String! = dict["postTime"] as? String
        let status:String! = dict["status"] as? String
        
        self.content = (content != nil) ? content : self.content
        self.id = (id != nil) ? id : self.id
        self.lastItem = (lastItem != nil) ? lastItem : self.lastItem
        self.newAdminReply = (newAdminReply != nil) ? newAdminReply : self.newAdminReply
        self.newUserReply = (newUserReply != nil) ? newUserReply : self.newUserReply
        self.postTime = (postTime != nil) ? postTime : self.postTime
        self.status = (status != nil) ? status : self.status
    }
    init(dict:NSDictionary){
        super.init()
        self.setUserInfo(dict)
    }
}