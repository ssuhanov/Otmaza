//
//  ViewController.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 05.02.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blurTimer = NSTimer()
    let blurTimerPeriod = 0.01
    
    var blurEffectView = UIVisualEffectView()
    var blurAlpha: CGFloat = 0.0
    
    var content = [String]()
    
    var imgNumber = -1
    var otmazaNumber = -1

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fileUrl = NSBundle.mainBundle().URLForResource("Content", withExtension: "plist") {
            if let array = NSArray(contentsOfURL: fileUrl) {
                content = array as! [String]
            }
        }
        showRandomBG()
    }
    
    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBG()
    }
    
    func showRandomBG() {
        setImage()
        setOtmaza()
        setBlur()
    }
    
    func setImage() {
        imgNumber = getAnotherRandomNumber(imgNumber, maxValue: 7)
        let bgImage = UIImage(named: "Pic\(imgNumber)")
        backgroundImageView.image = bgImage
    }
    
    func setOtmaza() {
        otmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: 7)
        otmazaTextLabel.text = content[otmazaNumber]
        
    }
    
    func setBlur() {
        blurEffectView.removeFromSuperview()
        blurAlpha = 0.0
        blurTimer.invalidate()
        blurTimer = NSTimer.scheduledTimerWithTimeInterval(blurTimerPeriod, target: self, selector: "changeBlur", userInfo: nil, repeats: true)
    }
    
    func changeBlur() {
        blurAlpha += 0.01
        if blurAlpha > 1.0 {
            blurAlpha = 0.0
            blurTimer.invalidate()
            return
        }
        blurEffectView.removeFromSuperview()
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = blurAlpha
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func getAnotherRandomNumber(prevNumber: Int, maxValue: UInt32) -> Int {
        var result = Int(arc4random_uniform(maxValue))
        if prevNumber != -1 {
            while result == prevNumber {
                result = Int(arc4random_uniform(7))
            }
        }
        return result
    }
}

