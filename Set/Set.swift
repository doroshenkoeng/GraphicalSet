

import Foundation
import UIKit


/// The struct provides model API for the card game set.
struct Set {
    
    /// Usually the set deck contains 81 cards.
    var deck = [Card]()
    
    /// The game score that correlate with speed of play, number of deal 3 more requests.
    var score = 0
    
    /// The number of deal 3 more cards requests.
    /// It doesn't increment after touching deal 3 more button if there is no set available among visible cards.
    var numberOfDeal3More = 0
    
    /// The property showes a speed of play.
    private var timeOfLastSetTesting = CACurrentMediaTime()
    
    /// The propery is used to store the cards that currently are a set.
    var setOfCards = Swift.Set<Card>()
    
    /// The set game initializer for generating the game deck.
    init() {
        for color in Type.allCases {
            for shape in Type.allCases {
                for fill in Type.allCases {
                    for numberOfShapes in Type.allCases {
                        let card = Card(color: color, shape: shape, fill: fill, numberOfShapes: numberOfShapes)
                        deck += [card]
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    /// The method checks whether the given set of cards is a set or not.
    ///
    /// - Parameter testCards: The cards for testing.
    /// - Returns: true if testCards are a set or false if they aren't.
    func isSet(_ testCards: Swift.Set<Card>) -> Bool {
        var sum = [0, 0, 0, 0]
        let _ = testCards.map {
            sum[0] += $0.color.rawValue; sum[1] += $0.fill.rawValue
            sum[2] += $0.shape.rawValue; sum[3] += $0.numberOfShapes.rawValue
        }
        return (sum[0] % 3) == 0 && (sum[1] % 3) == 0 &&
               (sum[2] % 3) == 0 && (sum[3] % 3) == 0
    }
    
    /// The method increases the game score according to speed of play.
    mutating func increaseScore() {
        score += timeIntervalFromLastSetTesting() < 8.0 ? 5 : 3
    }
    
    /// The method penalizes the game score according to speed of play and number of deal 3 more requests.
    mutating func penaltyScore() {
        if score > 0 {
            score -= timeIntervalFromLastSetTesting() > 20 ? 8 : 5 + numberOfDeal3More
        }
        if score < 0 {
            score = 0
        }
    }
    
    /// The method figures out the time interval from the last set testing.
    ///
    /// - Returns: An interval from the last set testing.
    private mutating func timeIntervalFromLastSetTesting() -> Double {
        let prevTimeOfLastCardTouch = timeOfLastSetTesting
        timeOfLastSetTesting = CACurrentMediaTime()
        return timeOfLastSetTesting - prevTimeOfLastCardTouch
    }
    
    /// The method checks whether an available set among the visible cards exists using brute force.
    /// The time conplexity is O(n^3), n - a number of visible cards.
    /// - Parameter visibleCards: the cards
    /// - Returns: true if there is a set among the visible cadrs or false if there is not any set.
    mutating func isThereASetAvailableIn(visibleCards: [Card]) -> Bool {
        guard visibleCards.count > 2 else { return false }
        setOfCards.removeAll()
        for i in 0..<visibleCards.count - 2 {
            for j in (i+1)..<visibleCards.count - 1 {
                for k in (j+1)..<visibleCards.count {
                    let setOfCards: Swift.Set<Card> = [visibleCards[i], visibleCards[j], visibleCards[k]]
                    if (isSet(setOfCards)) {
                        self.setOfCards = setOfCards
                        return true
                    }
                }
            }
        }
        return false
    }
}


