import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    let registerSegueIdentifier = "registerSegue"
    let loginSegueIdentifier = "loginSegueIdentifier"
    let emailErrorMessage = "Please enter a valid email address."
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == registerSegueIdentifier {
            if let dest = segue.destination as? RegisterViewController {
                dest.configure(email: emailTextField.text!)
            }
        }
        if segue.identifier == loginSegueIdentifier {
            if let dest = segue.destination as? LoginViewController {
                dest.configure(email: emailTextField.text!)
            }
        }
    }

    @IBAction func nextButtonTriggered(_ sender: Any) {
        nextButton.isEnabled = false
        if let email = emailTextField.validEmail() {
            Auth.auth().fetchSignInMethods(forEmail: email, completion: {authRes, error in
                if authRes == nil {
                    self.performSegue(withIdentifier: self.registerSegueIdentifier, sender: self)
                } else {
                    self.performSegue(withIdentifier: self.loginSegueIdentifier, sender: self)
                }
                self.nextButton.isEnabled = true
            })
        } else {
            nextButton.isEnabled = true
            errorMessageLabel.text = emailErrorMessage
            errorMessageLabel.isHidden = false
        }
        
    }
    @IBAction func editingChanged(_ sender: Any) {
        errorMessageLabel.isHidden = true
    }
}
