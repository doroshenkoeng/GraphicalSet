//
//  ViewController.swift
//  Set
//
//  Created by Сергей Дорошенко on 27/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit


/// This class is a controller of the card game set view.
class ViewController: UIViewController {
    
    /// The set of buttons alows to control selected buttons.
    private var selectedCardButtons = Swift.Set<UIButton>()
    
    /// The card game set model object.
    private var game = Set()
    
    /// This dictionary keeps associated (uibutton: card) pairs.
    private var buttonCardDictionary = [UIButton: Card]()
    
    /// The outlet collection of the uibuttons.
    @IBOutlet private var cardButtons: [UIButton]!
    
    /// The outlet label of player's score.
    @IBOutlet private weak var scoreLabel: UILabel!
    
    /// This method is called after the view controller has loaded its view to initialize all the card buttons.
    override func viewDidLoad() {
        for button in cardButtons {
            button.layer.borderWidth = 3.0
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        for index in 0..<cardButtons.count / 2 {
            let card = game.deck.removeFirst()
            cardButtons[index].setAttributedTitle(cardToNSAttributedString(card: card), for: .normal)
            buttonCardDictionary[cardButtons[index]] = card
        }
        for index in cardButtons.count / 2..<cardButtons.count {
            cardButtons[index].setTitle("", for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    /// This method changes the selected cards if there are cards in the deck or hide them from the view.
    /// The time complexity is O(n), n - a number of selected cards.
    private func replaceCards() {
        for button in selectedCardButtons {
            button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            if cardButtons.firstIndex(of: button) ?? 12 >= 12 || game.deck.isEmpty { continue }
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let card = game.deck.removeFirst()
            button.setAttributedTitle(cardToNSAttributedString(card: card), for: .normal)
            buttonCardDictionary[button] = card
        }
    }
    
    /// This method is called whenever a user touches a card.
    /// After touching the card changes its state (i. e. a button layer color).
    /// If it's already 3 cards selected this method checks whether this 3 cards is a set or not using model API.
    /// The time complexity is O(n), n - a number of card buttons.
    /// - Parameter sender: The UIButton was pressed by a user.
    @IBAction private func touchCard(_ sender: UIButton) {
        guard sender.backgroundColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) else { return }
        
        for button in cardButtons {
            if button.layer.borderColor == #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) || button.layer.borderColor == #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) {
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
        
        if sender.layer.borderColor == #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) {
            sender.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            selectedCardButtons.remove(sender)
        } else {
            sender.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            selectedCardButtons.insert(sender)
        }
        if selectedCardButtons.count == 3 {
            selectedCardButtons.insert(sender)
            var color: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            if game.isSet(buttonsToSetOfCards(selectedCardButtons)) {
                game.increaseScore()
                replaceCards()
            } else {
                game.penaltyScore()
                color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            scoreLabel.text = "Score: \(game.score)"
            for button in cardButtons {
                if selectedCardButtons.contains(button) {
                    button.layer.borderColor = color
                    selectedCardButtons.remove(button)
                }
            }
        }
        
    }
    
    /// This method is called whenever a user touches the new game button.
    /// This method does all the preporation for statring a new game.
    /// The time complexity is O(n), n - a number of card buttons.
    /// - Parameter sender: The New game button was pressed by a user.
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        game = Set()
        selectedCardButtons.removeAll()
        buttonCardDictionary.removeAll()
        game.score = 0
        scoreLabel.text = "Score: 0";
        for index in 0..<cardButtons.count / 2 {
            let card = game.deck.removeFirst()
            cardButtons[index].setAttributedTitle(cardToNSAttributedString(card: card), for: .normal)
            cardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            buttonCardDictionary[cardButtons[index]] = card
            cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        }
        for index in cardButtons.count / 2..<cardButtons.count {
            cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            cardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }

    
    /// This method is called whenever a user touches the cheat button.
    /// This method finds a set among visible cards and marked this cards for user.
    /// The time complexity is O(n + m^3), n - a number of card buttons, m - a number of visible cards.
    /// - Parameter sender: The cheat button was pressed by a user.
    @IBAction private func touchCheatButton(_ sender: UIButton) {
        guard game.isThereASetAvailableIn(visibleCards: findVisibleCards()) else { return }
        for button in cardButtons {
            if game.setOfCards.isEmpty { break }
            if game.setOfCards.contains(buttonCardDictionary[button]!)  {
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                game.setOfCards.remove(buttonCardDictionary[button]!)
            }
        }
        
    }
    
    /// This method is called whenever a user touches the deal 3 more button.
    /// This method iterates over cards and puts a new card in the first available spot.
    /// - Parameter sender: The deal 3 more button was pressed by a user.
    @IBAction private func touchDeal3Button(_ sender: UIButton) {
        var numberOfAddedCards = 0
        var isNumberOfDeal3MoreChanged = false
        for button in cardButtons {
            if numberOfAddedCards == 3 || game.deck.isEmpty { break }
            if button.backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
                let card = game.deck.removeFirst()
                button.setAttributedTitle(cardToNSAttributedString(card: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                numberOfAddedCards += 1
                buttonCardDictionary[button] = card
                if !isNumberOfDeal3MoreChanged {
                    if (game.isThereASetAvailableIn(visibleCards: findVisibleCards())) { game.numberOfDeal3More += 1 }
                    isNumberOfDeal3MoreChanged = true
                }
            }
        }
    }
    
    /// This method converts a given set of buttons to a set of cards.
    ///
    /// - Parameter selectedCardButtons: A set of selected ui buttons.
    /// - Returns: A set of selected cards.
    private func buttonsToSetOfCards(_ selectedCardButtons: Swift.Set<UIButton>) -> Swift.Set<Card> {
        var setOfCards = Swift.Set<Card>()
        for button in selectedCardButtons {
            if let card = buttonCardDictionary[button] {
                setOfCards.insert(card)
            }
        }
        return setOfCards
    }
    
    /// This method converts a member of struct Card with all its properties (color, shape, etc.) to NSAttributedString which will appear at the ui button title.
    ///
    /// - Parameter card: A member of struct Card
    /// - Returns: NSAttributedString that showes all the given card properties as an attributed string.
    private func cardToNSAttributedString(card: Card) -> NSAttributedString {
        let color: UIColor
        switch card.color {
        case .type1: color = UIColor.green
        case .type2: color = UIColor.red
        default: color = UIColor.purple
        }
        
        var attributes: [NSAttributedString.Key: Any] = [
            .strokeColor : color,
            .strokeWidth: -5
        ]
        switch card.fill {
        case .type1: attributes[.foregroundColor] = color.withAlphaComponent(1)
        case .type2: attributes[.foregroundColor] = color.withAlphaComponent(0.15)
        default: attributes[.foregroundColor] = color.withAlphaComponent(0)
        }
        
        var string = ""
        switch card.shape {
        case .type1: string = "▲"
        case .type2: string = "●"
        default: string = "■"
        }
        
        let separator: String
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown: separator = "\n"
        default: separator = " "
        }
        
        switch card.numberOfShapes {
        case .type2: string = string.concatByNSeparators(separator, n: 1)
        case .type3: string = string.concatByNSeparators(separator, n: 2)
        default: break // do nothing
        }
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    /// This method find visible cards among all the cards.
    ///
    /// - Returns: An array of a struct type Card.
    private func findVisibleCards() -> [Card] {
        var visibleCards = [Card]()
        for button in cardButtons {
            if button.backgroundColor == #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
                if let card = buttonCardDictionary[button] {
                    visibleCards += [card]
                }
            }
        }
        return visibleCards
    }
    
    /// This method traces device orientation changes.
    /// Whenever orientation changes it changes buttons titles to look the part.
    /// - Parameters:
    ///   - size: The new size for the container’s view.
    ///   - coordinator: The transition coordinator object managing the size change. You can use this object to animate your changes or get information about the transition that is in progress.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for button in cardButtons {
            var string = ""
            let title = button.attributedTitle(for: .normal)?.string
            let attributes = button.attributedTitle(for: .normal)?.attributes(at: 0, effectiveRange: nil)
            if attributes == nil || title == "" { break }
            
            var newSeparator: Character
            // UIDevice.current.orientation showes current orientation, i. e. after screen rotation.
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown: newSeparator = "\n"
            default: newSeparator = " "
            }
            // UIApplication.shared.statusBarOrientation.isLandscape showes previous orientataion, i. e. before screen rotation.
            let splittedTitle = title?.split(separator: UIApplication.shared.statusBarOrientation.isLandscape ? " " : "\n")
            for splittedTitleSubstring in splittedTitle! {
                string += splittedTitleSubstring + String(newSeparator)
            }
            // Send string to the button removing the last symbol as we have one excess character "\n" or " ".
            button.setAttributedTitle(NSAttributedString(string: String(string[..<string.index(before: string.endIndex)]), attributes: attributes), for: .normal)
        }
    }
}

extension String {
    
    /// This method works as follows:
    /// E. g.:
    /// let string = "abc"
    /// print(string.concatByNSeparators(" ", 3))
    /// Prints "abc abc abc abc"
    /// - Parameters:
    ///   - separator: A string separator.
    ///   - n: A number of separator occurrences.
    /// - Returns: A brand new concatenated string.
    func concatByNSeparators(_ separator: String, n: Int) -> String {
        var resultString = ""
        for _ in 0...n {
            resultString += self + separator
        }
        return String(resultString[..<resultString.index(before: resultString.endIndex)])
    }
}
