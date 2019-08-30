//
//  ViewController.swift
//  Set
//
//  Created by Сергей Дорошенко on 27/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit


/// This class is a controller of the card game set view.
@IBDesignable
class ViewController: UIViewController {
    
    /// The card game set model object.
    private var game = Set()

    /// The game view outlet responsible for swipe and rotate gestures.
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(touchDeal3Button))
            swipe.direction = .down
            gameView.addGestureRecognizer(swipe)
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateCards))
            gameView.addGestureRecognizer(rotate)
        }
    }

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deal3MoreButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var cheatButton: UIButton!

    /// Changes all the viewcontroller subviews in accordance with model changes.
    private func updateViewFromModel() {
        updateCardViewsFromModel()
        lastHint = 0
        scoreLabel.text = "Score: \(game.score)"
    }

    /// Updates card views according to model changes.
    private func updateCardViewsFromModel() {
        if gameView.playingCardViews.count - game.visibleCards.count > 0 {
            let cardViews = gameView.playingCardViews[..<game.visibleCards.count]
            gameView.playingCardViews = Array(cardViews)
        }
        let numberCardViews =  gameView.playingCardViews.count
        
        for index in game.visibleCards.indices {
            let card = game.visibleCards[index]
            if  index > (numberCardViews - 1) {
                let cardView = PlayingCardView()
                updateCardView(cardView,for: card)
                addTapGestureRecognizer(for: cardView)
                gameView.playingCardViews += [cardView]
            } else {
                let cardView = gameView.playingCardViews[index]
                updateCardView(cardView,for: card)
            }
        }
    }

    /// Adds a tap gesture recognizer for the given playing card view.
    ///
    /// - Parameter cardView: A playing card view for gesture recognizing.
    private func addTapGestureRecognizer(for cardView: PlayingCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }

    /// Responds to a tap gesture.
    ///
    /// - Parameter recognizer: A tap gesture recognizer.
    @objc private func tapCard(recognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if  let cardView = recognizer.view! as? PlayingCardView {
                game.chooseCard(at: gameView.playingCardViews.firstIndex(of: cardView)!)
            }
        default:
            break
        }
        updateViewFromModel()
    }

    /// Updates the given playing card view according to the given card.
    ///
    /// - Parameters:
    ///   - cardView: A playing card view need to be updated.
    ///   - card: A member of a Card struct need to update view.
    private func updateCardView(_ cardView: PlayingCardView, for card: Card){
        cardView.card = card
        cardView.isSelected = game.cardsSelected.contains(card)
        if let isSet = game.isSet {
            if game.cardsTryMatched.contains(card) {
                cardView.isMatched = isSet
            }
        } else {
            cardView.isMatched = nil
        }
    }

    /// Responds to deal 3 more button touching.
    @IBAction func touchDeal3Button() {
        game.deal3()
        updateViewFromModel()
    }
    
    /// The index of the last taken set in the hints array (which contatins all the visible sets at that moment).
    private var lastHint = 0
    
    /// Responds to cheat button touching.
    @IBAction func touchCheatButton() {
        if  game.hints.count > 0 {
            game.hints[lastHint].forEach{ gameView.playingCardViews[$0].hint() }
        }
    }

    /// Responds to the new game button touching.
    @IBAction func touchNewGameButton() {
        game = Set()
        gameView.playingCardViews.removeAll()
        updateViewFromModel()
    }

    /// Shuffles the cards whenever user rotates the card views.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    @objc func rotateCards(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad ()
        updateViewFromModel()
    }
}
