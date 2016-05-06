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
    
    var blurEffectView = UIVisualEffectView()
    let blurTimer: NSTimeInterval = 2.0
    
    var imgNumber = -1
    var otmazaNumber = -1
    
    let maxOtmazaNumberEN: UInt32 = 560
    let maxOtmazaNumberRU: UInt32 = 613
    
    @IBOutlet weak var spinnerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    @IBOutlet weak var nextOtmazaButtonOutlet: UIButton!
    @IBOutlet weak var openURLButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processFirstRun()
        performSelector(#selector(ViewController.setBlur), withObject: nil, afterDelay: 0.01)
        performSelector(#selector(ViewController.showRandomBackgroundAndOtmaza), withObject: nil, afterDelay: 0.02)
    }
    
    func processFirstRun() {
        var runsCount = NSUserDefaults.standardUserDefaults().integerForKey(kRunsCount)
        runsCount += 1
        NSUserDefaults.standardUserDefaults().setInteger(runsCount, forKey: kRunsCount)
        if runsCount == 1 {
            fillSomeOtmazasToCoreData()
        }
    }
    
    func fillSomeOtmazasToCoreData() {
        //save EN otmazas
        saveOtmazaToCoreData(76, text: "A close family member was in a car accident. I don't know if its serious or not, but just couldn't concentrate at work unless go check on them", localization: "EN")
        saveOtmazaToCoreData(65, text: "I was depressed cause i’ve seen dollar’s exchange rate", localization: "EN")
        saveOtmazaToCoreData(553, text: "i did not have it in my agenda!", localization: "EN")
        saveOtmazaToCoreData(87, text: "Injured myself during sex and I can barely move", localization: "EN")
        saveOtmazaToCoreData(88, text: "I woke up and somehow thought today was Sunday", localization: "EN")
        saveOtmazaToCoreData(330, text: "I moved to another house yesterday. had no time to inform you", localization: "EN")
        saveOtmazaToCoreData(82, text: "I am trying to be less popular. Someone has got to do it!", localization: "EN")
        saveOtmazaToCoreData(81, text: "My neighbor called - the water pipes \"broke\" and basement is flooding. Got to get home ASAP, sorry!", localization: "EN")
        saveOtmazaToCoreData(89, text: "My hair dye went horribly wrong. I don’t want to show up like a hippie", localization: "EN")
        saveOtmazaToCoreData(86, text: "My trousers split on a way to work", localization: "EN")
        
        //save RU otmazas
        saveOtmazaToCoreData(386, text: "С УТРА, Когда чистил зубы, выдавил много пасты и долго запихивал её обратно", localization: "RU")
        saveOtmazaToCoreData(589, text: "Лень - это гармония, когда душа не хочет, а тело не делает.", localization: "RU")
        saveOtmazaToCoreData(137, text: "Я сейчас не в стране, мне не очень удобно разговаривать. Вернусь через 2 недели, сразу же позвоню вам сам", localization: "RU")
        saveOtmazaToCoreData(600, text: "Я опоздал, потому что сломался холодильник, из которого вытекла вода и затопила будильник", localization: "RU")
        saveOtmazaToCoreData(501, text: "Я опоздал на работу потому, что кто-то ночью закрыл в подъезде закон притяжения. Пришлось ждать, пока его снова откроют.", localization: "RU")
        saveOtmazaToCoreData(8, text: "Ворона украла флешку", localization: "RU")
        saveOtmazaToCoreData(115, text: "Установила последнее обновление Линукса - теперь ничего не работает. Да-да, и интернет не работает. И браузеры. Буду весь день разбираться.", localization: "RU")
        saveOtmazaToCoreData(438, text: "в google maps слетела метка и я пришел не туда, позвонил в мчс и меня доставили прямо к дверям офиса, слава шойгу!", localization: "RU")
        saveOtmazaToCoreData(341, text: "Системная ошибка в нашей системе. Систематизируем правки системы. А что вы хотели, автоматизация, роботы!", localization: "RU")
        saveOtmazaToCoreData(344, text: "мЕНЯ СРОЧНО ВЫЗЫВАЕТ УМИРАЮЩАЯ ТЕТУШКА ИЗ оДЕССЫ ПО ПОВОДУ НАСЛЕДСТВА. изВИНИТЕ МЕНЯ, НО РОДСТВЕННИКИ МНЕ ДОРОЖЕ!!!", localization: "RU")
    }
    
    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBackgroundAndOtmaza()
    }
    
    @IBAction func openUrlButton(sender: AnyObject) {
        if let url = NSURL(string: NSLocalizedString("http://copout.me/en", comment: "")) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func showRandomBackgroundAndOtmaza() {
        otmazaTextLabel.text = ""
        showSpinner()
        setImage()
        updateBlur()
        
        let mainQ = dispatch_get_main_queue()
        let newQ = dispatch_queue_create("newQ", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(newQ) { () -> Void in
            let currOtmaza = self.setOtmaza()
            dispatch_async(mainQ, { () -> Void in
                self.otmazaTextLabel.text = currOtmaza
                self.stopSpinner()
            })
        }
    }
    
    func showSpinner() {
        spinnerActivityIndicator.startAnimating()
        doButtonsEnabled(false)
    }
    
    func stopSpinner() {
        spinnerActivityIndicator.stopAnimating()
        doButtonsEnabled(true)
    }
    
    func doButtonsEnabled(enabled: Bool) {
        nextOtmazaButtonOutlet.enabled = enabled
        openURLButtonOutlet.enabled = enabled
    }
    
    // MARK: - Image and blur
    func setBlur() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.0
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func setImage() {
        imgNumber = getAnotherRandomNumber(imgNumber, maxValue: 16)
        let bgImage = UIImage(named: "Pic\(imgNumber)")
        backgroundImageView.image = bgImage
    }
    
    func updateBlur() {
        blurEffectView.alpha = 0.0
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        UIView.animateWithDuration(blurTimer) { () -> Void in
            self.blurEffectView.alpha = 1.0
        }
    }
    
    // MARK: - Find otmaza
    func setOtmaza() -> String {
        var maxOtmazaNumber = maxOtmazaNumberEN
        if NSLocalizedString("EN", comment: "") != "EN" {
            maxOtmazaNumber = maxOtmazaNumberRU
        }
        var newOtmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: maxOtmazaNumber)
        var otmaza = getOtmaza(newOtmazaNumber)
        while otmaza.isEmpty {
            newOtmazaNumber = getAnotherRandomNumber(newOtmazaNumber, maxValue: maxOtmazaNumber)
            otmaza = getOtmaza(newOtmazaNumber)
        }
        otmazaNumber = newOtmazaNumber
        return otmaza.uppercaseString
    }
    
    func getOtmaza(number: Int) -> String {
        // let find otmaza in core data first
        if let resultFromCoreData = findOtmazaInCoreData(number) {
            return resultFromCoreData
        }
        
        guard let url = NSURL(string: NSLocalizedString("http://copout.me/en", comment: "")+"/get-excuse/\(number)"),
            let myData = NSData(contentsOfURL: url),
            let myString = String(data: myData, encoding: NSUTF8StringEncoding) else {
                return ""
        }
        
        let resultStart = myString.rangeOfString("<blockquote>")
        let resultFinish = myString.rangeOfString("</blockquote>")
        
        guard let myRangeStart = resultStart,
            let myRangeFinish = resultFinish else {
//                saveOtmazaToCoreData(number, text: "", localization: NSLocalizedString("EN", comment: ""))
                return ""
        }
        
        let resultString = myString[myRangeStart.endIndex..<myRangeFinish.startIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("&quot;", withString: "\"").stringByReplacingOccurrencesOfString("<br>", withString: "\n")
        
        saveOtmazaToCoreData(number, text: resultString, localization: NSLocalizedString("EN", comment: ""))
        return resultString
    }
    
    func findOtmazaInCoreData(id: Int) -> String? {
        let fetchRequest = NSFetchRequest(entityName: "Otmaza")
        let predicate = NSPredicate(format: "id == %i AND localization == %@", id, NSLocalizedString("EN", comment: ""))
        fetchRequest.predicate = predicate
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext         {
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                let otmazas = results as! [Otmaza]
                if otmazas.count > 0 {
                    return otmazas[0].text
                } else {
                    return nil
                }
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func saveOtmazaToCoreData(id: Int, text: String, localization: String) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let otmaza: Otmaza = NSEntityDescription.insertNewObjectForEntityForName("Otmaza", inManagedObjectContext: managedObjectContext) as! Otmaza
            otmaza.id = id
            otmaza.text = text
            otmaza.localization = localization
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func getAnotherRandomNumber(prevNumber: Int, maxValue: UInt32) -> Int {
        var result = arc4random_uniform(maxValue)
        if result >= maxValue {
            result = maxValue
        }
        if prevNumber != -1 {
            while Int(result) == prevNumber || Int(result) == otmazaNumber {
                result = arc4random_uniform(maxValue)
                if result >= maxValue {
                    result = maxValue
                }
            }
        }
        return Int(result)
    }
    
}

