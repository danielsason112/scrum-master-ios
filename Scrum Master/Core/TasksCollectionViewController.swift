import UIKit
import Firebase

class TasksCollectionViewController: UICollectionViewController {
    let taskCollectionViewCellIdentifier = "taskCollectionViewCellIdentifier"
    let taskHeaderCellIdentifier = "taskHeaderCell"
    let updateTaskSegueIdentifier = "updateTaskSegueIdentifier"
    
    var board: Board?
    var tasks: [Int: [Task]] = [:]
    var teamRepository: TeamsRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamRepository = TeamsRepository()
        
        board = (tabBarController as! BoardTabBarViewController).board
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let ref = board?.ref {
            teamRepository?.findBoardByRef(boardRef: ref, responseObserver: { data, error in
                if error == nil {
                    self.board = Board(snapshot: data as! DataSnapshot)
                    self.updateView()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateTaskSegueIdentifier {
            if let task = sender as? Task {
                let dest = segue.destination as! UpdateTaskViewController
                dest.configure(task: task)
            }
        }
    }
    
    func updateView() {
        if let tasksList = board?.tasks {
            let taskArr = Array(tasksList.values)
            tasks = Dictionary(grouping: taskArr, by: {$0.taskStatus.rawValue})
            collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as? TaskCollectionViewCell,
           let task = cell.task {
            performSegue(withIdentifier: updateTaskSegueIdentifier, sender: task)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (tasks[section]?.count ?? 0) + 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: taskHeaderCellIdentifier, for: indexPath) as! TaskCollectionViewHeaderCell
            
            if let taskStatus = TaskStatus(rawValue: indexPath.section) {
                headerCell.configure(taskStatus: taskStatus)
                headerCell.shadowDecorate()
            }
            
            return headerCell
        }
        
        if indexPath.row == self.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "footerCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellIdentifier, for: indexPath) as! TaskCollectionViewCell
        
        if let task = tasks[indexPath.section]?[indexPath.row - 1] {
            cell.configure(task: task)
            cell.shadowDecorate()
        }
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        TaskStatus.allCases.count
    }
}


extension TasksCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 180.0, height: 50.0)
        }
        return CGSize(width: 180.0, height: 80.0)
    }
}

extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
