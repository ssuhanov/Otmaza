//
//  ViewController.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 05.02.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import UIKit
import CoreData

let kRunsCount = "kRunsCount"

class ViewController: UIViewController {
    var blurTimer = NSTimer()
    let blurTimerPeriod = 0.01
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    var blurEffectView = UIVisualEffectView()
    var blurAlpha: CGFloat = 0.0
    
    var imgNumber = -1
    var otmazaNumber = -1
    
    let maxOtmazaNumber: UInt32 = 612
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        
        processFirstRun()
        performSelector("setBlur", withObject: nil, afterDelay: 0.01)
        performSelector("showRandomBackgroundAndOtmaza", withObject: nil, afterDelay: 0.02)
    }
    
    func processFirstRun() {
        var runsCount = NSUserDefaults.standardUserDefaults().integerForKey(kRunsCount)
        NSUserDefaults.standardUserDefaults().setInteger(++runsCount, forKey: kRunsCount)
        if runsCount == 1 {
            fillSomeOtmazasToCoreData()
        }
    }
    
    func fillSomeOtmazasToCoreData() {
        saveOtmazaToCoreData(386, text: "С УТРА, Когда чистил зубы, выдавил много пасты и долго запихивал её обратно")
        saveOtmazaToCoreData(589, text: "Лень - это гармония, когда душа не хочет, а тело не делает.")
        saveOtmazaToCoreData(137, text: "Я сейчас не в стране, мне не очень удобно разговаривать. Вернусь через 2 недели, сразу же позвоню вам сам")
        saveOtmazaToCoreData(600, text: "Я опоздал, потому что сломался холодильник, из которого вытекла вода и затопила будильник")
        saveOtmazaToCoreData(501, text: "Я опоздал на работу потому, что кто-то ночью закрыл в подъезде закон притяжения. Пришлось ждать, пока его снова откроют.")
        saveOtmazaToCoreData(8, text: "Ворона украла флешку")
        saveOtmazaToCoreData(115, text: "Установила последнее обновление Линукса - теперь ничего не работает. Да-да, и интернет не работает. И браузеры. Буду весь день разбираться.")
        saveOtmazaToCoreData(438, text: "в google maps слетела метка и я пришел не туда, позвонил в мчс и меня доставили прямо к дверям офиса, слава шойгу!")
        saveOtmazaToCoreData(341, text: "Системная ошибка в нашей системе. Систематизируем правки системы. А что вы хотели, автоматизация, роботы!")
        saveOtmazaToCoreData(344, text: "мЕНЯ СРОЧНО ВЫЗЫВАЕТ УМИРАЮЩАЯ ТЕТУШКА ИЗ оДЕССЫ ПО ПОВОДУ НАСЛЕДСТВА. изВИНИТЕ МЕНЯ, НО РОДСТВЕННИКИ МНЕ ДОРОЖЕ!!!")
    }
    
    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBackgroundAndOtmaza()
    }
    
    @IBAction func openUrlButton(sender: AnyObject) {
//        if let url = NSURL(string: "http://copout.me/get-excuse/\(otmazaNumber)") {
        if let url = NSURL(string: "http://copout.me") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func showRandomBackgroundAndOtmaza() {
        otmazaTextLabel.text = ""
        showSpinner()
        AppDelegate().operationQueue.addOperationWithBlock() {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.setImage()
                self.updateBlur()
                self.setOtmaza()
                self.spinner.stopAnimating()
            }
        }
    }
    
    func showSpinner() {
        let kScreenSize = view.frame.size
        let kScreenWidth = kScreenSize.width
        let kScreenHeight = kScreenSize.height
        spinner.center = CGPoint(x: kScreenWidth/2.0, y: kScreenHeight/2.0)
        spinner.startAnimating()
    }
    // MARK: - Image and blur
    func setBlur() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = view.frame
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
        otmazaTextLabel.text = otmaza.uppercaseString
    }
    
    func getOtmaza(number: Int) -> String {
        // let find otmaza in core data first
        if let resultFromCoreData = findOtmazaInCoreData(number) {
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
                saveOtmazaToCoreData(number, text: "")
                return ""
        }
        
        let resultString = myString[myRangeStart.endIndex..<myRangeFinish.startIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("&quot;", withString: "\"").stringByReplacingOccurrencesOfString("<br>", withString: "\n")
        
        saveOtmazaToCoreData(number, text: resultString)
        return resultString
    }
    
    func findOtmazaInCoreData(id: Int) -> String? {
        let fetchRequest = NSFetchRequest(entityName: "Otmaza")
        let predicate = NSPredicate(format: "id == %i", id)
        fetchRequest.predicate = predicate
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext         {
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                let otmazas = results as! [Otmaza]
                if otmazas.count > 0 {
                    return otmazas[0].text
                } else {
                    return ""
                }
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func saveOtmazaToCoreData(id: Int, text: String) {
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

