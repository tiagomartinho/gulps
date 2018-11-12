import pop

extension DrinkViewController {

  func initAnimation() {
    starButton.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
  }

  func animateStarButton() {
    let rotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
    rotate?.toValue = 2 * Double.pi - Double.pi / 8
    rotate?.springBounciness = 5
    rotate?.removedOnCompletion = true

    let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
    scale?.toValue = NSValue(cgPoint: CGPoint(x: 0.8, y: 0.8))
    scale?.removedOnCompletion = true
    scale?.completionBlock = { (_,_) in
      let sway = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
      sway?.fromValue = -Double.pi / 8
      sway?.toValue = Double.pi / 8
      sway?.duration = 0.75
      sway?.repeatForever = true
      sway?.autoreverses = true
      self.starButton.layer.pop_add(sway, forKey: "sway")
    }

    starButton.pop_add(scale, forKey: "scale")
    starButton.layer.pop_add(rotate, forKey: "rotate")
  }
}
