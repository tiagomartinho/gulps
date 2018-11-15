import UIKit

typealias Palette = UIColor
extension Palette {

  class var palette_main: UIColor {
    return #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
  }

  class var palette_yellow: UIColor {
    return #colorLiteral(red: 0.9450980392, green: 0.768627451, blue: 0.05882352941, alpha: 1)
  }

  class var palette_confirm: UIColor {
    return #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
  }

  class var palette_destructive: UIColor {
    return #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
  }

  class var palette_lightGray: UIColor {
    return #colorLiteral(red: 0.7411764706, green: 0.7647058824, blue: 0.7803921569, alpha: 1)
  }
}
