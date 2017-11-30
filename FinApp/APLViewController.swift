//
//  APLViewController.swift
//  FinApp
//
//  Created by Igor Karyi on 30.11.2017.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class APLViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var teamsArray = [[String:AnyObject]]()
    
    let popSound = Bundle.main.url(forResource: "00171", withExtension: "mp3")
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aplRequest()
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: popSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        aplRequest()
    }
    
    func aplRequest() {
        Alamofire.request("http://api.football-data.org/v1/soccerseasons/445/leagueTable", method: .get, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if(response.result.error == nil) {
                    let json = JSON(response.data!)
                    print(json)
                    if let teams = json["standing"].arrayObject {
                        self.teamsArray = teams as! [[String:AnyObject]]
                    }
                    if self.teamsArray.count > 0 {
                        self.tableView.reloadData()
                    }
                }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teamsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! APLTableViewCell
        var dict = teamsArray[indexPath.row]
        
        cell.nLabel?.text = "\(indexPath.row+1)"
        
        cell.nameLabel?.text = dict["teamName"] as? String
        
        let num = dict["points"] as! Int
        let str = String(describing: num)
        print(str)
        
        cell.pointsLabel?.text = str

        return cell
    }
}
