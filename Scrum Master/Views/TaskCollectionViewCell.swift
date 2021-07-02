import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    var task: Task?
    
    func configure(task: Task) {
        self.task = task
        nameLabel.text = task.name
        dueDateLabel.text = DateConverter.toDisplayDate(dbDate: task.dueDate)
    }
}
