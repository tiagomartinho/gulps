import UIKit
import TinyConstraints

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
    addExercisesTable()
  }

  private func addExercisesTable() {
    let tableView = UIView()
    tableView.backgroundColor = .red
    view.addSubview(tableView)
    let tableViewController = ExercisesTableViewController()
    if #available(iOS 10.0, *) {
      tableView.edgesToSuperview(excluding: .bottom, insets: .uniform(8), usingSafeArea: true)
    } else {
      tableView.edges(to: view, excluding: .bottom, insets: .uniform(8))
    }
    tableView.bottomToTop(of: completeButton)
    addChild(tableViewController)
    tableViewController.view.frame = tableView.frame
    tableView.addSubview(tableViewController.view)
    tableViewController.didMove(toParent: self)
  }

  private func addCompleteButton() {
    view.addSubview(completeButton)
    if #available(iOS 10.0, *) {
      completeButton.edgesToSuperview(excluding: .top, insets: .uniform(8), usingSafeArea: true)
    } else {
      completeButton.edges(to: view, excluding: .top, insets: .uniform(8))
    }
    completeButton.height(60)
  }

  @objc func dismissView() {
    dismiss(animated: true, completion: nil)
  }

  @objc func completedExercises() {
    dismiss(animated: true, completion: completeExerciseHandler)
  }
}
