import Foundation
import Firebase

struct Profile {
  
  let ref: DatabaseReference?
  let key: String
    let email: String
  let displayName: String
  let photoURL: String
  
    init(email: String, displayName: String, photoURL: String, key: String = "") {
    self.ref = nil
    self.key = key
    self.email = email
    self.displayName = displayName
        self.photoURL = photoURL
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let email = value["email"] as? String,
      let displayName = value["displayName"] as? String,
      let photoURL = value["photoURL"] as? String else {
      return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.email = email
    self.displayName = displayName
    self.photoURL = photoURL
  }
  
  func toAnyObject() -> Any {
    return [
      "email": email as String,
      "displayName": displayName as String,
        "photoURL": photoURL as String
    ]
  }
}
