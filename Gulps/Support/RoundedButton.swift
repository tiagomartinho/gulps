import UIKit

class RoundedButton: UIButton {

  var setButtonColor: UIColor? {
    didSet {
      UIView.animate(withDuration: 0.25) {
        self.backgroundColor = self.setButtonColor
      }
    }
  }

  private var buttonColor: UIColor {
    return setButtonColor ?? Palette.palette_main
  }

  convenience init(buttonColor: UIColor) {
    self.init()
    setButtonColor = buttonColor
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    backgroundColor = buttonColor
    layer.cornerRadius = 8
    clipsToBounds = true
    setTitleColor(.white, for: [])
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
  }

  override var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? buttonColor : Palette.palette_lightGray
    }
  }

  var toggledOn: Bool = true {
    didSet {
      if !isEnabled {
        backgroundColor = Palette.palette_lightGray
        return
      }
      backgroundColor = toggledOn ? buttonColor : Palette.palette_lightGray
    }
  }
}

