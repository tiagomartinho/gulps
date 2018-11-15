import UIKit
import BAFluidView
import UICountingLabel
import Realm
import BubbleTransition
import CoreMotion

open class DrinkViewController: UIViewController, UIAlertViewDelegate, UIViewControllerTransitioningDelegate {

  @IBOutlet open weak var percentageLabel: UICountingLabel!
  @IBOutlet open weak var addButton: UIButton!
  @IBOutlet open weak var minusButton: UIButton!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var meterContainerView: UIView!

  open var userDefaults = UserDefaults.groupUserDefaults()
  open var progressMeter: BAFluidView?
  var realmNotification: RLMNotificationToken?
  var expanded = false
  let transition = BubbleTransition()
  let manager = CMMotionManager()

  // MARK: - Life cycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    self.title = NSLocalizedString("drink title", comment: "")

    initAnimation()

    percentageLabel.animationDuration = 1.5
    percentageLabel.format = "%d%%";
    percentageLabel.textColor = Palette.palette_main

    addButton.backgroundColor = Palette.palette_main
    manager.accelerometerUpdateInterval = 0.01
    manager.deviceMotionUpdateInterval = 0.01;
    manager.startDeviceMotionUpdates(to: OperationQueue.main) {
      (motion, error) in
      if let motion = motion {
        let roation = atan2(motion.gravity.x, motion.gravity.y) - Double.pi
        self.progressMeter?.transform = CGAffineTransform(rotationAngle: CGFloat(roation))
      }
    }

    realmNotification = EntryHandler.sharedHandler.realm.observe { note, realm in
      self.updateUI()
    }

    NotificationCenter.default.addObserver(self, selector: #selector(DrinkViewController.updateUI), name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  open override var prefersStatusBarHidden: Bool {
    return false
  }

  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    view.layoutIfNeeded()

    // Init the progress meter programamtically to avoid an animation glitch
    if progressMeter == nil {
      let width = meterContainerView.frame.size.width
      progressMeter = BAFluidView(frame: CGRect(x: 0, y: 0, width: width, height: width), maxAmplitude: 40, minAmplitude: 8, amplitudeIncrement: 1)
      progressMeter!.backgroundColor = .clear
      progressMeter!.fillColor = .palette_main
      progressMeter!.fillAutoReverse = false
      progressMeter!.fillDuration = 1.5
      progressMeter!.fillRepeatCount = 0;
      progressMeter?.tintColor = .palette_main
      progressMeter?.strokeColor = .palette_main
      meterContainerView.addSubview(progressMeter!)
      meterContainerView.layer.cornerRadius = 25
      meterContainerView.backgroundColor = Palette.palette_lightGray.withAlphaComponent(0.25)
      updateUI()
    }

    // Ask (just once) the user for feedback once he's logged more than 10 exercises
    if !userDefaults.bool(forKey: "FEEDBACK") {
      if EntryHandler.sharedHandler.overallQuantity() > 10 {
        animateStarButton()
      }
    }
  }

  // MARK: - UI update

  func updateCurrentEntry(_ delta: Double) {
    EntryHandler.sharedHandler.addGulp(delta)
  }

  @objc func updateUI() {
    let percentage = EntryHandler.sharedHandler.currentPercentage()
    percentageLabel.countFromCurrentValue(to: CGFloat(round(percentage)))
    var fillTo = Double(percentage / 100.0)
    if fillTo > 1 {
      fillTo = 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.progressMeter?.fill(to: NSNumber(value: fillTo))
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "feedback" {
      let controller = segue.destination
      controller.transitioningDelegate = self
      controller.modalPresentationStyle = .custom
      userDefaults.set(true, forKey: "FEEDBACK")
      userDefaults.synchronize()
    }
  }

  // MARK: - Actions

  @IBAction func addButtonAction(_ sender: UIButton) {
    let exerciseVC = ExerciseViewController(completeExerciseHandler: addExercise)
    let navigationVC = UINavigationController(rootViewController: exerciseVC)
    if #available(iOS 11.0, *) {
      navigationVC.navigationBar.prefersLargeTitles = true
      navigationVC.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    present(navigationVC, animated: true, completion: nil)
  }

  private func addExercise() {
    Globals.showPopTipOnceForKey("UNDO_HINT", userDefaults: userDefaults,
                                 popTipText: NSLocalizedString("undo poptip", comment: ""),
                                 inView: view,
                                 fromFrame: minusButton.frame)
    let portion = Constants.Gulp.small.key()
    updateCurrentEntry(userDefaults.double(forKey: portion))
  }

  @IBAction func removeGulpAction() {
    let controller = UIAlertController(title: NSLocalizedString("undo title", comment: ""), message: NSLocalizedString("undo message", comment: ""), preferredStyle: .alert)
    let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in }
    let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .cancel) { _ in
      EntryHandler.sharedHandler.removeLastGulp()
    }
    [yes, no].forEach { controller.addAction($0) }
    present(controller, animated: true) {}
  }

  // MARK: - UIViewControllerTransitioningDelegate

  open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    let center = CGPoint(x: starButton.center.x, y: starButton.center.y + 64)
    transition.startingPoint = center
    transition.bubbleColor = UIColor(red: 245.0/255.0, green: 192.0/255.0, blue: 24.0/255.0, alpha: 1)
    return transition
  }

  open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = CGPoint(x: starButton.center.x, y: starButton.center.y + 64)
    transition.bubbleColor = UIColor.palette_yellow
    starButton.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    return transition
  }

  // MARK: - Tear down

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
