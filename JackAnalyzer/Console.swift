//
//  Console.swift
//  JackAnalyzer
//
//  Created by Murat Dogu on 10.04.2018.
//  Copyright © 2018 Murat Dogu. All rights reserved.
//

import Foundation

class Console {
    
    static func print(_ message: String) {
        print(message)
    }
    
    static func error(_ message: String) {
        fputs("\u{001B}[0;31m\(message)\u{001B}[;m\n", stderr)
    }
    
}
