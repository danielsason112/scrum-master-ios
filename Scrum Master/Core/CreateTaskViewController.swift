import UIKit
import Firebase

class CreateTaskViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var taskStatusSelection: UISegmentedControl!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var createButton: UIButton!
    
    var board: Board?
    var currentUser: User?
    var teamRepository: TeamsRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamRepository = TeamsRepository()
        currentUser = Auth.auth().currentUser
        board = (tabBarController as! BoardTabBarViewController).board
    }
    
    @IBAction func createButtonTriggered(_ sender: Any) {
        if let board = board,
           let user = currentUser,
           let name = nameTextField.text,
           let description = descriptionTextField.text,
           let taskStatus = TaskStatus(rawValue: taskStatusSelection.selectedSegmentIndex) {
            let dueDate = DateConverter.toDbDate(date: dueDatePicker.date)
            let task = Task(name: name, createdAt: DateConverter.toDbDate(date: Date()), description: description, taskStatus: taskStatus, comments: [:], dueDate: dueDate)
            
            teamRepository?.addTask(task: task, board: board, user: user) { data, error in
                if error == nil {
                    self.resetView()
                    self.tabBarController?.selectedIndex = 0
                }
            }
            
        }
    }
    
    func resetView() {
        nameTextField.text = ""
        descriptionTextField.text = ""
        taskStatusSelection.selectedSegmentIndex = 0
        dueDatePicker.date = Date()
    }
}
