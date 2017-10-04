//
//  SuraViewController.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 14/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SuraViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var readerName: UILabel!
    
     @IBOutlet var suraTableView: UITableView!
    
    //Constant
    var SURA_URL = "http://mp3quran.net/api/_english_sura.json"
    
    var suras = [Sura]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        
        readerName.text = ""
        suraTableView.delegate = self
        suraTableView.dataSource = self
        
        getSurasData(url: SURA_URL)
        
        suraTableView.rowHeight = UITableViewAutomaticDimension
        suraTableView.estimatedRowHeight = suraTableView.rowHeight
        
        
        
        
        
    }

   
    
    @IBAction func hideButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //the getRecitersData method:
    func getSurasData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if response.result.isSuccess {
                print("Success! Got the suras data")
                
                let surasJSON: JSON = JSON(response.result.value!)
                self.updateSurasData(json: surasJSON)
                
                
                
            } else {
                print("Error \(response.result.error)")
                
            }
            
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //Write the updateSurasData method here:
    
    func updateSurasData(json: JSON) {
        
        for suraJSON in json["Suras_Name"].arrayValue {
            let sura = Sura()
            
            sura.id = suraJSON["id"].intValue
            sura.name = suraJSON["name"].stringValue
            self.suras.append(sura)
            
        }
        
        DispatchQueue.main.async {
            
            self.suraTableView.reloadData()
            
        }
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return suras.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSuraCell", for: indexPath) as! CustomSuraCell
        
        cell.suraName.text = suras[indexPath.row].name
        
        return cell
    }

}
