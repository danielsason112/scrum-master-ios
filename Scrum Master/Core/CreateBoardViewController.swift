import UIKit
import FirebaseAuth

class CreateBoardViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    
    private var teamRepository: TeamsRepository?
    
    var team: Team?
    
    func configure(team: Team) {
        self.team = team
    }
    
    override func viewDidLoad() {
        teamRepository = TeamsRepository()
    }
    @IBAction func createButtonTriggered(_ sender: Any) {
        let name = nameTextField.text
        if CommonValidator.validateName(name: name),
           let key = team?.key,
           let user = Auth.auth().currentUser {
            teamRepository?.addBoard(teamKey: key, user: user, boardName: name!) { data, error in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
