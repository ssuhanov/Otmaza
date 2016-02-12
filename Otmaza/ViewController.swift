//
//  ViewController.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 05.02.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var blurTimer = NSTimer()
    let blurTimerPeriod = 0.01
    
    var blurEffectView = UIVisualEffectView()
    var blurAlpha: CGFloat = 0.0
    
    var content = [String]()
    
    var imgNumber = -1
    var otmazaNumber = -1
    
    let maxOtmazaNumber: UInt32 = 612
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fileUrl = NSBundle.mainBundle().URLForResource("Content", withExtension: "plist") {
            if let array = NSArray(contentsOfURL: fileUrl) {
                content = array as! [String]
            }
        }
        setBlur()
        showRandomBackgroundAndOtmaza()
    }
    
    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBackgroundAndOtmaza()
    }
    
    func showRandomBackgroundAndOtmaza() {
        setImage()
        setOtmaza()
        updateBlur()
    }
    
    // MARK: - Image and blur
    func setBlur() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.0
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func setImage() {
        imgNumber = getAnotherRandomNumber(imgNumber, maxValue: 7)
        let bgImage = UIImage(named: "Pic\(imgNumber)")
        backgroundImageView.image = bgImage
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
    
    // MARK: - Find otmaza
    func setOtmaza() {
        var newOtmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: maxOtmazaNumber)
        var otmaza = getOtmaza(newOtmazaNumber)
        while otmaza.isEmpty {
            newOtmazaNumber = getAnotherRandomNumber(newOtmazaNumber, maxValue: maxOtmazaNumber)
            otmaza = getOtmaza(newOtmazaNumber)
        }
        otmazaNumber = newOtmazaNumber
        print(otmazaNumber)
        otmazaTextLabel.text = otmaza
    }
    
    func getOtmaza(number: Int) -> String {
        // let find otmaza in core data first
        if let resultFromCoreData = findInCoreData(number) {
            return resultFromCoreData
        }
        
        guard let url = NSURL(string: "http://copout.me/get-excuse/\(number)"),
            let myData = NSData(contentsOfURL: url),
            let myString = String(data: myData, encoding: NSUTF8StringEncoding) else {
                return ""
        }
        
        let resultStart = myString.rangeOfString("<blockquote>")
        let resultFinish = myString.rangeOfString("</blockquote>")
        
        guard let myRangeStart = resultStart,
            let myRangeFinish = resultFinish else {
                saveToCoreData(number, text: "")
                return ""
        }
        
        let resultString = myString[myRangeStart.endIndex..<myRangeFinish.startIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("&quot;", withString: "\"").stringByReplacingOccurrencesOfString("<br>", withString: "\n")
        
        saveToCoreData(number, text: resultString)
        return resultString
    }
    
    func findInCoreData(id: Int) -> String? {
        let fetchRequest = NSFetchRequest(entityName: "Otmaza")
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext         {
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                let otmazas = results as! [Otmaza]
                for elementOfOtmazas in otmazas {
                    if elementOfOtmazas.id == id {
                        return elementOfOtmazas.text
                    }
                }
            } catch {
                print(error)
                return nil
            }
    }
    return nil
}

func saveToCoreData(id: Int, text: String) {
    if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
        let otmaza: Otmaza = NSEntityDescription.insertNewObjectForEntityForName("Otmaza", inManagedObjectContext: managedObjectContext) as! Otmaza
        otmaza.id = id
        otmaza.text = text
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

func getAnotherRandomNumber(prevNumber: Int, maxValue: UInt32) -> Int {
    var result = Int(arc4random_uniform(maxValue))
    if prevNumber != -1 {
        while result == prevNumber || result == otmazaNumber {
            result = Int(arc4random_uniform(maxValue))
        }
    }
    return result
}

}

