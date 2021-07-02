import UIKit

class TaskCollectionViewHeaderCell: UICollectionViewCell {
    @IBOutlet var titleLabal: UILabel!
    
    func configure(taskStatus: TaskStatus) {
        titleLabal.text = taskStatus.displayName()
        titleLabal.textColor = UIColor.white
        contentView.backgroundColor = taskStatus.color()
    }
}
