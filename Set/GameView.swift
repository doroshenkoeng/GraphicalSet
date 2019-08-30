//
//  GameView.swift
//  GraphicalSet
//
//  Created by Сергей Дорошенко on 18/08/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

@IBDesignable

/// This view contains all the playing card views.
class GameView: UIView {
    
    /// Contains all the playing card views.
    var playingCardViews = [PlayingCardView]() {
        willSet { removeSubviews() }
        didSet { addSubviews() }
    }
    
    /// Deletes all the playing card views from the game view.
    private func removeSubviews() {
        for cardView in playingCardViews { cardView.removeFromSuperview() }
    }
    
    /// Appends all the playing card views to the game view.
    private func addSubviews() {
        for cardView in playingCardViews { addSubview(cardView) }
    }
    
    /// Lays out playing card views.
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(SizeRatio.cellAspectRatio), frame: bounds)
        grid.cellCount = playingCardViews.count
        for index in playingCardViews.indices {
            playingCardViews[index].frame = grid[index]?.insetBy(dx: SizeRatio.horizonalSpacing, dy: SizeRatio.verticalSpacing) ?? CGRect.zero
        }
    }
    
    /// Some constants for the grid lay out.
    struct SizeRatio {
        static let cellAspectRatio: CGFloat = 5.0 / 8.0
        static let horizonalSpacing: CGFloat = 2
        static let verticalSpacing: CGFloat = 2
    }
}

