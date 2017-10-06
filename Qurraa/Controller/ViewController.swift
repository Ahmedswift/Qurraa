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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var readerTableView: UITableView!
    
    var rciters = [Reciter]()
    var readerDict = [String: [String]]()
    var readerSectionTitles = [String]()
    var surasNumbers = [String]()
    
    //Declare var to store search result
    var searchResult: [Reciter] = []
    
    //Declare the searchCotroller variable
    var searchController: UISearchController!
    
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
        
        
        searchController = UISearchController(searchResultsController: nil)
        readerTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search reciters..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 95.0/255.0, green:
            113.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        
       
        
        
        
    }
    
    
    //MARK: - Filtering
    /***************************************************************/
    
    func filterContent(for searchText: String) {
        searchResult = rciters.filter({ (rciter) -> Bool in
            if let name = rciter.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            readerTableView.reloadData()
        }
        
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //the getRecitersData method:
    func getRecitersData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if response.result.isSuccess {
                print("Success! Got the reciters data")
                
                let RecitersJSON: JSON = JSON(response.result.value!)
                self.updateRecitersData(json: RecitersJSON)
                // Generate the rciters dictionary
                self.createReaderDict()
                self.suraNumbers()
                
                
                
                
                
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
            let surasnumber = reciterJSON["suras"].stringValue
            reciter.suras = surasnumber.components(separatedBy: ",").map{$0}
           
            reciter.count = reciterJSON["count"].intValue
            self.rciters.append(reciter)
            
            
            
    }
      
        
        
        DispatchQueue.main.async {
            
            self.readerTableView.reloadData()
            
        }
    }

    //MARK: - IndexLisrt
    /************************************************/
    
    func createReaderDict() {
        
        for rciter in 0..<rciters.count  {
            // Get the first letter of the rciter name and build the dictionary
            let reader = rciters[rciter].name!
            let firstLetterIndex = reader.index(reader.startIndex, offsetBy: 0)
            let readerKey = String(reader[...firstLetterIndex])
        
        if var readerValues = readerDict[readerKey] {
            readerValues.append(reader)
            readerDict[readerKey]  = readerValues
        } else {
            readerDict[readerKey] = [reader]
        }
    }
        readerSectionTitles = [String](readerDict.keys)
        readerSectionTitles = readerSectionTitles.sorted(by: {$0 < $1})
    }
    
    
    func suraNumbers() {
        
        for rciter in 0..<rciters.count {
            let reader = rciters[rciter].name!
            
            
            
            
            
            
        }
    }
   
    
    
    //MARK: - TableView DataSource Methods

    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomReaderCell", for: indexPath) as! CustomReaderCell
        
        let reader = (searchController.isActive) ? searchResult[indexPath.row] : self.rciters[indexPath.row]
        
            cell.readerName.text = reader.name
            cell.rewayaLabel.text = reader.rewaya
        
        return cell
    }
    
    //TODO: Declare numberOfSections here:
    func numberOfSections(in tableView: UITableView) -> Int {
         if searchController.isActive {
            return 1
            
        }
         else {
        return readerSectionTitles.count
        }
    }
    //TODO: display a header title in each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if   searchController.isActive {
            return ""
        } else {
        
        return readerSectionTitles[section]
            }
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResult.count
        } else {
            let readerKey = readerSectionTitles[section]
            guard let readerValues = readerDict[readerKey] else {
                return 0
            }
            
        return readerValues.count
        }
    }
    
    
    // prepatre for sgue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomSuraCell" {
           if let indexPath = readerTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! SuraViewController
            DispatchQueue.main.async {
                
                destinationController.readerName.text = self.rciters[indexPath.row].name
                destinationController.surasNumber =  self.rciters[indexPath.row].suras!
                
            }
            
            }
                
            
        }
    }
    
    

}











