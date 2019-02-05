//
//  main.swift
//  SourcerParsing
//
//  Created by Stadelman, Stan on 2/2/19.
//  Copyright © 2019 Pixle. All rights reserved.
//

import Foundation
import SourceryFramework



print("Hello, World!")
let completePath = "/Users/sarah/Desktop/Files.playground"
let completeUrl = URL(fileURLWithPath: completePath)
let home = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("wdfgithub/com.sap.mobile.platform.client.hcp.sdk.ios.ui/src/Frameworks/SAPFiori/SAPFiori", isDirectory: true)
let contents = try FileManager.default.subpathsOfDirectory(atPath: home.path)
let swiftFiles = contents.filter({ $0.hasSuffix(".swift")} )

for file in swiftFiles {
    let fileURL = home.appendingPathComponent(file)
    do {
        let string = try String(contentsOf: fileURL)
        let results = try FileParser(contents: string)
        print(results)
    }
    catch {
        print(error)
    }
    
}
