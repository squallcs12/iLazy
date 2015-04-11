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
    static var host = "localhost:8000"
    static var schema = "http"
    static var isLogin = false
    static var clientId = "zgYQBHM7AoqtNwRhEuQw6OlbPwtR3geV9EjnLWDf"
    static var clientSecret = "KVnKb9Oh6397LcuUKwdmLjbyeu3PNRFZH8OvtAR5UJ0ew1XmXNYTty45RnZxHl51I1QmkrxFaw727ACX6KCVkZuplMmlsYWjC0QUr99tyqdtU5czUbqrqWpPzwiC5qwe"
    static var accessToken = ""
    static var refreshToken = ""
    static var tokenType = ""
}


class API{

    class func getUrl(url: NSString) -> String{
        return "\(Client.schema)://\(Client.host)\(url)";
    }

    class func request(request: NSMutableURLRequest, completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        if Client.accessToken != "" {
            request.setValue("\(Client.tokenType) \(Client.accessToken)", forHTTPHeaderField: "Authorization")
        }
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
        let request = NSMutableURLRequest(URL: url!)
        self.request(request, completionHandler: handler)
    }

    class func login(username: NSString, password: NSString, completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/o/token/"))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        let loginString = NSString(format: "%@:%@", Client.clientId, Client.clientSecret)
        let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let data = "grant_type=password&username=\(username)&password=\(password)"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.request(request, completionHandler: handler)
    }
}