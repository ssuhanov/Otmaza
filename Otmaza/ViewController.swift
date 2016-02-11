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
    
    // MARK: - Start view
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fileUrl = NSBundle.mainBundle().URLForResource("Content", withExtension: "plist") {
            if let array = NSArray(contentsOfURL: fileUrl) {
                content = array as! [String]
            }
        }
        setBlur()
        showRandomBG()
    }
    
    func setBlur() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.0
        backgroundImageView.addSubview(blurEffectView)
    }

    // MARK: - Next Otmaza
    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBG()
    }
    
    func showRandomBG() {
        setImage()
        setOtmaza()
        updateBlur()
    }
    
    func setImage() {
        imgNumber = getAnotherRandomNumber(imgNumber, maxValue: 7)
        let bgImage = UIImage(named: "Pic\(imgNumber)")
        backgroundImageView.image = bgImage
    }
    
    func setOtmaza() {
        otmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: 400)
        if var otmaza = getOtmaza(otmazaNumber) {
            while otmaza.containsString("Клиент ничего не заподозрит") || otmaza.containsString("Не трать время еще и на генерирование отмазки") || otmaza.containsString("Генератор отмазок поможет выйти сухим из воды") {
                otmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: 400)
                if let anewOtmaza = getOtmaza(otmazaNumber) {
                    otmaza = anewOtmaza
                } else {
                    break
                }
            }
            print(otmazaNumber)
            otmazaTextLabel.text = otmaza
        } else {
            otmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: 7)
            otmazaTextLabel.text = content[otmazaNumber]
        }
    }
    
    func getOtmaza(number: Int) -> String? {
        guard let url = NSURL(string: "http://copout.me/get-excuse/\(number)"),
            let myData = NSData(contentsOfURL: url),
            let myString = String(data: myData, encoding: NSUTF8StringEncoding) else {
                return nil
        }
        
        let resultStart = myString.rangeOfString("<meta property=\"og:description\" content=\"")
        let resultFinish = myString.rangeOfString("<meta property=\"og:url\" content=\"")
        
        guard let myRangeStart = resultStart,
            let myRangeFinish = resultFinish else {
                return nil
        }
        
        let resultString = myString[myRangeStart.endIndex..<myRangeFinish.startIndex.predecessor().predecessor().predecessor()].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("&quot;", withString: "\"")

        return resultString
    }
    
    func getAnotherRandomNumber(prevNumber: Int, maxValue: UInt32) -> Int {
        var result = Int(arc4random_uniform(maxValue))
        if prevNumber != -1 {
            while result == prevNumber {
                result = Int(arc4random_uniform(maxValue))
            }
        }
        return result
    }

    func updateBlur() {
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
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurEffectView.alpha = blurAlpha
    }

}

