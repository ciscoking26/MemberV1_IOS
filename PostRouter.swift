//
//  PostRouter.swift
//  Medicard
//
//  Created by Al John Albuera on 10/24/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ReachabilitySwift



enum PostRouter: URLRequestConvertible {
    
    //static let baseURLString = "http://104.199.181.64:8080/"
    //public static let baseURLString = "http://10.10.24.195:8080/"
    static var OAuthToken: String?
    
    
    case postRegistration([String: AnyObject])
    case getVerifyMember([String: AnyObject])
    case postLogin([String: AnyObject])
    case getMemberInformation(String)
    case getProfilePhoto(String)
    case getDeletePhoto(String)
    case postAddDependents([String: AnyObject])
    case getMemberInfo(String)
    case postRequestNewPass([String: AnyObject])
    case postChangePassword([String: AnyObject])
    
    
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postRegistration:
            return .post
        case .getVerifyMember:
            return .get
        case .postLogin:
            return .post
        case .getMemberInformation:
            return .get
        case .getProfilePhoto:
            return .get
        case .getDeletePhoto:
            return .delete
        case .postAddDependents:
            return .post
        case .getMemberInfo:
            return .get
        case .postRequestNewPass:
            return .post
        case .postChangePassword:
            return .post

        }
    }
    
    var path: String {
        switch self {
        case .postRegistration:
            return "v2/registerAccount/"
        case .getVerifyMember:
            return "v2/verifyMember/"
        case .postLogin:
            return "v2/loginMember/"
        case .getMemberInformation(let memberID):
            return "v2/viewAccountInfo/\(memberID)"
        case .getProfilePhoto(let memberID):
            return "v2/downloadPicture/\(memberID)"
        case .getDeletePhoto(let memberID):
            return "v2/deletePicture/\(memberID)"
        case .postAddDependents:
            return "v2/addOtherAccount/"
        case .getMemberInfo(let memberID):
            return "v2/getMemberInfo/\(memberID)"
        case .postRequestNewPass:
            return "v2/requestChangePassword/"
        case .postChangePassword:
            return "v2/changePassword/"
        }
    }

           
    func asURLRequest() throws -> URLRequest {
        
        let defaults = UserDefaults.standard
        
        let url = URL(string: defaults.value(forKey: "link1") as! String)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        

        if let token = PostRouter.OAuthToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        
        
        switch self {
            
        case .postRegistration(let register):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: register)
        case .getVerifyMember (let verify):
            return try URLEncoding.queryString.encode(urlRequest, with: verify)
        case .postLogin(let login):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: login)
        case .postAddDependents(let dependents):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: dependents)
        case .postRequestNewPass(let newPassword):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: newPassword)
        case .postChangePassword(let changePassword):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: changePassword)
        default:
            return urlRequest
            
        }
    }
    
}


