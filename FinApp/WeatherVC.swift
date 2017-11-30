//
//  WeatherVC.swift
//  FinApp
//
//  Created by Igor Karyi on 29.11.2017.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class WeatherVC: UIViewController {
    
    let popSound = Bundle.main.url(forResource: "00171", withExtension: "mp3")
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var dateAndTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
    }
    @IBAction func refreshBtn(_ sender: Any) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: popSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        loadWeather()
    }

    func loadWeather() {
        Alamofire.request("http://api.apixu.com/v1/current.json?key=577b3ad23db04a12bfb230854171811&q=Kiev", method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(data: response.data!)
                    
                    let city = json["location"]["name"].string
                    let temperature = json["current"]["temp_c"].int
                    let dateAndTime = json["location"]["localtime"].string
                    
                    
                    print(city!)
                    print(temperature!)
                    print(dateAndTime!)
                    
                    self.cityLabel.text = city!
                    
                    self.tempLabel.text = "\(temperature!), °C"
                    if self.tempLabel.text == "1, °C" {

                    }
                    
                    
                    self.dateAndTimeLabel.text = dateAndTime!
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                }
        }
    }
}
