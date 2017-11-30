//
//  ViewController.swift
//  FinApp
//
//  Created by Igor Karyi on 19.11.2017.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController {
    
    let popSound = Bundle.main.url(forResource: "00171", withExtension: "mp3")
    var audioPlayer = AVAudioPlayer()

    @IBOutlet var usdBidLabel: UILabel!
    @IBOutlet var usdAskLabel: UILabel!
    
    @IBOutlet var eurBidLabel: UILabel!
    @IBOutlet var eurAskLabel: UILabel!
    
    @IBOutlet var rubBidLabel: UILabel!
    @IBOutlet var rubAskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrencies()
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: popSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        loadCurrencies()
    }
    
    func loadCurrencies() {
        
        Alamofire.request("http://resources.finance.ua/ru/public/currency-cash.json", method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(data: response.data!)
                    
                    let bidUSD = json["organizations"][1]["currencies"]["USD"]["bid"].string
                    let askUSD = json["organizations"][1]["currencies"]["USD"]["ask"].string
                    
                    print(bidUSD!)
                    print(askUSD!)
                    
                    let bidEUR = json["organizations"][1]["currencies"]["EUR"]["bid"].string
                    let askEUR = json["organizations"][1]["currencies"]["EUR"]["ask"].string
                    
                    print(bidEUR!)
                    print(askEUR!)
                    
                    let bidRUB = json["organizations"][1]["currencies"]["RUB"]["bid"].string
                    let askRUB = json["organizations"][1]["currencies"]["RUB"]["ask"].string
                    
                    print(bidRUB!)
                    print(askRUB!)
                    
                    self.usdBidLabel.text = bidUSD!
                    self.usdAskLabel.text = askUSD!
                    
                    self.eurBidLabel.text = bidEUR!
                    self.eurAskLabel.text = askEUR!
                    
                    self.rubBidLabel.text = bidRUB!
                    self.rubAskLabel.text = askRUB!
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                }
        }
    }
}

