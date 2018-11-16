import UIKit
import TinyConstraints

class ExercisesTableViewController: UITableViewController {

  let reuseIdentifier = "ExercisesTableViewCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.allowsSelection = false
    tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ExercisesTableViewCell
    let cell = dequeuedCell ?? ExercisesTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    cell.exercise = Exercise(title: "Goldfish", description: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", imageBefore: UIImage(named: "open")!, imageAfter: UIImage(named: "closed")!)
    return cell
  }
}
