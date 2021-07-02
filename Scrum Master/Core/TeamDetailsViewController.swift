import UIKit
import FirebaseAuth

class TeamDetailsViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var joinButton: UIButton!
    
    var team: Team?
    var teamsRepository: TeamsRepository?
        
    func configure(team: Team) {
        self.team = team
    }
    
    override func viewDidLoad() {
        teamsRepository = TeamsRepository()
        
        nameLabel.text = team?.name
        descriptionLabel.text = team?.description
    }
    
    @IBAction func joinButtonTriggered(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid,
           let key = team?.name {
            teamsRepository?.joinTeam(userId: uid, key: key, responseObserver: { data, error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}
