//
//  SurasVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 26/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

class SurasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var suraTableView: UITableView!
    
    var currentSura = [Sura]()
    var rewaya: String = ""
    var reciterName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        
        suraTableView.delegate = self
        suraTableView.dataSource = self
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSura.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSuraSeCell", for: indexPath) as! CustomSuraSelectedCellTableViewCell
        
        cell.suraName.text = "Surah \(currentSura[indexPath.row].name!)"
        
        cell.rewayaName.text = rewaya
        cell.readerName.text = reciterName
       
        
        return cell
    }
    
    
    @IBAction func hideButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    

}
