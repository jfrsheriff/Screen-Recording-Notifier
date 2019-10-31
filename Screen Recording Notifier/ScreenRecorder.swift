//
//  ScreenRecorder.swift
//  Screen Recording Detector and Interaction Highli
//
//  Created by Jaffer Sheriff U on 23/10/19.
//  Copyright © 2019 Jaffer Sheriff U. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass


class ScreenRecordingNotifier {
    
    static let ScreenRecordingStartedNotification = "kScreenRecordingStarted"
    static let ScreenRecordingEndedNotification = "kScreenRecordingEnded"
    
    static let shared = ScreenRecordingNotifier()
    
    var shouldShowTouch : Bool = false
    var touchIndicationViewConstants = TouchIndicationViewConstants.init(width: 100, height: 100, cornerRadius: 50, backGroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5) , initialViewAlpha: 1)
    
    private var isScreenBeingRecorded = false
    
    private lazy var touchIndicationView : TouchIndicationView = {
        let touchIndicationView = TouchIndicationView.init(withTouchIndicationViewConstants: touchIndicationViewConstants)
        return touchIndicationView
    }()
    
    private lazy var tapGestureRecognizer : TapGestureRecognizer = {
        let tapGestureRecognizer = TapGestureRecognizer.init()
        tapGestureRecognizer.cancelsTouchesInView = false
        return tapGestureRecognizer
    }()
    
    private var sourceWindow : UIWindow? = nil
    
    private init() {}
    
    deinit {
        self.removeAllObserverFromSelf()
    }
    
    private func removeAllObserverFromSelf(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure(inWindow window: UIWindow?) {
        self.removeAllObserverFromSelf()
        if #available(iOS 11.0, *) {
            sourceWindow = window
            NotificationCenter.default.addObserver(self, selector: #selector(screeenRecordingStateChanged), name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }
    
    @objc func screeenRecordingStateChanged(){
        if #available(iOS 11.0, *), let window = sourceWindow {
            isScreenBeingRecorded = UIScreen.main.isCaptured
            
            if isScreenBeingRecorded{
                if tapGestureRecognizer.view == nil{
                    window.addGestureRecognizer(tapGestureRecognizer)
                    NotificationCenter.default.post(name: Notification.Name(ScreenRecordingNotifier.ScreenRecordingStartedNotification) , object: nil)
                }
            }else{
                window.removeGestureRecognizer(tapGestureRecognizer)
                 NotificationCenter.default.post(name: Notification.Name(ScreenRecordingNotifier.ScreenRecordingEndedNotification) , object: nil)
            }
        }
    }
    
    fileprivate func shouldShowTouchWhileScreenBeingRecorded() -> Bool {
        return shouldShowTouch && isScreenBeingRecorded
    }
    
    fileprivate func getTouchIndicatorView () -> UIView{
        return touchIndicationView
    }
}

class TapGestureRecognizer: UITapGestureRecognizer {
    
    var shouldShowTouches : Bool {
        get{
            return ScreenRecordingNotifier.shared.shouldShowTouchWhileScreenBeingRecorded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.showTouchIndicatorView(atTouches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.showTouchIndicatorView(atTouches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(removeTouchIndicationView), object: nil)
        self.perform(#selector(removeTouchIndicationView), with: nil, afterDelay: 0)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(removeTouchIndicationView), object: nil)
        self.perform(#selector(removeTouchIndicationView), with: nil, afterDelay: 0)
    }
    
    override func ignore(_ touch: UITouch, for event: UIEvent) {
    }
    
    @objc fileprivate func showTouchIndicatorView(atTouches touches : Set<UITouch> ){
        
        if shouldShowTouches{
            if let touch =  touches.first {
                let location = touch.location(in: self.view)
                let touchView = ScreenRecordingNotifier.shared.getTouchIndicatorView()
                touchView.alpha = 1.0
                
                touchView.frame = CGRect.init(x: location.x - ( touchView.frame.size.width / CGFloat(2.0) ) , y: location.y - (touchView.frame.size.height / CGFloat(2.0) ) , width: touchView.frame.size.width, height: touchView.frame.size.height)
                
                let isSelfIsTouchView = self.view?.isEqual(touchView) ?? false
                
                if !isSelfIsTouchView{
                    self.view?.addSubview(touchView)
                    self.view?.bringSubviewToFront(touchView)
                }
            }
        }
    }
    
    @objc fileprivate func removeTouchIndicationView() {
        let touchView = ScreenRecordingNotifier.shared.getTouchIndicatorView()
        let animationDuration : Double = TouchIndicationViewConstants.fadingAnimationDuration
        
        UIView.animate(withDuration: animationDuration , animations: {
            touchView.alpha = 0
        }) { (_) in
            NSObject.cancelPreviousPerformRequests(withTarget: touchView, selector: #selector(touchView.removeFromSuperview), object: nil)
            touchView.perform(#selector(touchView.removeFromSuperview), with: nil, afterDelay: animationDuration)
        }
    }
}


class TouchIndicationView: UIView {
    
    init(withTouchIndicationViewConstants touchIndicationViewConstants: TouchIndicationViewConstants) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: touchIndicationViewConstants.width, height: touchIndicationViewConstants.height))
        self.layer.cornerRadius = touchIndicationViewConstants.cornerRadius
        self.backgroundColor = touchIndicationViewConstants.backGroundColor
        self.alpha = touchIndicationViewConstants.initialViewAlpha
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct TouchIndicationViewConstants {
    let width : CGFloat
    let height : CGFloat
    let cornerRadius : CGFloat
    
    let backGroundColor : UIColor
    let initialViewAlpha : CGFloat
    
    static let fadingAnimationDuration : Double = 0.5
}
