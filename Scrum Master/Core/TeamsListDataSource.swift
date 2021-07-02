import UIKit

class TeamsListDataSource: NSObject {
    var teams: [Bool:[Team]] = [:]
    
    init(teams: [Team], currentUserId: String) {
        var teamsDict: [Bool:[Team]] = [
            true: [],
            false: []]
        teams.forEach({team in
            team.members[currentUserId] == nil ? teamsDict[false]?.append(team) :
                teamsDict[true]?.append(team)
        })
        self.teams = teamsDict
    }
}

extension TeamsListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "My Teams"
        case 1:
            return "Teams list"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams[section == 0]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellIdentifier", for: indexPath) as! TeamCardTableViewCell
        
        let isJoinable = indexPath.section == 1
        
        cell.configure(team: teams[indexPath.section == 0]?[indexPath.row], isJoinable: isJoinable)
        
        return cell
    }
    
    
}
