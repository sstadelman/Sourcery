//
//  File.swift
//  
//
//  Created by Stadelman, Stan on 1/8/21.
//

import Foundation
import DeckOfPlayingCards
import PlayingCard

public protocol A {
    var value: Int { get }
}

public struct DealtDeck: A {
    private var cards: [PlayingCard] = []
    
    public init() {
        var deck = Deck.standard52CardDeck()
        deck.shuffle()
        for _ in 0..<10 {
            if let card = deck.deal() {
                cards.append(card)
            }
        }
    }
    
    public var value: Int {
        cards.sum(\.rank.rawValue)
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
