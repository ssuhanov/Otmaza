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
let kRunsCountLocal = "kRunsCountLocal"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        processFirstRun()
        processDataBaseMigrate()
        performSelector(#selector(ViewController.setBlur), withObject: nil, afterDelay: 0.01)
        performSelector(#selector(ViewController.showRandomBackgroundAndOtmaza), withObject: nil, afterDelay: 0.02)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var spinnerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    @IBOutlet weak var nextOtmazaButtonOutlet: UIButton!
    @IBOutlet weak var openURLButtonOutlet: UIButton!
    
    // MARK: - Variables
    
    var blurEffectView = UIVisualEffectView()
    let blurTimer: NSTimeInterval = 2.0
    
    var imgNumber = -1
    var otmazaNumber = -1
    
    let maxImgNumber: UInt32 = 16
    let maxOtmazaNumber: UInt32 = 1000
    
    // MARK: - Interface methods
    
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
    
    func setBlur() {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.0
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func setImage() {
        imgNumber = getAnotherRandomNumber(imgNumber, maxValue: maxImgNumber)
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
    
    func showRandomBackgroundAndOtmaza() {
        otmazaTextLabel.text = ""
        showSpinner()
        setImage()
        updateBlur()
        
        let mainQueue = dispatch_get_main_queue()
        let queueForGetOtmaza = dispatch_queue_create("queueForGetOtmaza", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(queueForGetOtmaza) { () -> Void in
            let currOtmaza = self.setOtmaza()
            dispatch_async(mainQueue, { () -> Void in
                self.otmazaTextLabel.text = currOtmaza
                self.stopSpinner()
            })
        }
    }

    // MARK: - First run methods
    
    func processFirstRun() {
        var runsCount = NSUserDefaults.standardUserDefaults().integerForKey(kRunsCount)
        runsCount += 1
        NSUserDefaults.standardUserDefaults().setInteger(runsCount, forKey: kRunsCount)
        if runsCount == 1 {
            fillSomeOtmazasToLocalDB_RU()
            fillSomeOtmazasToLocalDB_EN()
        }
    }
    
    func processDataBaseMigrate() {
        var runsCountLocal = NSUserDefaults.standardUserDefaults().integerForKey(kRunsCountLocal)
        runsCountLocal += 1
        NSUserDefaults.standardUserDefaults().setInteger(runsCountLocal, forKey: kRunsCountLocal)
        if runsCountLocal == 1 {
            fixOldOtmazasInCoreData()
            fillSomeOtmazasToLocalDB_EN()
        }
    }
    
    func fixOldOtmazasInCoreData() {
//        let fetchRequest = NSFetchRequest(entityName: "Otmaza")
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            do {
//                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
//                let otmazas = results as! [NSManagedObject]
//                for otmaza in otmazas {
//                    if (otmaza.valueForKey("local") == nil) {
//                        otmaza.setValue("RU", forKey: "local")
//                        do {
//                            try managedObjectContext.save()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//            } catch {
//                print(error)
//            }
//        }
    }
    
    func fillSomeOtmazasToLocalDB_RU() {
        createOtmazaInLocalDB(386, text: "С УТРА, Когда чистил зубы, выдавил много пасты и долго запихивал её обратно", local: "RU")
        createOtmazaInLocalDB(589, text: "Лень - это гармония, когда душа не хочет, а тело не делает.", local: "RU")
        createOtmazaInLocalDB(137, text: "Я сейчас не в стране, мне не очень удобно разговаривать. Вернусь через 2 недели, сразу же позвоню вам сам", local: "RU")
        createOtmazaInLocalDB(600, text: "Я опоздал, потому что сломался холодильник, из которого вытекла вода и затопила будильник", local: "RU")
        createOtmazaInLocalDB(501, text: "Я опоздал на работу потому, что кто-то ночью закрыл в подъезде закон притяжения. Пришлось ждать, пока его снова откроют.", local: "RU")
        createOtmazaInLocalDB(8, text: "Ворона украла флешку", local: "RU")
        createOtmazaInLocalDB(115, text: "Установила последнее обновление Линукса - теперь ничего не работает. Да-да, и интернет не работает. И браузеры. Буду весь день разбираться.", local: "RU")
        createOtmazaInLocalDB(438, text: "в google maps слетела метка и я пришел не туда, позвонил в мчс и меня доставили прямо к дверям офиса, слава шойгу!", local: "RU")
        createOtmazaInLocalDB(341, text: "Системная ошибка в нашей системе. Систематизируем правки системы. А что вы хотели, автоматизация, роботы!", local: "RU")
        createOtmazaInLocalDB(344, text: "мЕНЯ СРОЧНО ВЫЗЫВАЕТ УМИРАЮЩАЯ ТЕТУШКА ИЗ оДЕССЫ ПО ПОВОДУ НАСЛЕДСТВА. изВИНИТЕ МЕНЯ, НО РОДСТВЕННИКИ МНЕ ДОРОЖЕ!!!", local: "RU")
    }
    
    func fillSomeOtmazasToLocalDB_EN() {
        createOtmazaInLocalDB(247, text: "It's not a bug, it's a feature.", local: "EN")
        createOtmazaInLocalDB(65, text: "I was depressed cause i’ve seen dollar’s exchange rate", local: "EN")
        createOtmazaInLocalDB(553, text: "i did not have it in my agenda!", local: "EN")
        createOtmazaInLocalDB(87, text: "Injured myself during sex and I can barely move", local: "EN")
        createOtmazaInLocalDB(88, text: "I woke up and somehow thought today was Sunday", local: "EN")
        createOtmazaInLocalDB(330, text: "I moved to another house yesterday. had no time to inform you", local: "EN")
        createOtmazaInLocalDB(82, text: "I am trying to be less popular. Someone has got to do it!", local: "EN")
        createOtmazaInLocalDB(81, text: "My neighbor called - the water pipes \"broke\" and basement is flooding. Got to get home ASAP, sorry!", local: "EN")
        createOtmazaInLocalDB(89, text: "My hair dye went horribly wrong. I don’t want to show up like a hippie", local: "EN")
        createOtmazaInLocalDB(86, text: "My trousers split on a way to work", local: "EN")
    }
    
    
    // MARK: - Database methods
    
    func setOtmaza() -> String {
        let local = NSLocalizedString("EN", comment: "")
        let otmazasCount = DataStore.defaultLocalDB.getOtmazasCount(local)
        if otmazasCount > 0 {
            var newOtmazaNumber = getAnotherRandomNumber(otmazaNumber, maxValue: otmazasCount-1)
            var otmaza = DataStore.defaultLocalDB.getOtmaza(newOtmazaNumber, local: local)
            while otmaza == nil {
                newOtmazaNumber = getAnotherRandomNumber(newOtmazaNumber, maxValue: otmazasCount-1)
                otmaza = DataStore.defaultLocalDB.getOtmaza(newOtmazaNumber, local: local)
            }
            otmazaNumber = newOtmazaNumber
            return otmaza!.text.uppercaseString
        } else {
            return ""
        }
    }
    
    func createOtmazaInLocalDB(id: Int, text: String, local: String) {
        var inputDictionary = [String:AnyObject]()
        inputDictionary["id"] = NSNumber(integer: id)
        inputDictionary["text"] = text
        inputDictionary["local"] = local
        let otmazaModel = OtmazaModel(inputDictionary: inputDictionary)
        if DataStore.defaultLocalDB.createOtmaza(otmazaModel) {
            
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
    
    // MARK: - Update from site methods
    
    //    func getOtmaza(number: Int) -> String {
    //        // let find otmaza in core data first
    //        if let resultFromCoreData = findOtmazaInCoreData(number) {
    //            return resultFromCoreData
    //        }
    //
    //        guard let url = NSURL(string: NSLocalizedString("http://copout.me/en", comment: "")+"/get-excuse/\(number)"),
    //            let myData = NSData(contentsOfURL: url),
    //            let myString = String(data: myData, encoding: NSUTF8StringEncoding) else {
    //                return ""
    //        }
    //
    //        let resultStart = myString.rangeOfString("<blockquote>")
    //        let resultFinish = myString.rangeOfString("</blockquote>")
    //
    //        guard let myRangeStart = resultStart,
    //            let myRangeFinish = resultFinish else {
    ////                createOtmazaInLocalDB(number, text: "", local: NSLocalizedString("EN", comment: ""))
    //                return ""
    //        }
    //
    //        let resultString = myString[myRangeStart.endIndex..<myRangeFinish.startIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("&quot;", withString: "\"").stringByReplacingOccurrencesOfString("<br>", withString: "\n")
    //
    //        createOtmazaInLocalDB(number, text: resultString, local: NSLocalizedString("EN", comment: ""))
    //        return resultString
    //    }
    
    // MARK: - Actions

    @IBAction func nextOtmazaButton(sender: AnyObject) {
        showRandomBackgroundAndOtmaza()
    }
    
    @IBAction func openUrlButton(sender: AnyObject) {
        if let url = NSURL(string: NSLocalizedString("http://copout.me/en", comment: "")) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
