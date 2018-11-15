import UIKit

class ExercisesTableViewCell: UITableViewCell {
}

class ExercisesTableViewController: UITableViewController {

  let reuseIdentifier = "ExercisesTableViewCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
    let newCell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    let cell = dequeuedCell ?? newCell
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
}
