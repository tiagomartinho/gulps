import UIKit

class ExercisesTableViewCell: UITableViewCell {

  var exercise: Exercise? {
    didSet {
      imageBeforeView.image = exercise?.imageBefore
      imageAfterView.image = exercise?.imageAfter
      titleLabel.text = exercise?.title
      descriptionLabel.text = exercise?.description
    }
  }

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.distribution = .fill
    stackView.alignment = .fill
    return stackView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    return label
  }()


  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .callout)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let imagesStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 12
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    return stackView
  }()

  private let imageBeforeView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.height(200)
    return imageView
  }()

  private let imageAfterView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.height(200)
    return imageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    stackView.addArrangedSubview(titleLabel)

    imagesStackView.addArrangedSubview(imageBeforeView)
    imagesStackView.addArrangedSubview(imageAfterView)
    stackView.addArrangedSubview(imagesStackView)

    stackView.addArrangedSubview(descriptionLabel)
    addSubview(stackView)
    let insets = UIEdgeInsets(top: 12, left: 8, bottom: -12, right: -8)
    stackView.edges(to: self, insets: insets)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
