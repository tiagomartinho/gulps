import UIKit
import TinyConstraints

class ExercisesTableViewController: UITableViewController {

  let reuseIdentifier = "ExercisesTableViewCell"

  let exercises = ExerciseList.exercises
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.allowsSelection = false
    tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exercises.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ExercisesTableViewCell
    let cell = dequeuedCell ?? ExercisesTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    cell.exercise = exercises[indexPath.row]
    return cell
  }
}
