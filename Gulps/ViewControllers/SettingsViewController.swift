import UIKit
import AHKActionSheet
import WatchConnectivity

class SettingsViewController: UITableViewController, UIAlertViewDelegate, UITextFieldDelegate {

  @IBOutlet weak var dailyGoalText: UITextField!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var notificationFromLabel: UILabel!
  @IBOutlet weak var notificationToLabel: UILabel!
  @IBOutlet weak var notificationIntervalLabel: UILabel!

  let userDefaults = UserDefaults.groupUserDefaults()

  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString("settings title", comment: "")
    for element in [dailyGoalText] {
      element?.inputAccessoryView = Globals.numericToolbar(element,
                                                          selector: #selector(UIResponder.resignFirstResponder),
                                                          barColor: .palette_main,
                                                          textColor: .white)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
  }

  func updateUI() {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    dailyGoalText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.Gulp.goal.key()))
    notificationSwitch.isOn = userDefaults.bool(forKey: Constants.Notification.on.key())
    notificationFromLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.from.key())):00"
    notificationToLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.to.key())):00"
    notificationIntervalLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.interval.key())) " +  NSLocalizedString("hours", comment: "")
  }

  func updateNotificationPreferences() {
    if (notificationSwitch.isOn) {
      NotificationHelper.unscheduleNotifications()
      NotificationHelper.askPermission()
    } else {
      NotificationHelper.unscheduleNotifications()
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var actionSheet: AHKActionSheet?
    if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1) {
      actionSheet = AHKActionSheet(title: NSLocalizedString("from:", comment: ""))
      for index in 5...22 {
        actionSheet?.addButton(withTitle: "\(index):00", type: .default) { _ in
          self.updateNotificationSetting(Constants.Notification.from.key(), value: index)
        }
      }
    }
    if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2) {
      actionSheet = AHKActionSheet(title: NSLocalizedString("to:", comment: ""))
      let upper = self.userDefaults.integer(forKey: Constants.Notification.from.key()) + 1
      for index in upper...24 {
        actionSheet?.addButton(withTitle: "\(index):00", type: .default) { _ in
          self.updateNotificationSetting(Constants.Notification.to.key(), value: index)
        }
      }
    }
    if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 3) {
      actionSheet = AHKActionSheet(title: NSLocalizedString("every:", comment: ""))
      for index in 1...8 {
        let hour = index > 1 ? NSLocalizedString("hours", comment: "") : NSLocalizedString("hour", comment: "")
        actionSheet?.addButton(withTitle: "\(index) \(hour)", type: .default) { _ in
          self.updateNotificationSetting(Constants.Notification.interval.key(), value: index)
        }
      }
    }
    actionSheet?.show()
  }

  func updateNotificationSetting(_ key: String, value: Int) {
    userDefaults.set(value, forKey: key)
    userDefaults.synchronize()
    updateUI()
    updateNotificationPreferences()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }

  @IBAction func reminderAction(_ sender: UISwitch) {
    userDefaults.set(sender.isOn, forKey: Constants.Notification.on.key())
    userDefaults.synchronize()
    self.tableView.reloadData()
    updateNotificationPreferences()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0) {
      return 1
    } else if (section == 1) {
      if UserDefaults.groupUserDefaults().bool(forKey: Constants.Notification.on.key()) {
        return 4
      } else {
        return 1
      }
    } else {
      return 0
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField == dailyGoalText) {
      storeText(dailyGoalText, toKey: Constants.Gulp.goal.key())
    }
  }

  func storeText(_ textField: UITextField, toKey key: String) {
    guard let text = textField.text else {
      return
    }
    let number = numberFormatter.number(from: text) as? Double
    userDefaults.set(number ?? 0.0, forKey: key)
    userDefaults.synchronize()
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return Globals.numericTextField(textField, shouldChangeCharactersInRange: range, replacementString: string)
  }
}
