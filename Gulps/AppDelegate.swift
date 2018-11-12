import UIKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var realmNotification: RLMNotificationToken?
  let watchConnectivityHelper = WatchConnectivityHelper()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    setupAppearance()
    Settings.registerDefaults()

    let userDefaults = UserDefaults.groupUserDefaults()
    if (!userDefaults.bool(forKey: Constants.General.onboardingShown.key())) {
      loadOnboardingInterface()
    } else {
      loadMainInterface()
      checkVersion()
    }

    return true
  }

  /**
   Check the app version and perform required tasks when upgrading
   */
  func checkVersion() {
    let userDefaults = UserDefaults.groupUserDefaults()
    let current = userDefaults.integer(forKey: "BUNDLE_VERSION")
    if let versionString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let version = Int(versionString) {
      if current < 13 {
        NotificationHelper.rescheduleNotifications()
      }
      userDefaults.set(version, forKey: "BUNDLE_VERSION")
      userDefaults.synchronize()
    }
  }

  /**
   Sets the main appearance of the app
   */
  func setupAppearance() {
    Globals.actionSheetAppearance()

    UIApplication.shared.statusBarStyle = .lightContent

    UITabBar.appearance().tintColor = .palette_main

    if let font = UIFont(name: "KaushanScript-Regular", size: 22) {
      UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    UINavigationBar.appearance().barTintColor = .palette_main
    UINavigationBar.appearance().tintColor = .white

    window?.backgroundColor = .white
  }

  /**
   Present the onboarding controller if needed
   */
  func loadOnboardingInterface() {
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    if let controller = storyboard.instantiateInitialViewController() {
      self.window?.rootViewController = controller
    }
  }

  /**
   Present the main interface
   */
  func loadMainInterface() {
    realmNotification = watchConnectivityHelper.setupWatchUpdates()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let controller = storyboard.instantiateInitialViewController() {
      self.window?.rootViewController = controller
    }
  }

  // MARK: - Notification handler

  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    if let identifier = identifier {
      NotificationHelper.handleNotification(notification, identifier: identifier)
    }
    completionHandler()
  }

  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    if (UIApplication.shared.scheduledLocalNotifications?.count == 0) {
      NotificationHelper.registerNotifications()
    }
  }
}
