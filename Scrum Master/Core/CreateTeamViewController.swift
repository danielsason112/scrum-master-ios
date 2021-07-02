import UIKit

class CreateTeamViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    
    var userId: String?
    
    private var teamRepository: TeamsRepository?
    
    @IBAction func createButtonTriggered(_ sender: Any) {
        let name = nameTextField.text
        let description = descriptionTextField.text ?? ""
        
        if CommonValidator.validateName(name: name) {
            if let uid = userId {
                teamRepository?.storeTeam(name: name!, description: description, userId: uid) { data, error in
                    if (error == nil) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        teamRepository = TeamsRepository()
    }
    
    
}
