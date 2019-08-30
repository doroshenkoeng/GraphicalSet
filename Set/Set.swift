

import Foundation
import UIKit


/// The struct provides model API for the card game set.
struct Set {
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
        for _ in 0..<12 {
            if let card = deck.popLast() {
                visibleCards += [card]
            }
        }
    }
    /// The method checks whether the given set of cards is a set or not.
    ///
    /// - Parameter testCards: The cards for testing.
    /// - Returns: true if testCards are a set or false if they aren't.
    func isSet(_ testCards: [Card]) -> Bool {
        var sum = [0, 0, 0, 0]
        let _ = testCards.map {
            sum[0] += $0.color.rawValue; sum[1] += $0.fill.rawValue
            sum[2] += $0.shape.rawValue; sum[3] += $0.numberOfShapes.rawValue
        }
        return (sum[0] % 3) == 0 && (sum[1] % 3) == 0 &&
               (sum[2] % 3) == 0 && (sum[3] % 3) == 0
    }
    
    private(set) var score = 0
    
    private(set) var visibleCards = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var cardsTryMatched = [Card]()
    private(set) var cardsRemoved = [Card]()
    
    private var deck = [Card]()
    
    /// Uses isSet(_ testCards: [Card]) method to find the set among tested cards.
    /// Updates the game score.
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else { return nil }
            return isSet(cardsTryMatched)
        }
        set {
            if newValue != nil {
                if newValue! {
                    score += ScorePoints.matchBonus
                } else {
                    score -= ScorePoints.missMatchPenalty
                    if score < 0 { score = 0 }
                }
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsTryMatched.removeAll()
            }
        }
    }
    
    /// Responds to choose a card from the table.
    ///
    /// - Parameter index: An index of the chosen card in the visible cards array.
    mutating func chooseCard(at index: Int) {
        assert(visibleCards.indices.contains(index), "Set.chooseCard(at: \(index)): Chosen index is out of range")
        let chosenCard = visibleCards[index]
        if !cardsRemoved.contains(chosenCard), !cardsTryMatched.contains(chosenCard) {
            if  isSet != nil {
                if isSet! { replaceOrRemove3Cards()}
                isSet = nil
            }
            if cardsSelected.count == 2, !cardsSelected.contains(chosenCard) {
                cardsSelected += [chosenCard]
                isSet = isSet(cardsSelected)
            } else {
                cardsSelected.inOut(element: chosenCard)
            }
        }
    }
    
    /// Removes or replaces 3 chosen cards from a table.
    private mutating func replaceOrRemove3Cards(){
        if visibleCards.count == Set.startNumberCards, let take3Cards =  take3FromDeck() {
            visibleCards.replace(elements: cardsTryMatched, with: take3Cards)
        } else {
            visibleCards.remove(elements: cardsTryMatched)
        }
        cardsRemoved += cardsTryMatched
        cardsTryMatched.removeAll()
    }
    
    /// Draws 3 more cards
    ///
    /// - Returns: 3 more cards from the deck.
    private mutating func take3FromDeck() -> [Card]?{
        var threeCards = [Card]()
        for _ in 0...2 {
            if let card = deck.popLast() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }
    
    /// Responds to deal 3 more cards request from the user.
    mutating func deal3() {
        if let deal3Cards =  take3FromDeck() {
            visibleCards += deal3Cards
        }
    }
    
    /// Finds all the visible sets and removes one of them if there is a set among chosen cards.
    var hints: [[Int]] {
        var hints = [[Int]]()
        if visibleCards.count > 2 {
            for i in 0..<visibleCards.count {
                for j in (i+1)..<visibleCards.count {
                    for k in (j+1)..<visibleCards.count {
                        let cards = [visibleCards[i], visibleCards[j], visibleCards[k]]
                        if isSet(cards) {
                            hints.append([i,j,k])
                        }
                    }
                }
            }
        }
        if isSet == true {
            let matchIndices = visibleCards.indices(of: cardsTryMatched)
            return hints.map{ Swift.Set($0) }
                .filter{$0.intersection(Swift.Set(matchIndices)).isEmpty }
                .map{Array($0)}
        }
        return hints
    }
    
    mutating func shuffle() { visibleCards.shuffle() }
    
    /// Some score constants.
    private struct ScorePoints {
        static let matchBonus = 10
        static let missMatchPenalty = 5
    }
    static let startNumberCards = 12
}

extension Array where Element : Equatable {
    
    /// Ins element if an array doesn't consist the elelemt and vice versa.
    ///
    /// - Parameter element: An element of an array
    mutating func inOut(element: Element){
        if let from = self.firstIndex(of:element)  {
            self.remove(at: from)
        } else {
            self += [element]
        }
    }
    
    /// Removes the given array from the self array.
    ///
    /// - Parameter elements: An array of generic type.
    mutating func remove(elements: [Element]){
        self = self.filter { !elements.contains($0) }
    }
    
    /// Replaces the old given elements with the given new ones.
    ///
    /// - Parameters:
    ///   - elements: The old elements.
    ///   - new: The new elements.
    mutating func replace(elements: [Element], with new: [Element] ) {
        guard elements.count == new.count else { return }
        for index in 0..<new.count {
            if let indexMatched = self.firstIndex(of: elements[index]){
                self[indexMatched] = new[index]
            }
        }
    }
    
    /// Finds self array indices of the given arrray elements.
    ///
    /// - Parameter elements: The array of a generic type.
    /// - Returns: The array of occurence elements indices.
    func indices(of elements: [Element]) ->[Int]{
        guard self.count >= elements.count, elements.count > 0 else {return []}
        return elements.map{self.firstIndex(of: $0)}.compactMap{$0}
    }
}

    




