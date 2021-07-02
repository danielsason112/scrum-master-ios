import UIKit
import Firebase

class TasksListViewController: UITableViewController {
    let taskCardCellIdentifier = "taskCardCellIdentifier"
    let logCellIdentifier = "logCellIdentifier"
    let updateTaskSegueIdentifier = "updateTaskSegue"
    
    var board: Board?
    var teamRepository: TeamsRepository?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateTaskSegueIdentifier {
            if let task = sender as? Task {
                let dest = segue.destination as! UpdateTaskViewController
                dest.configure(task: task)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamRepository = TeamsRepository()
        
        board = (tabBarController as! BoardTabBarViewController).board
        tableView.register(UINib(nibName: "TaskCardTableViewCell", bundle: nil), forCellReuseIdentifier: taskCardCellIdentifier)
        
        tableView.register(UINib(nibName: "LogTableViewCell", bundle: nil), forCellReuseIdentifier: logCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let ref = board?.ref {
            teamRepository?.findBoardByRef(boardRef: ref, responseObserver: { data, error in
                if error == nil {
                    self.board = Board(snapshot: data as! DataSnapshot)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? TaskCardTableViewCell,
           let task = cell.task {
            performSegue(withIdentifier: updateTaskSegueIdentifier, sender: task)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return board?.tasks?.count ?? 0
        case 1:
            return board?.logs.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Tasks"
        default:
            return "Logs"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.section == 0 ? taskCardCellIdentifier : logCellIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let tasks = board?.tasks {
                let taskArr = Array(tasks.values).sorted(by: {$0.taskStatus.rawValue < $1.taskStatus.rawValue})
                let task = taskArr[indexPath.row]
                (cell as! TaskCardTableViewCell).configure(task: task)
            }
            break
        case 1:
            if let logs = board?.logs {
                let keysArr = Array(logs.keys).sorted()
                let key = keysArr.reversed()[indexPath.row]
                (cell as! LogTableViewCell).configure(logKey: key, logValue: logs[key])
            }
        default:
            break
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let textLabel = (view as! UITableViewHeaderFooterView).textLabel {
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont(name: "Futura", size: 20)
            textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        }
    }
}
