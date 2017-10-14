//
//  Reciters.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 11/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import Foundation


class Reciter: NSObject {
    
    @objc var name: String? = ""
    var rewaya: String? = ""
    var letter: String? = ""
    var suras: [String]? = []
    var count: Int? = 0
    var server: URL?
    
    
    
    
}


class Sura {
    var id: String? = ""
    var name: String? = ""
    
}
