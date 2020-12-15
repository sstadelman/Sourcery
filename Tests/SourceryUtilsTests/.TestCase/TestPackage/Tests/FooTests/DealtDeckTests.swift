//
//  File.swift
//  
//
//  Created by Stadelman, Stan on 1/11/21.
//

import Foundation
import XCTest
import Foo


class DealtDeckTests: XCTestCase {
    
    func testDeck() throws {
        let deck = DealtDeck()
        XCTAssert(deck.value > 0)
    }
}
