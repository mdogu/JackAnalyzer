//
//  main.swift
//  JackAnalyzer
//
//  Created by Murat Dogu on 10.04.2018.
//  Copyright © 2018 Murat Dogu. All rights reserved.
//

import Foundation

guard CommandLine.argc == 2 else {
    Console.error("Usage: JackAnalyzer source")
    exit(0)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let inputFiles: [URL]

if inputURL.lastPathComponent.ends(with: ".jack") {
    guard FileManager.default.fileExists(atPath: inputURL.path) else {
        Console.error("File does not exist")
        exit(0)
    }
    inputFiles = [inputURL]
} else {
    if FileManager.default.isDirectory(url: inputURL) {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: inputURL, includingPropertiesForKeys: [])
            guard files.count > 0 else {
                Console.error("Empty Directory")
                exit(0)
            }
            let inputs = files.filter { $0.lastPathComponent.ends(with: ".jack") }
            guard inputs.count > 0 else {
                Console.error("Directory contains no .vm files")
                exit(0)
            }
            inputFiles = inputs
        } catch {
            Console.error(error.localizedDescription)
            exit(0)
        }
    } else {
        Console.error("Argument should be a Jack file or a directory containing Jack file(s)")
        exit(0)
    }
}

