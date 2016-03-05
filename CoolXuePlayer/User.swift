//
//  User.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/17.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class User:NSObject{
    var address:String = ""
    var admin:Bool = false
    var answerNum:Int = 0
    var avatar:String = ""
    var blogNum:Int = 0
    var defaultAvatar:String = ""
    var email:String = ""
    var firstName:String = ""
    var id:Int = 0
    var identify:String = ""
    var income:Int = 0
    var ingot:Int = 0
    var job:Int = 0
    var key:String = ""
    var lastName:String = ""
    var lastTime:Int32 = 0
    var lvl:Int = 0
    var nickName:String = ""
    var otherUser:Bool = false
    var pay:Int = 0
    var qq:String = ""
    var questionNum:Int = 0
    var redeem:Int = 0
    var redeemRatio:Float = 0.0
    var redeemed:Int = 0
    var regTime:Int32 = 0
    var score:Int = 0
    var sex:String = ""
    var signature:String = ""
    var status:Int = 0
    var used:Int = 0
    var username:String = ""
    override init(){
        
    }
   func setUserInfo(dictUser:NSDictionary){
        let address:String! = dictUser["address"] as? String
        let admin:Bool! = dictUser["admin"] as? Bool
        let answerNum:Int! = dictUser["answerNum"] as? Int
        let avatar:String! = dictUser["avatar"] as? String
        let blogNum:Int! = dictUser["job"] as? Int
        let defaultAvatar:String! = dictUser["pay"] as? String
        let email:String! = dictUser["email"] as? String
        let firstName:String! = dictUser["firstName"] as? String
        let id:Int! = dictUser["id"] as? Int
        let identify:String! = dictUser["identify"] as? String
        let income:Int! = dictUser["income"] as? Int
        let ingot:Int! = dictUser["ingot"] as? Int
        let job:Int! = dictUser["job"] as? Int
        let key:String! = dictUser["key"] as? String
        let lastName:String! = dictUser["lastName"] as? String
        let lastTime:Int32! = dictUser["lastTime"] as? Int32
        let lvl:Int! = dictUser["lvl"] as? Int
        let nickName:String! = dictUser["nickName"] as? String
        let otherUser:Bool! = dictUser["otherUser"] as? Bool
        let pay:Int! = dictUser["pay"] as? Int
        let qq:String! = dictUser["qq"] as? String
        let questionNum:Int! = dictUser["questionNum"] as? Int
        let redeem:Int! = dictUser["redeem"] as? Int
        let redeemRatio:Float! = dictUser["redeemRatio"] as? Float
        let redeemed:Int! = dictUser["redeemed"] as? Int
        let regTime:Int32! = dictUser["regTime"] as? Int32
        let score:Int! = dictUser["score"] as? Int
        let sex:String! = dictUser["sex"] as? String
        let signature:String! = dictUser["signature"] as? String
        let status:Int! = dictUser["status"] as? Int
        let used:Int! = dictUser["used"] as? Int
        let username:String! = dictUser["username"] as? String
        
        self.address = (address != nil) ? address : self.address
        self.admin = (admin != nil) ? admin : self.admin
        self.answerNum = (answerNum != nil) ? answerNum : self.answerNum
        self.avatar = (avatar != nil) ? avatar : self.avatar
        self.blogNum = (blogNum != nil) ? blogNum : self.blogNum
        self.defaultAvatar = (defaultAvatar != nil) ? defaultAvatar : self.defaultAvatar
        self.email = (email != nil) ? email : self.email
        self.firstName = (firstName != nil) ? firstName : self.firstName
        self.id = (id != nil) ? id : self.id
        self.identify = (identify != nil) ? identify : self.identify
        self.income = (income != nil) ? income : self.income
        self.ingot = (ingot != nil) ? ingot : self.ingot
        self.job = (job != nil) ? job : self.job
        self.key = (key != nil) ? key : self.key
        self.lastName = (lastName != nil) ? lastName : self.lastName
        self.lastTime = (lastTime != nil) ? lastTime : self.lastTime
        self.lvl = (lvl != nil) ? lvl : self.lvl
        self.nickName = (nickName != nil) ? nickName : self.nickName
        self.otherUser = (otherUser != nil) ? otherUser : self.otherUser
        self.pay = (pay != nil) ? pay : self.pay
        self.qq = (qq != nil) ? qq : self.qq
        self.questionNum = (questionNum != nil) ? questionNum : self.questionNum
        self.redeem = (redeem != nil) ? redeem : self.redeem
        self.redeemRatio = (redeemRatio != nil) ? redeemRatio : self.redeemRatio
        self.redeemed = (redeemed != nil) ? redeemed : self.redeemed
        self.regTime = (regTime != nil) ? regTime : self.regTime
        self.score = (score != nil) ? score : self.score
        self.sex = (sex != nil) ? sex : self.sex
        self.signature = (signature != nil) ? signature : self.signature
        self.status = (status != nil) ? status : self.status
        self.used = (used != nil) ? used : self.used
        self.username = (username != nil) ? username : self.username
    }
    init(dictUser:NSDictionary){
        super.init()
        self.setUserInfo(dictUser)
    }
}