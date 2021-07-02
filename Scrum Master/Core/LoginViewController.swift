import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    var email: String?
    
    func configure(email: String) {
        self.email = email
    }
    
    @IBAction func signInButtonTriggered(_ sender: Any) {
        if let userEmail = email,
           let password = passwordTextField.validPassword() {
            signInButton.isEnabled = false
            Auth.auth().signIn(withEmail: userEmail, password: password) { res, error in
                if res != nil {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            signInButton.isEnabled = true
        }
        
    }
}
