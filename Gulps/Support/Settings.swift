import Foundation

open class Settings {
  open class func registerDefaults() {
    let userDefaults = UserDefaults.groupUserDefaults()
    if (!userDefaults.bool(forKey: "DEFAULTS_INSTALLED")) {
      userDefaults.set(true, forKey: "DEFAULTS_INSTALLED")
      userDefaults.set(1, forKey: Constants.Gulp.small.key())
      userDefaults.set(6, forKey: Constants.Gulp.goal.key())
      userDefaults.set(false, forKey: Constants.Notification.on.key())
      userDefaults.set(10, forKey: Constants.Notification.from.key())
      userDefaults.set(22, forKey: Constants.Notification.to.key())
      userDefaults.set(2, forKey: Constants.Notification.interval.key())
    }
    userDefaults.synchronize()
  }
}
