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
        var localizedDescription: String
    }
    
    let tokenizer: JackTokenizer
    let writer: XMLWriter
    
    var cachedToken: Token?
    
    init(tokenizer: JackTokenizer, writer: XMLWriter) {
        self.tokenizer = tokenizer
        self.writer = writer
    }
    
    func compile() throws {
        try compileClass()
    }
    
    // MARK: Compile Methods
    
    func compileClass() throws {
        try writer.write(element: "class") {
            try expect(tokens: .keyword(.´class´))
            try expect(tokens: .identifierType)
            try expect(tokens: .symbol(.openingCurlyBrace))
            
            
            while let token = tokenizer.nextToken(), check(token, in: [.keyword(.´static´), .keyword(.field)]) {
                try compileClassVarDec(passedToken: token)
            }
            while let token = tokenizer.nextToken(), check(token, in: [.keyword(.constructor), .keyword(.function), .keyword(.method)]) {
                try compileSubroutineDec(passedToken: token)
            }
            try expect(tokens: .symbol(.closingCurlyBrace))
        }
    }
    
    func compileClassVarDec(passedToken: Token? = nil) throws {
        try writer.write(element: "classVarDec") {
            try expect(tokens: .keyword(.´static´), .keyword(.field), passedToken: passedToken)
            try expect(tokens: .keyword(.int), .keyword(.char), .keyword(.boolean), .identifierType)
            try expect(tokens: .identifierType)
            while let token = tokenizer.nextToken(), token == .symbol(.comma) {
                try expect(tokens: .symbol(.comma), passedToken: token)
                try expect(tokens: .identifierType)
            }
            try expect(tokens: .symbol(.semicolon))
        }
    }
    
    func compileSubroutineDec(passedToken: Token? = nil) throws {
        try writer.write(element: "subroutineDec") {
            try expect(tokens: .keyword(.constructor), .keyword(.function), .keyword(.method), passedToken: passedToken)
            try expect(tokens: .keyword(.void), .keyword(.int), .keyword(.char), .keyword(.boolean), .identifierType)
            try expect(tokens: .identifierType)
            try expect(tokens: .symbol(.openingParanthesis))
            if let token = tokenizer.nextToken(), check(token, in: [.keyword(.int), .keyword(.char), .keyword(.boolean), .identifierType]) {
                try expect(tokens: .keyword(.int), .keyword(.char), .keyword(.boolean), .identifierType, passedToken: token)
                try expect(tokens: .identifierType)
//                while let token = tok
            }
        }
    }
    
    // MARK: Helper Methods
    
    func expect(tokens: Token..., passedToken: Token? = nil) throws {
        guard let receivedToken = passedToken ?? tokenizer.nextToken() else {
            throw error(message: "Expected \(tokens), received none.")
        }
        guard check(receivedToken, in: tokens) else {
            throw error(message: "Expected \(tokens), received \(receivedToken)")
        }
        writer.write(token: receivedToken)
    }
    
    func check(_ token: Token, in tokens: [Token]) -> Bool {
        var isIn = false
        switch token {
        case .keyword, .symbol:
            for option in tokens {
                if token == option {
                    isIn = true
                    break
                }
            }
        case .identifier:
            for option in tokens {
                if case .identifier = option {
                    isIn = true
                    break
                }
            }
        case .integerConstant:
            for option in tokens {
                if case .integerConstant = option {
                    isIn = true
                    break
                }
            }
        case .stringConstant:
            for option in tokens {
                if case .stringConstant = option {
                    isIn = true
                    break
                }
            }
        }
        return isIn
    }
    
    func error(message: String) -> CompilationError {
        closeFile()
        return CompilationError(localizedDescription: message)
    }
    
    func closeFile() {
        writer.closeFile()
    }
    
}
