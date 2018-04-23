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
    
    var tokens = [Token]()
    var currentToken: Token?
    var isInComment = false
    
    init(inputFileURL: URL) throws {
        self.inputFile = try FileHandle(forReadingFrom: inputFileURL)
    }
    
    func nextToken() -> Token? {
        if tokens.count > 0 {
            return tokens.remove(at: 0)
        } else {
            if let line = inputFile.readLine() {
                var commentLess = line
                if isInComment {
                    if let range = line.range(of: "*/") {
                        commentLess.removeSubrange(..<range.upperBound)
                        isInComment = false
                    } else {
                        return nextToken()
                    }
                }
                if let range = line.range(of: "//") {
                    commentLess.removeSubrange(range.lowerBound...)
                }
                if let openingRange = line.range(of: "/*") {
                    let comment = line[openingRange.lowerBound...]
                    if let closingRange = comment.range(of: "*/") {
                        commentLess.removeSubrange(openingRange.lowerBound ..< closingRange.upperBound)
                    } else {
                        commentLess.removeSubrange(openingRange.lowerBound...)
                        isInComment = true
                    }
                }
                if let openingRange = line.range(of: "/**") {
                    let comment = line[openingRange.lowerBound...]
                    if let closingRange = comment.range(of: "*/") {
                        commentLess.removeSubrange(openingRange.lowerBound ..< closingRange.upperBound)
                    } else {
                        commentLess.removeSubrange(openingRange.lowerBound...)
                        isInComment = true
                    }
                }
                let trimmed = commentLess.trimmingCharacters(in: .whitespaces)
                guard trimmed.count > 0 else { return nextToken() }
                
                let regex = try! NSRegularExpression(pattern: "^")
                let match = regex.firstMatch(in: trimmed, range: NSRange(location: 0, length: trimmed.count))
                
                return .keyword(.´class´)  // TODO: delete when complete
            } else {
                return nil
            }
        }
    }
    
}

enum Token {
    enum Keyword: String {
        case ´class´ = "class", method, function, constructor, int, boolean, char, void, ´var´ = "var", ´static´ = "static", field, ´let´ = "let", ´do´ = "do", ´if´ = "if", ´else´ = "else", ´while´ = "while", ´return´ = "return", ´true´ = "true", ´false´ = "false", null, this
    }
    
    enum Symbol: String {
        case openingCurlyBrace = "{", closingCurlyBrace = "}", openingParanthesis = "(", closingParanthesis = ")", openingBracket = "[", closingBracket = "]", dot = ".", comma = ",", semicolon = ";", plus = "+", minus = "-", asterisk = "*", slash = "/", ampersand = "&", pipe = "|", lessThan = "<", greaterThan = ">", equal = "=", tilde = "~"
    }
    
    case keyword(Keyword)
    case symbol(Symbol)
    case identifier(String)
    case integerConstant(Int)
    case stringConstant(String)
}

extension String {
    
    mutating func consumeToken() throws -> Token? {
        self = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return try consumeKeyword() ??
            consumeSymbol() ??
            consumeIdentifier() ??
            consumeIntegerConstant() ??
            consumeStringConstant()
    }
    
    mutating func consumeKeyword() throws -> Token? {
        let regex = try NSRegularExpression(pattern: "^(class|method|function|constructor|int|boolean|char|void|var|static|field|let|do|if|else|while|return|true|false|null|this)\\b")
        let match = regex.firstMatch(in: self, range: NSRange(location: 0, length: count))
        if let nsRange = match?.range(at: 1), let range = Range(nsRange, in: self) {
            if let token = Token.Keyword(rawValue: String(self[range])) {
                removeSubrange(range)
                return .keyword(token)
            }
        }
        return nil
    }
    
    mutating func consumeSymbol() -> Token? {
        
    }
    
    mutating func consumeIdentifier() -> Token? {
        
    }
    
    mutating func consumeIntegerConstant() -> Token? {
        
    }
    
    mutating func consumeStringConstant() -> Token? {
        
    }
}
