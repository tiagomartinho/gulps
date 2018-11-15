import UIKit

class ExerciseViewController: UIViewController {

  var completeExerciseHandler: (() -> (Void))?

  convenience init(completeExerciseHandler: @escaping (() -> (Void))) {
    self.init()
    self.completeExerciseHandler = completeExerciseHandler
  }

  private let completeButton: RoundedButton = {
    let button = RoundedButton(buttonColor: Palette.palette_main)
    button.setTitle("Mark as completed", for: .normal)
    button.tintColor = Palette.palette_main
    button.addTarget(self, action: #selector(completedExercises), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Exercises"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
    addCompleteButton()
  }

  private func addCompleteButton() {
    view.addSubview(completeButton)
    completeButton.translatesAutoresizingMaskIntoConstraints = false
    let item: Any
    if #available(iOS 11.0, *) {
      item = view.safeAreaLayoutGuide
    } else {
      item = view
    }
    let height = NSLayoutConstraint(item: completeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
    let bottom = NSLayoutConstraint(item: completeButton, attribute: .bottom, relatedBy: .equal, toItem: item, attribute: .bottom, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: completeButton, attribute: .trailing, relatedBy: .equal, toItem: item, attribute: .trailing, multiplier: 1, constant: -20)
    let leading = NSLayoutConstraint(item: completeButton, attribute: .leading, relatedBy: .equal, toItem: item, attribute: .leading, multiplier: 1, constant: 20)
    let constraints = [height, bottom, trailing, leading]
    NSLayoutConstraint.activate(constraints)
  }

  @objc func dismissView() {
    dismiss(animated: true, completion: nil)
  }

  @objc func completedExercises() {
    dismiss(animated: true, completion: completeExerciseHandler)
  }
}
