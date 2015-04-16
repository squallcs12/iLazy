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
            if error != nil && error.domain == "NSURLErrorDomain" {
                return;
            }

            var response = response as! NSHTTPURLResponse
            var data: NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as! NSDictionary)
            if response.statusCode == 403 {
                Client.isLogin = false
                println("Show login box")
                return
            } else if response.statusCode == 401 {
                let error = data.objectForKey("error") as! String!
                if error != nil && error == "invalid_grant" {
                    Locksmith.deleteDataForUserAccount("myUserAccount")
                    Alert.hideLoading(){
                        let loginViewController = Static.delegate!.window!.rootViewController as! LoginViewController
                        loginViewController.tabBarContrl?.performSegueWithIdentifier("showLoginForm", sender: API())
                    }
                    return
                }
                Client.accessToken = ""
                API.refreshToken(){
                    data, response, error in
                    API.saveLoginData(data)
                    API.request(request, completionHandler: handler)
                }
                return
            }
            handler(data, response, error)
        }
        task.resume()
    }

    class func refreshToken(completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/o/token/"))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let loginString = NSString(format: "%@:%@", Client.clientId, Client.clientSecret)
        let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let data = "grant_type=refresh_token&refresh_token=\(Client.refreshToken)"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)

        self.request(request, completionHandler: handler)
    }

    class func fetchApps(completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/api/apps/"))
        let request = NSMutableURLRequest(URL: url!)
        self.request(request, completionHandler: handler)
    }

    class func myApps(completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/api/my_apps/"))
        let request = NSMutableURLRequest(URL: url!)
        self.request(request, completionHandler: handler)
    }

    class func searchApps(keyword: String, completionHandler handler: (NSDictionary!, NSHTTPURLResponse!, NSError!) -> Void){
        let url = NSURL(string: self.getUrl("/api/apps/?site=\(keyword)"))
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

        let postData = "grant_type=password&username=\(username)&password=\(password)"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)

        func loginSuccess(data: NSDictionary!, response: NSHTTPURLResponse!, error: NSError!){
            if let error = data.objectForKey("error") as! String!{
            } else {
                API.saveLoginData(data)
            }
            handler(data, response, error)
        }

        self.request(request, completionHandler: loginSuccess)
    }

    class func saveLoginData(data: NSDictionary){
        Client.accessToken = data.objectForKey("access_token") as! String!
        Client.refreshToken = data.objectForKey("refresh_token") as! String!
        Client.tokenType = data.objectForKey("token_type") as! String!
        Locksmith.deleteDataForUserAccount("myUserAccount")
        let error = Locksmith.saveData([
            "access_token": Client.accessToken,
            "refresh_token": Client.refreshToken,
            "token_type": Client.tokenType
            ], forUserAccount: "myUserAccount")
    }


}