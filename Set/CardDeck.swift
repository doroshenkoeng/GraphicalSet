//
//  CardDeck.swift
//  Set
//
//  Created by Сергей Дорошенко on 30/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import Foundation

struct CardDeck {
    var cards = [Card]()
    
    init() {
        for number in Card.ThreeStates.all {
            for color in Card.ThreeStates.all {
                for shape in Card.ThreeStates.all {
                    for fill in Card.ThreeStates.all {
                        cards += [Card(number: number, color: color, shape: shape, fill: fill)]
                    }
                }
            }
        }
    }
    mutating func pickRandomCard() -> Card? {
        if cards.count == 0 {
            return nil
        } else {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        }
    }
}
