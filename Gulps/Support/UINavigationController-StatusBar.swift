import UIKit

/**
 Keeps the navigation bar hidden in the onboarding controllers
 and visible in the others, with a light status bar
 */
extension UINavigationController {
  open override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  open override var childForStatusBarHidden : UIViewController? {
    return self.topViewController
  }
}
