//
//  XMLWriter.swift
//  JackAnalyzer
//
//  Created by Murat Dogu on 22.04.2018.
//  Copyright © 2018 Murat Dogu. All rights reserved.
//

import Foundation

class XMLWriter {
    
    let outputFile: FileHandle
    
    init(outputFileURL: URL) throws {
        if FileManager.default.fileExists(atPath: outputFileURL.path) == false {
            FileManager.default.createFile(atPath: outputFileURL.path, contents: nil, attributes: nil)
        }
        self.outputFile = try FileHandle(forUpdating: outputFileURL)
    }
    
    func write(element: String, body: ()-> ()) {
        outputFile.write(line: "<\(element)>")
        body()
        outputFile.write(line: "</\(element)>")
    }
    
    func write(token: Token) {
        let output: String
        switch token {
        case .keyword(let keyword):
            output = "<keyword> \(keyword.rawValue) </keyword>"
        case .symbol(let symbol):
            let acceptableSymbol: String
            switch symbol {
            case .greaterThan:
                acceptableSymbol = "&gt;"
            case .lessThan:
                acceptableSymbol = "&lt;"
            case .ampersand:
                acceptableSymbol = "&amp;"
            default:
                acceptableSymbol = symbol.rawValue
            }
            output = "<symbol> \(acceptableSymbol) </symbol>"
        case .identifier(let identifier):
            output = "<identifier> \(identifier) </identifier>"
        case let .integerConstant(integerConstant):
            output = "<integerConstant> \(integerConstant) </integerConstant>"
        case let .stringConstant(stringConstant):
            output = "<stringConstant> \(stringConstant) </stringConstant>"
        }
        outputFile.write(line: output)
    }
    
    func closeFile() {
        outputFile.closeFile()
    }
}
