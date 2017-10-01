//
//  ViewController.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 11/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var readerTableView: UITableView!
    
    var rciters = [Reciter]()
    
    //Constant
    let RECITERS_URL = "http://mp3quran.net/api/_english.json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //TODO: Set yourself as the delegate and datasource here:
        readerTableView.delegate = self
        readerTableView.dataSource = self
        
        getRecitersData(url: RECITERS_URL)
        
        readerTableView.rowHeight = UITableViewAutomaticDimension
        readerTableView.estimatedRowHeight = readerTableView.rowHeight
        
        
    }

    //MARK: - Networking
    /***************************************************************/
    
    //the getRecitersData method:
    func getRecitersData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if response.result.isSuccess {
                print("Success! Got the reciters data")
                
                let RecitersJSON: JSON = JSON(response.result.value!)
                //print(RecitersJSON)
                self.updateRecitersData(json: RecitersJSON)
                
            } else {
                print("Error \(response.result.error)")
                
            }
            
        }
        
    }
   
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //Write the updateRecitersData method here:
    
    func updateRecitersData(json: JSON) {
        
       
        
        
        
        for reciterJSON in json["reciters"].arrayValue {
            let reciter = Reciter()
            
            reciter.name = reciterJSON["name"].stringValue
            reciter.rewaya = reciterJSON["rewaya"].stringValue
            reciter.letter = reciterJSON["letter"].stringValue
            self.rciters.append(reciter)
            
    }
      
        DispatchQueue.main.async {
            self.readerTableView.reloadData()
            
        }
    }

        
    
    
    
        
    
    
    
    //MARK: - TableView DataSource Methods

    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomReaderCell", for: indexPath) as! CustomReaderCell
    
        cell.readerName.text = self.rciters[indexPath.row].name
        cell.rewayaLabel.text = self.rciters[indexPath.row].rewaya
        
        
        return cell
    }
    
    //TODO: Declare numberOfSections here:
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rciters.count
        
    }

}

