import UIKit

class ExerciseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Exercises"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
  }

  @objc func dismissView() {
    dismiss(animated: true, completion: nil)
  }
}
