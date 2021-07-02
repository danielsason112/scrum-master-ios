import UIKit

class UpdateTaskViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var taskStatusPicker: UISegmentedControl!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var task: Task?
    var teamRepository: TeamsRepository?
    
    func configure(task: Task) {
        self.task = task
    }
    
    func updateView() {
        if let task = self.task {
            nameLabel.text = task.name
            descriptionTextField.text = task.description
            taskStatusPicker.selectedSegmentIndex = task.taskStatus.rawValue
            if let dueDate = DateConverter.toDateObject(dbDate: task.dueDate) {
                dueDatePicker.date = dueDate
            }
        }
    }
    
    override func viewDidLoad() {
        teamRepository = TeamsRepository()
        updateView()
    }
    
    @IBAction func updateButtonTriggered(_ sender: Any) {
        if let description = descriptionTextField.validName(),
           let taskStatus = TaskStatus(rawValue: taskStatusPicker.selectedSegmentIndex),
           let t = task,
           let ref = task?.ref {
            let dueDate = DateConverter.toDbDate(date: dueDatePicker.date)
            let updated = Task(name: t.name, createdAt: t.createdAt, description: description, taskStatus: taskStatus, comments: [:], dueDate: dueDate)
            teamRepository?.updateTaskByRef(taskRef: ref, task: updated, responseObserver: { data, error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    @IBAction func deleteButtonTriggered(_ sender: Any) {
        if let ref = task?.ref {
            teamRepository?.removeTaskByRef(taskRef: ref) { data, error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
