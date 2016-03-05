//
//  NetWorkHelper.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/24.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//
import SystemConfiguration
import Foundation
public class NetWorkHelper:NSObject{
    //网络状态
    public static var networkStatus:Int = 0
    //网络是否正常
    public static var is_network_ok:Bool = false
    //是否已经注册网络监测
    private static var is_register_network_monitor:Bool = false
    
    private static var hostReachability:Reachability!
    private static var internetReachability:Reachability!
    private static var wifiReachability:Reachability!
    
    private static var observer:NetWorkHelper = NetWorkHelper()
    
    private override init(){
        print("init")
    }
    
    //监测设备网络
    public class func registerNetWorkMonitor(){
        if !self.is_register_network_monitor {
            self.is_register_network_monitor = true
            NSNotificationCenter.defaultCenter().addObserver(observer, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
            self.hostReachability = Reachability(hostName: "www.apple.com")
            self.hostReachability.startNotifier()
            self.internetReachability = Reachability.reachabilityForInternetConnection()
            self.internetReachability.startNotifier()
            
            
            self.wifiReachability = Reachability.reachabilityForLocalWiFi()
            self.wifiReachability.startNotifier()
            
            print(self.hostReachability.currentReachabilityStatus().rawValue)
            print(self.internetReachability.currentReachabilityStatus().rawValue)
            print(self.wifiReachability.currentReachabilityStatus().rawValue)
            
            if self.hostReachability.currentReachabilityStatus().rawValue != 0 || self.internetReachability.currentReachabilityStatus().rawValue != 0 || self.wifiReachability.currentReachabilityStatus().rawValue != 0{
                NetWorkHelper.is_network_ok = true
            }
        }
    }
    
    //设备网络环境发生变化时通知(不能写成私有方法)
    func reachabilityChanged(note:NSNotification){
        print("reachabilityChanged")
        var curReach:Reachability = note.object as! Reachability
        
        var netStatus:NetworkStatus = curReach.currentReachabilityStatus()
        var connectionRequired = curReach.connectionRequired()
        var statusString = "";
        print(netStatus.rawValue)
        if netStatus.rawValue == 0 {
            NetWorkHelper.is_network_ok = false
            print("没有可用网络！\(netStatus.rawValue)")
            D3Notice.showText("没有可用网络！",time:D3Notice.longTime,autoClear:true)
        }else{
            NetWorkHelper.is_network_ok = true
            print("网络已连接！\(netStatus.rawValue)")
            //D3Notice.showText("网络已连接！\(netStatus.rawValue)",time:D3Notice.longTime,autoClear:true)
        }
        switch netStatus.rawValue
        {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
        
        if (connectionRequired){
            print("%@, Connection Required"+"Concatenation of status string with connection requirement")
        }
    }
}

let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

public class Reach {
    
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NSNotificationCenter.defaultCenter().postNotificationName(ReachabilityStatusChangedNotification,
                object: nil,
                userInfo: ["Status": status.description])
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes)
    }
    
}

extension ReachabilityStatus {
    private init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.ConnectionRequired)
        let isReachable = flags.contains(.Reachable)
        let isWWAN = flags.contains(.IsWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}