import UIKit

class TaskCardTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var taskStatusLabel: UILabel!
    @IBOutlet var taskColorView: UIView!
    
    var task: Task?
    
    func configure(task: Task?) {
        self.task = task
        
        updateView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateView() {
        if let task = self.task {
            nameLabel.text = task.name
            descriptionLabel.text = task.description
            createdAtLabel.text = DateConverter.toDisplayDate(dbDate: task.createdAt)
            dueDateLabel.text = DateConverter.toDisplayDate(dbDate: task.dueDate)
            taskStatusLabel.text = task.taskStatus.displayName()
            taskColorView.backgroundColor = task.taskStatus.color()
        }
    }
    
}
