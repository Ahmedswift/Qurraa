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
import Foundation

class SuraViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var readerName: UILabel!
    
     @IBOutlet var suraTableView: UITableView!
    
    //Constant
    var SURA_URL = "http://mp3quran.net/api/_english_sura.json"
    
    var suras = [Sura]()
    var surasNumber = [String]()
    var URL_SURAS_MP3: URL?
    var currentSuras = [Sura]()
    var rewaya: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        
       
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
                self.updateSuras()
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
            
            sura.id = suraJSON["id"].stringValue
            sura.name = suraJSON["name"].stringValue
            self.suras.append(sura)
            
            
        }
        
        DispatchQueue.main.async {
            
            self.suraTableView.reloadData()
            
        }
    }
    
   
    func updateSuras() {
        for sura in 0..<suras.count {
            for index in 0..<surasNumber.count {
                let newSura = Sura()
                if surasNumber[index] == suras[sura].id {
                    newSura.id = suras[sura].id
                    newSura.name = suras[sura].name
                    self.currentSuras.append(newSura)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //let count = resultDict.count  < suras.count ?  resultDict.count :  suras.count
        return currentSuras.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSuraCell", for: indexPath) as! CustomSuraCell
        cell.suraName.text = currentSuras[indexPath.row].name
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SurasPlayerVC" {
            if let indexPath = suraTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!SurasPlayerVC
                DispatchQueue.main.async {
            
                    if self.URL_SURAS_MP3 != nil {
                        
                        destinationController.selectedSuraUrl = "\(self.URL_SURAS_MP3!)"
                        destinationController.reciterNameS = self.readerName.text!
                        
                        let name = self.currentSuras[indexPath.row].name!
                        let id = self.currentSuras[indexPath.row].id!
                        destinationController.suraTitle.text = "Surah \(name)"
                        destinationController.suraID = id
                        destinationController.currentSuras = self.currentSuras
                        destinationController.index = indexPath.row
                        destinationController.rewaya = self.rewaya
                        
                        
                       
               }
            }
         
            }
        }
    }

}









