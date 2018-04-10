//
//  JackTokenizer.swift
//  JackAnalyzer
//
//  Created by Murat Dogu on 10.04.2018.
//  Copyright © 2018 Murat Dogu. All rights reserved.
//

import Foundation

class JackTokenizer {
    
    let inputFile: FileHandle
    
    init(inputFileURL: URL) throws {
        self.inputFile = try FileHandle(forReadingFrom: inputFileURL)
    }
    
    
    
}
