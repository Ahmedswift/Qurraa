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
    var surasDict = [String: String]()
    var surasNumber = [String]()
    var resultDict = [String: String]()
    var URL_SURAS_MP3: URL?
    var sortedDic: [(key: String, value: String)]?

    

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
                self.createSurasDict()
                self.suraNumbers(self.surasNumber)
                
                
                
                
                
                
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
    
    
    
    //MARK: - suras Dictionary
    /************************************************/
    
    func createSurasDict() {
        
        for sura in 0..<suras.count  {
            let suraKey =  suras[sura].id!
            let suraValue = suras[sura].name!
            self.surasDict[suraKey] = suraValue
            
        }
    }
    
    
    
    func suraNumbers(_ newArr: [String]) {
        if newArr.count == self.suras.count {
            resultDict = surasDict
        } else if newArr.count < self.suras.count {
            for item in 0..<newArr.count {
                let number = newArr[item]
                for key in surasDict.keys {
                    if number == key {
                        let value = surasDict[number]
                        resultDict[number] = value
                        //print(resultDict)
                    }
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
        let count = resultDict.count  < suras.count ?  resultDict.count :  suras.count
        return count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSuraCell", for: indexPath) as! CustomSuraCell
        if resultDict.count  < suras.count {
         self.sortedDic = resultDict.sorted(by: <)
            cell.suraName.text = sortedDic![indexPath.row].value

            
        } else {
        
        cell.suraName.text = suras[indexPath.row].name
            
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SurasPlayerVC" {
            if let indexPath = suraTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!SurasPlayerVC
                DispatchQueue.main.async {
                    
                    //self.suraTableView.reloadData()
                    
                     
                 
                    if self.URL_SURAS_MP3 != nil {
                        destinationController.selectedSuraUrl = "\(self.URL_SURAS_MP3!)"
                        destinationController.reciterName.text = self.readerName.text
                        
                        if self.resultDict.count  < self.suras.count {
                            let name = self.sortedDic![indexPath.row].value
                            destinationController.suraTitle.text = "Surah \(name)"
                            destinationController.suraID = self.sortedDic![indexPath.row].key
                            print("the key:\(self.sortedDic![indexPath.row].key)")
                            destinationController.surasDict = self.resultDict
                            destinationController.sortedDic = self.sortedDic
                            
                            
                        } else {
                        
                        let name = self.suras[indexPath.row].name!
                        destinationController.suraTitle.text = "Surah \(name)"
                        destinationController.suraID = self.suras[indexPath.row].id!
                        destinationController.surasDict = self.surasDict
                            let sortedDict = self.resultDict.sorted(by: <)
                            print(sortedDict)
                        destinationController.sortedDic = sortedDict
                        
                        
                        }
                       
               }
            }
                

                
         
            }
        }
    }

}









