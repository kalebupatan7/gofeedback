//
//  GFUtilities.swift
//  Genfare
//
//  Created by vishnu on 04/01/19.
//  Copyright © 2019 Genfare. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class Utilities {
    static var utilities = Utilities()
    class func apiHost() -> String {
        guard let info = Bundle.main.infoDictionary,
            let apiHost = info["api_host"] as? String else {
                fatalError("Cannot get api_host from info.plist")
        }
        return apiHost
    }
    class func sharedResource()->Utilities {
        return self.utilities
    }
    class func authHost() -> String {
        guard let info = Bundle.main.infoDictionary,
            let authHost = info["auth_host"] as? String else {
                fatalError("Cannot get auth_host from info.plist")
        }
        return authHost
    }

    class func tenantId() -> String {
        guard let info = Bundle.main.infoDictionary,
            let tenant = info["tenantId"] as? String else {
                fatalError("Cannot get tenant ID from info.plist")
        }
        return tenant
    }

    class func authUserID() -> String {
        guard let info = Bundle.main.infoDictionary,
            let authUser = info["auth_username"] as? String else {
                fatalError("Cannot get auth username from info.plist")
        }
        return authUser
    }
    
    class func authPassword() -> String {
        guard let info = Bundle.main.infoDictionary,
            let authPwd = info["auth_password"] as? String else {
                fatalError("Cannot get auth password from info.plist")
        }
        return authPwd
    }
    
    class func transitID() -> NSNumber {
        guard let info = Bundle.main.infoDictionary,
            let tid = info["transit_id"] as? NSNumber else {
                fatalError("Cannot get transit id from info.plist")
        }
        return tid
    }
    
    class func deviceId() -> String {
//        return "76B2B88F48B74E7995E9B70BB08F21BA"
//        return "621CB9DEA4A345928441D1B3CC227AFC"
//        return "094AF1B6903D49D590F71CC3498E8923"
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    class func appCurrentVersion() -> String {
        guard let info = Bundle.main.infoDictionary,
            let ver = info["CFBundleShortVersionString"] as? String else {
                fatalError("Cannot get CFBundleShortVersionString from info.plist")
        }
        return ver
    }
    
    class func accessToken() -> String {
        guard let strAccessToken = UserDefaults.standard.value(forKey: Constants.LocalStorage.AccessToken) as? String else{return ""}
        return strAccessToken
    }
    
    class func accountBalance() -> NSNumber {
        return UserDefaults.standard.value(forKey: Constants.LocalStorage.AccountBalance) as! NSNumber
    }

    class func saveAccountBalance(bal:NSNumber) {
        UserDefaults.standard.set(bal, forKey: Constants.LocalStorage.AccountBalance)
        UserDefaults.standard.synchronize()
    }

    class func convertDate(dateStr:String,fromFormat:String, toFormat:String) -> String {
        guard dateStr.count > 0 else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date!)
    }
    
    class func formattedDate(date:Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Ticket.DisplayDateFormat
        let newDate = NSDate(timeIntervalSince1970: date)
        return dateFormatter.string(from: newDate as Date)
    }
    
    class func colorHexString(resourceId: String?) -> String? {
        var colorHexString = ""
        return ""
        guard let colorsPlistPath = Bundle.main.path(forResource:Constants.Plist.COLORS_PLIST, ofType: Constants.Plist.TYPE_PLIST)
            else {
                fatalError("Cannot get Colors from info.plist")
        }
        if (colorsPlistPath.count) > 0 {
            let colorsDictionary = NSDictionary(contentsOfFile: colorsPlistPath )
            colorHexString = colorsDictionary![resourceId] as! String
        }
        
        if colorHexString.hasPrefix("$$@@") {
            guard  let filename = Bundle.main.object(forInfoDictionaryKey: "ColorsConfigfile") as? String
                else {
                    fatalError("Cannot get Colors from info.plist")
            }
            guard  let configPlistPath = Bundle.main.path(forResource: filename, ofType: Constants.Plist.TYPE_PLIST)
                else {
                    fatalError("Cannot get Colors from info.plist")
            }
            if (configPlistPath.count) > 0 {
                colorHexString = NSDictionary(contentsOfFile: configPlistPath )![resourceId as! String] as! String
            }
        }
        return colorHexString
    }
    class func stringResourceForId(resourceId: String?) -> String? {
        var string = ""
        guard let stringsPlistPath = Bundle.main.path(forResource:Constants.Plist.STRINGS_PLIST, ofType: Constants.Plist.TYPE_PLIST)
            else {
                fatalError("Cannot get strings from info.plist")
        }
        if (stringsPlistPath.count) > 0 {
            let stringDictionary = NSDictionary(contentsOfFile: stringsPlistPath )
            string = stringDictionary![resourceId] as! String
        }
        
        if string.hasPrefix("$$@@") {
            guard  let filename = Bundle.main.object(forInfoDictionaryKey: "StringsConfigfile") as? String
                else {
                    fatalError("Cannot get strings from info.plist")
            }
            guard  let configPlistPath = Bundle.main.path(forResource: filename, ofType: Constants.Plist.TYPE_PLIST)
                else {
                    fatalError("Cannot get strings from info.plist")
            }
            if (configPlistPath.count) > 0 {
                string = NSDictionary(contentsOfFile: configPlistPath )![resourceId as! String] as! String
            }
        }
        return string
    }
}

