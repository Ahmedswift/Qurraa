//
//  SurasVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 26/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit

protocol ChangeSuraDelegate {
    func userSelectedNewSuraName(sura: String)
}

class SurasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ChangeSuraDelegate?
    
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var suraTableView: UITableView!
    
    var currentSura = [Sura]()
    var rewaya: String = ""
    var reciterName: String = ""
    var suraName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        
        suraTableView.delegate = self
        suraTableView.dataSource = self
        
    }

    @IBAction func gestureTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSura.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSuraSeCell", for: indexPath) as! CustomSuraSelectedCellTableViewCell
        cell.suraName.text = "Surah \(currentSura[indexPath.row].name!)"
        
        if self.suraName == cell.suraName.text {
            cell.isSelected = true
        }
        cell.rewayaName.text = rewaya
        cell.readerName.text = reciterName
       
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedSura: String = self.currentSura[indexPath.row].id!
        delegate?.userSelectedNewSuraName(sura: selectedSura)
    }
    
    @IBAction func hideButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    

}
