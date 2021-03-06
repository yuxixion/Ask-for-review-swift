//
//  ViewController.swift
//  AskForReviewSwift
//
//  Created by yuxi xiong on 5/9/15.
//  Copyright (c) 2015 yuxi xiong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if shouldAskForReviewAtLaunch(){
            reviewRequest()
        }
    }

    

    func shouldAskForReview() -> Bool{
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("KeyDontAsk"){
            return false
        }
        
        var version:NSString?
        if let CurrentVersion = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? NSString{
            version = CurrentVersion
            if let reviewedVersion = defaults.stringForKey("reviewedVersion"){
                if version == reviewedVersion{
                    return false
                }
            }
        }
        
        let currentTime:Double = CFAbsoluteTimeGetCurrent()
        if (defaults.objectForKey("KeyNextTimeToAsk") == nil){
            let nextTime = currentTime + 60*60*23*2   //2 days (minus 2 hours)
            defaults.setDouble(nextTime, forKey: "KeyNextTimeToAsk")
            return false
        }
        
        let nextTime = defaults.doubleForKey("KeyNextTimeToAsk")
        if (currentTime < nextTime){
            return false
        }
        return true
    }
    
    
    func shouldAskForReviewAtLaunch() -> Bool{
        if (!shouldAskForReview()){
            return false
        }
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var count:Int = defaults.integerForKey("KeySessionCountSinceLastAsked")
        defaults.setInteger(count+1, forKey: "KeySessionCountSinceLastAsked")
        
        if(count < 12){
            return false
        }
        
        return true
    }
    
    
    //review request
    func reviewRequest(){
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        var alert = UIAlertController(title: "Enjoying this app?", message: "If so, please rate this update with 5 stars on the App Store so we can keep the free updates coming.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Remind me later", style: UIAlertActionStyle.Cancel, handler: { action in
            switch action.title{
            case "Remind me later":
                println("Remind me later")
                let nextTime = CFAbsoluteTimeGetCurrent() + 60*60*23
                defaults.setDouble(nextTime, forKey: "KeyNextTimeToAsk")
            case "Yes, Rate it":
                println("Yes, Rate it")
                
            case "Don't ask again":
                println("Don't ask again")
                
            default:
                break
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Yes, Rate it", style: UIAlertActionStyle.Default, handler: { action in
            switch action.title{
            case "Remind me later":
                println("Remind me later")
                
            case "Yes, Rate it":
                println("Yes, Rate it")
                //go to the APP URL change the String to your app URL
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/")!)
            case "Don't ask again":
                println("Don't ask again")
                
            default:
                break
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Don't ask again", style: UIAlertActionStyle.Default, handler: { action in
            switch action.title{
            case "Remind me later":
                println("Remind me later")
                
            case "Yes, Rate it":
                println("Yes, Rate it")
                
            case "Don't ask again":
                println("Don't ask again")
                defaults.setBool(true, forKey: "KeyDontAsk")
            default:
                break
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}

