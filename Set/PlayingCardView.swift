//
//  PlayingCardView.swift
//  GraphicalSet
//
//  Created by Сергей Дорошенко on 17/08/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

@IBDesignable

/// This cocoa touch class is a custom uiview of a set playing card.
class PlayingCardView: UIView {
    
    /// This property showes which card is to draw.
    var card = Card(color: .type1, shape: .type3, fill: .type3, numberOfShapes: .type3) { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    /// The card's background color.
    var cardBackgroundColor: UIColor = UIColor.white { didSet { setNeedsDisplay()} }
    
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var isSelected:Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isMatched: Bool? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    /// Draws the receiver’s image within the passed-in rectangle.
    ///
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated. The first time your view is drawn, this rectangle is typically the entire visible bounds of your view. However, during subsequent drawing operations, the rectangle may specify only part of your view.
    override func draw(_ rect: CGRect) {
        chooseColor().setFill()
        chooseColor().setStroke()
        
        switch card.numberOfShapes {
        case .type1:
            let origin = CGPoint(x: shapeFrameWidth.minX, y: shapeFrameWidth.midY - shapeHeight/2)
            let size = CGSize(width: shapeFrameWidth.width, height: shapeHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            
        case .type2:
            let origin = CGPoint(x: shapeFrameWidth.minX, y: shapeFrameWidth.midY - heightBetweenShapes/2 - shapeHeight)
            let size = CGSize(width: shapeFrameWidth.width, height: shapeHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: shapeHeight + heightBetweenShapes)
            drawShape(in: secondRect)
            
        case .type3:
            let origin = CGPoint (x: shapeFrameWidth.minX, y: shapeFrameWidth.minY)
            let size = CGSize(width: shapeFrameWidth.width, height: shapeHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: shapeHeight + heightBetweenShapes)
            drawShape(in: secondRect)
            let thirdRect = secondRect.offsetBy(dx: 0, dy: shapeHeight + heightBetweenShapes)
            drawShape(in: thirdRect)
        }
    }
    
    /// Marks the hinted cards.
    func hint() {
        layer.borderWidth = borderWidth
        layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    
    /// Stripes the shape within the given uibezier path.
    ///
    /// - Parameter shape: A UIBezierPath which the vertical lines will be drawn in.
    func stripeShape(_ shape: UIBezierPath) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        shape.addClip()
        
        let widthBetweenVerticalLines = 5
        let stripe = UIBezierPath()
        stripe.lineWidth = 1
        stripe.move(to: CGPoint(x: shape.bounds.minX, y: shape.bounds.minY))
        stripe.addLine(to: CGPoint(x: shape.bounds.minX, y: shape.bounds.maxY))
        for _ in 0..<Int((shape.bounds.maxX - shape.bounds.minX)) / widthBetweenVerticalLines {
            let translation = CGAffineTransform(translationX: CGFloat(widthBetweenVerticalLines), y: 0)
            stripe.apply(translation)
            stripe.stroke()
            
        }
        context?.restoreGState()
    }
    
    /// Opts the drawing color according to card.color
    ///
    /// - Returns: Card's color
    func chooseColor() -> UIColor {
        switch card.color {
        case .type1: return UIColor.green
        case .type2: return UIColor.red
        case .type3: return UIColor.purple
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 2
    }
    
    /// Draws the card shape in the given rectangular area.
    ///
    /// - Parameter rect: A rectangle which the shape will be drawn in.
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        switch card.shape {
        case .type1: path = drawType1Shape(in: rect)
        case .type2: path = drawType2Shape(in: rect)
        case .type3: path = drawType3Shape(in: rect)
        }
        
        path.lineWidth = 3.0
        path.stroke()
        switch card.fill {
        case .type2:
            path.fill()
        case .type3:
            stripeShape(path)
        default:
            break
        }
    }
    
    /// Draws a diamond in the given rectangular area.
    ///
    /// - Parameter rect: A rectangle which the shape will be drawn in.
    /// - Returns: Diamond's uibezier path within the given rectangle.
    private func drawType1Shape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
        return path
    }
    
    /// Draws an oval in the given rectangular area.
    ///
    /// - Parameter rect: A rectangle which the shape will be drawn in.
    /// - Returns: Oval's uibezier path within the given rectangle.
    private func drawType3Shape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let radius = rect.height / 2
        path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi/2, clockwise: true)
        path.close()
        return path
    }
    
    /// Draws a squiggle in the given rectangular area.
    ///
    /// - Parameter rect: A rectangle which the shape will be drawn in.
    /// - Returns: Squiggle's uibezier path within the given rectangle.
    private func drawType2Shape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let sqdx = rect.width * 0.1
        let sqdy = rect.height * 0.2
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        
        path.addCurve(to: CGPoint(x: rect.minX + rect.width * 1/2, y: rect.minY + rect.height / 8), controlPoint1: CGPoint(x: rect.minX, y: rect.minY), controlPoint2: CGPoint(x: rect.minX + rect.width * 1/2 - sqdx, y: rect.minY + rect.height / 8 - sqdy))
        path.addCurve(to: CGPoint(x: rect.minX + rect.width * 4/5, y: rect.minY + rect.height / 8), controlPoint1: CGPoint(x: rect.minX + rect.width * 1/2 + sqdx, y: rect.minY + rect.height / 8 + sqdy), controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - sqdx, y: rect.minY + rect.height / 8 + sqdy))
        path.addCurve(to: CGPoint(x: rect.minX + rect.width, y: rect.minY + rect.height / 2), controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + sqdx, y: rect.minY + rect.height / 8 - sqdy ), controlPoint2: CGPoint(x: rect.minX + rect.width, y: rect.minY))
        
        let lowerSquiggle = UIBezierPath(cgPath: path.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity
            .translatedBy(x: bounds.width, y: bounds.height))
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.append(lowerSquiggle)
        return path
    }

    /// Determines card's appearance at the certain game moment.
    private func configureState() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        isOpaque = false
        contentMode = .redraw

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        if isSelected {
            layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
        }
        if let matched = isMatched {
            if matched {
                layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor
            } else {
                layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
            }
        }
    }

    /// Lays out subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureState()
    }
    
    /// The max zoomed rectangle.
    private var maxShapeFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }
    
    /// The width of shape's frame.
    private var shapeFrameWidth: CGRect {
        let faceWidth = maxShapeFrame.height * AspectRatio.faceFrame
        return maxShapeFrame.insetBy(dx: (maxShapeFrame.width - faceWidth)/2, dy: 0)
    }
    
    /// The distance between the max and min shape points.
    private var shapeHeight: CGFloat {
        return shapeFrameWidth.height * SizeRatio.pipHeightToFaceHeight
    }
    
    /// The distance between the shapes.
    private var heightBetweenShapes: CGFloat {
        return (shapeFrameWidth.height - (3 * shapeHeight)) / 2
    }
    
    /// The corner radius of a card view.
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    /// The width of view's layer borders.
    private let borderWidth: CGFloat = 5.0
    
    /// Sets the view size.
    private struct SizeRatio {
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pipHeightToFaceHeight: CGFloat = 0.25
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    private struct AspectRatio {
        static let faceFrame: CGFloat = 5.0 / 8.0
    }
}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}




