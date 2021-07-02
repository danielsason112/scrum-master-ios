import UIKit
import Firebase

class BoardsListViewController: UIViewController {
    let createBoardSegueIdentifier = "createBoardSegueIdentifier"
    let boardCellIdentifier = "boardCellIdentifier"
    let profileCellIdentifier = "profileCellIdentifier"
    
    @IBOutlet var tableView: UITableView!
    
    var team: Team?
    var users: [String: Profile]?
    var teamRepository: TeamsRepository?
    var profilesRepository: ProfilesRepository?
    
    func configure(team: Team) {
        self.team = team
    }
    
    override func viewDidLoad() {
        teamRepository = TeamsRepository()
        profilesRepository = ProfilesRepository()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let key = team?.key {
            teamRepository?.findTeamByKey(key: key, responseObserver: {data, error in
                if error == nil {
                    self.team = Team(snapshot: data as! DataSnapshot)
                    if let members = self.team?.members {
                        let uids = Array(members.keys)
                        self.profilesRepository?.findProfilesByUid(uids: uids, responseObserver: {data, error in
                            if error == nil {
                                self.users = data as? [String: Profile]
                            }
                            self.tableView.reloadData()
                        })
                    }
                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createBoardSegueIdentifier,
           let t = team {
            let dest = segue.destination as! CreateBoardViewController
            dest.configure(team: t)
        }
        
        if segue.identifier == "boardSegueIdentifier",
           let b = (sender as! BoardTableViewCell).board {
            let dest = segue.destination as! BoardTabBarViewController
            dest.configure(board: b)
        }
    }
}

extension BoardsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? team?.boards?.count ?? 0 : team?.members.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? boardCellIdentifier : profileCellIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if indexPath.section == 0,
           let board = team?.boards?.values.sorted(by: {$0.createdAt < $1.createdAt})[indexPath.row] {
            (cell as? BoardTableViewCell)?.configure(board: board)
        }
        
        if indexPath.section == 1,
           let members = users?.values {
            let profile = Array(members)[indexPath.row]
            (cell as? ProfileTableViewCell)?.configure(profile: profile)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Boards"
        default:
            return "Team Members"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let textLabel = (view as! UITableViewHeaderFooterView).textLabel {
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont(name: "Futura", size: 20)
            textLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}
