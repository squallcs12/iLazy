//
//  Api.swift
//  iLazy
//
//  Created by East Agile on 4/9/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import Foundation

public struct Client{
    static var session = NSURLSession.sharedSession()
    static var HOST = "http://localhost:8000"
    static var isLogin = false
}


class API{

    class func getUrl(url: NSString) -> String{
        return "\(Client.HOST)\(url)";
    }

    class func request(request: NSURLRequest, completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        
        var task = Client.session.dataTaskWithRequest(request){
            data, response, error in
            var response = response as! NSHTTPURLResponse
            var data: NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as! NSDictionary)
            if response.statusCode == 403 {
                Client.isLogin = false
                println("Show login box")
                return
            }
            handler(data, response, error)
        }
        task.resume()
    }

    class func fetchApps(completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void, errorHandler eHandler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/api/apps/"))
        let request = NSURLRequest(URL: url!)
        self.request(request, completionHandler: handler)
    }

    class func login(username: NSString, password: NSString, completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/api/login/"))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let data = "username=\(username)&password=\(password)"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.request(request, completionHandler: handler)
    }
}