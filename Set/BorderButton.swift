

import UIKit

@IBDesignable class BorderButton: UIButton {
    @IBInspectable var borderColor:UIColor   = DefaultValues.borderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = DefaultValues.borderWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = DefaultValues.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure () {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        clipsToBounds = true
    }
    
    
    private struct DefaultValues {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 4.0
        static let borderColor: UIColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
