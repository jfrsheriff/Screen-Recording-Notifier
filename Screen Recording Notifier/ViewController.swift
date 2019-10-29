//
//  ViewController.swift
//  Screen Recording Notifier
//
//  Created by Jaffer Sheriff U on 29/10/19.
//  Copyright © 2019 Jaffer Sheriff U. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStarted(notification:)), name: NSNotification.Name(rawValue: ScreenRecordingNotifier.ScreenRecordingStartedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingEnded), name: NSNotification.Name(rawValue: ScreenRecordingNotifier.ScreenRecordingEndedNotification) , object: nil)
        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func screenRecordingStarted(notification: NSNotification){
        
        print("Recording Started")
        //do stuff using the userInfo property of the notification object
    }
    
    @objc private func screenRecordingEnded(notification: NSNotification){
        print("Recording Ended")
        //do stuff using the userInfo property of the notification object
    }


}

