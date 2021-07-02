import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainViewController: UIViewController {
    let authSegueIdentifier = "authSegueIdentifier"
    let createTeamIdentifier = "CreateTeamSegueIdentifier"
    let boardsListSegueIdentifier = "boardsListSegueIdentifier"
    let teamDetailsSegueIdentifier = "teamDetailsSegueIdentifier"
    
    private var currentUser: User?
    private var teamsListDataSource: TeamsListDataSource?
    private var teamsRepository: TeamsRepository?
    
    @IBOutlet var welcomeUserLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createTeamIdentifier {
            let dest = segue.destination as! CreateTeamViewController
            dest.userId = currentUser?.uid
        }
        if segue.identifier == teamDetailsSegueIdentifier {
            let dest = segue.destination as! TeamDetailsViewController
            dest.configure(team: sender as! Team)
        }
        if segue.identifier == boardsListSegueIdentifier {
            let dest = segue.destination as! BoardsListViewController
            dest.configure(team: sender as! Team)
        }
    }
    
    override func viewDidLoad() {
        currentUser = Auth.auth().currentUser
        teamsRepository = TeamsRepository()
        tableView.dataSource = teamsListDataSource
        tableView.delegate = self
        
        let optionsBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: "Sign Out", image: UIImage(systemName: "person"), handler: menuHandler)
        ])
        
        optionsBarItem.menu = barButtonMenu
        optionsBarItem.tintColor = UIColor.purple
        navigationItem.rightBarButtonItem = optionsBarItem
        
        tableView.register(UINib(nibName: "TeamCardTableViewCell", bundle: nil), forCellReuseIdentifier: "teamCellIdentifier")
    }
        
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: authSegueIdentifier, sender: self)
        } else {
            welcomeUserLabel.text = "Hi \(currentUser!.displayName!)"
            teamsRepository?.findAll() { data, error in
                let snapshot = data as? DataSnapshot
                if let list = snapshot?.children {
                    var teams: [Team] = []
                    for item in list {
                        if let team = Team(snapshot: item as! DataSnapshot) {
                            teams.append(team)
                        }
                    }
                    self.teamsListDataSource = TeamsListDataSource(teams: teams, currentUserId: self.currentUser!.uid)
                    self.tableView.dataSource = self.teamsListDataSource
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc
    func menuHandler(_: UIAction) {
        try? Auth.auth().signOut()
        currentUser = nil
        performSegue(withIdentifier: authSegueIdentifier, sender: self)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                                didSelectRowAt indexPath: IndexPath) {
        let sender = teamsListDataSource?.teams[indexPath.section == 0]?[indexPath.row]
        if indexPath.section == 0 {
            performSegue(withIdentifier: boardsListSegueIdentifier, sender: sender)
        }
        if indexPath.section == 1 {
            performSegue(withIdentifier: teamDetailsSegueIdentifier, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let textLabel = (view as! UITableViewHeaderFooterView).textLabel {
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont(name: "Futura", size: 20)
            textLabel.text = self.teamsListDataSource?.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}
