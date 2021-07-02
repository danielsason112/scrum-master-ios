import Foundation

class CommonValidator: NSObject {
    
    static func validateName(name: String?) -> Bool {
        return name?.count ?? 0 >= 2    }
    
    static func validateEmail(email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email != nil && emailPred.evaluate(with: email)
    }
}
