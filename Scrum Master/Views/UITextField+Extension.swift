import UIKit

extension UITextField {
    func validName() -> String? {
        return text?.count ?? 0 >= 2 ? text : nil
    }
    
    func validEmail() -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text) ? text : nil
    }
    
    func validPassword() -> String? {
        return text?.count ?? 0 >= 6 ? text : nil
    }
}
