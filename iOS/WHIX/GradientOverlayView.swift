import UIKit

class GradientOverlayView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor,
        ]
    }
}
