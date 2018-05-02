//
//  CompilationEngine.swift
//  JackAnalyzer
//
//  Created by Murat Dogu on 10.04.2018.
//  Copyright © 2018 Murat Dogu. All rights reserved.
//

import Foundation

class CompilationEngine {
    
    struct CompilationError: Error {
        let message: String
    }
    
    let tokenizer: JackTokenizer
    let writer: XMLWriter
    
    init(tokenizer: JackTokenizer, writer: XMLWriter) {
        self.tokenizer = tokenizer
        self.writer = writer
    }
    
    
    func compileClass() throws {

    }
    
}
