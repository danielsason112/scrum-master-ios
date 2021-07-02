import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    let noPhotoUrl = "https://img.icons8.com/carbon-copy/100/000000/no-image.png"
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var avatarUrlTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    var email: String?
    
    func configure(email: String) {
        self.email = email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signUpButtonTriggered(_ sender: Any) {
        signUpButton.isEnabled = false
        if let userEmail = email,
           let userPassword = passwordTextField.validPassword() {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: {res, error in
                if let authRes = res {
                    let displayName = "\(self.firstnameTextField.validName() ?? "Almuni") \(self.lastnameTextField.validName() ?? "")"
                    let photoURL = URL(string: self.avatarUrlTextField.text ?? "")
                    
                    
                    self.updateProfile(uid: authRes.user.uid, displayName: displayName, photoURL: photoURL)
                }
            })
        }
    }
    
    private func storeProfile(profile: Profile) {
        ProfilesRepository().storeProfile(profile: profile)
    }
    
    private func updateProfile(uid: String, displayName: String, photoURL: URL?) {
        let profile = Profile(email: email!, displayName: displayName, photoURL: photoURL?.absoluteString ?? self.noPhotoUrl, key: uid)
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges(completion: {(error) in
            self.storeProfile(profile: profile)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
