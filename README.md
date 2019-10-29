# Screen-Recording-Notifier
This project helps you to identify when user is recording the screen. It also has a control to show user touches. Written entirely in Swift and light weight since it is based on NotificationCenter .




Intialize the Files as below 

        let screenRecordingNotifier = ScreenRecordingNotifier.shared
        screenRecordingNotifier.shouldShowTouch = true
        screenRecordingNotifier.configure(inWindow: self.window)
        
self.window is the key window of your application.


Change the touch indication View UI using 'touchIndicationViewConstants'

     screenRecordingNotifier.touchIndicationViewConstants = TouchIndicationViewConstants.init(width: 50, height: 50, cornerRadius: 25, backGroundColor: .red, initialViewAlpha: 1)


In Order to receive notification when screen recording starts just add following code in your viewcontroller where you want to receive notification

    NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStarted(notification:)), name: NSNotification.Name(rawValue: ScreenRecordingNotifier.ScreenRecordingStartedNotification) , object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingEnded), name:   NSNotification.Name(rawValue: ScreenRecordingNotifier.ScreenRecordingEndedNotification) , object: nil)
    
     @objc private func screenRecordingStarted(notification: NSNotification){
        
        print("Recording Started")
        //do stuff using the userInfo property of the notification object
    }
    
    @objc private func screenRecordingEnded(notification: NSNotification){
        print("Recording Ended")
        //do stuff using the userInfo property of the notification object
    }
