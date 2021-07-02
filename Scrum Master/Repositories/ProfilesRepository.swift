import Foundation
import Firebase

class ProfilesRepository: NSObject {
    typealias ResponseObserver = (_ data: Any?, _ error: Error?) -> Void
    
    var db: Database
    var baseRef: DatabaseReference
    
    override init() {
        db = Database.database()
        baseRef = db.reference(withPath: "profiles")
    }
    
    func storeProfile(profile: Profile) {
        if !profile.key.isEmpty {
            baseRef.child(profile.key).setValue(profile.toAnyObject())
        }
    }
    
    func getProfileByUid(uid: String, responseObserver: @escaping ResponseObserver) {
        baseRef.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                responseObserver(nil, ProfilesRepositoryError.NoSuchProfile)
            } else {
                responseObserver(snapshot, nil)
            }
        })
    }
    
    func findProfilesByUid(uids: [String], responseObserver: @escaping ResponseObserver) {
        var profiles: [String: Profile] = [:]
        var count = 0
        for uid in uids {
            getProfileByUid(uid: uid, responseObserver: { data, error in
                if error == nil,
                   let snapshot = data as? DataSnapshot,
                   let profile = Profile(snapshot: snapshot) {
                    profiles[profile.key] = profile
                }
                if count == uids.count - 1 {
                    responseObserver(profiles, error)
                } else {
                    count += 1
                }
            })
        }
    }
}

enum ProfilesRepositoryError: Error {
    case NoSuchProfile
}
