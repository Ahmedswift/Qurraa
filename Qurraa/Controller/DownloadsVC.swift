//
//  DownloadsVC.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 09/02/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import UIKit
import CoreData

class DownloadsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var downloadView: UIView!
    
    var listSuras = [SurasMO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadNodtes()
        if listSuras.count == 0 {
            downloadView.isHidden = false
            
        } else {
            downloadView.isHidden = true
            
        }
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = 140
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
       
        
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number: \(listSuras.count)")
        return listSuras.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "downloadsCell", for: indexPath) as! DownloadsTVC
        cell.setCell(sura: listSuras[indexPath.row])
        //cell.suraName.text = listSuras[indexPath.row].suraName
        //print(listSuras[indexPath.row].suraName)
        //print("number: \(listSuras.count)")
        
    
        return cell
    }
    
    func loadNodtes() {
        let fechRequest:NSFetchRequest<SurasMO> = SurasMO.fetchRequest()
        do {
            listSuras = try context.fetch(fechRequest)
            tableView.reloadData()
        } catch {
            print("Error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "SurasPlayerVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! SurasPlayerVC
                 DispatchQueue.main.async {
                    print("reciter: \(self.listSuras[indexPath.row].reciter)")
                    destinationController.reciterName.text = self.listSuras[indexPath.row].reciter!
                    destinationController.suraTitle.text = self.listSuras[indexPath.row].suraName!
                    destinationController.rewayaType.text = self.listSuras[indexPath.row].rewaya!
                    destinationController.suraDownloaded = self.listSuras[indexPath.row].sura
                    print(self.listSuras[indexPath.row].sura)
                }
            }
                
        }
    }
    
}








