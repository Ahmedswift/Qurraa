//
//  ProgressViewDelegate.swift
//  Qurraa
//
//  Created by Ahmad Ahrbi on 30/01/1439 AH.
//  Copyright © 1439 Ahmad Ahrbi. All rights reserved.
//

import Foundation

public protocol ProgressViewDelegate: class {
    func finishedProgress(forCircle circle: ProgressView)
}
