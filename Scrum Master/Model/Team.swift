import Foundation
import Firebase

struct Team {
  
    let ref: DatabaseReference?
    let key: String
    let name: String
    let description: String
    let createdBy: String
    let members: Dictionary<String, Bool>
    var boards: [String: Board]?
  
    init(name: String, description: String, createdBy: String, key: String = "", members: Dictionary<String, Bool>, boards: [String: Board]? = nil) {
        self.ref = nil
        self.key = key
        self.name = name
        self.description = description
        self.createdBy = createdBy
        self.members = members
        self.boards = boards
  }
  
  init?(snapshot: DataSnapshot) {
    guard let value = snapshot.value as? [String: AnyObject],
          let name = value["name"] as? String,
          let createdBy = value["createdBy"] as? String,
          let description = value["description"] as? String,
          let members = value["members"] as? Dictionary<String, Bool> else {
      return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.description = description
    self.createdBy = createdBy
    self.members = members
    
    let boardsDS = snapshot.childSnapshot(forPath: "boards")
    if boardsDS.exists() {
        var boards: [String: Board] = [:]
        for child in boardsDS.children {
            if let ds = child as? DataSnapshot,
               let board = Board(snapshot: ds) {
                boards[board.key] = board
            }
        }
        self.boards = boards
    }
  }
  
  func toAnyObject() -> Any {
    return [
        "name": name as String,
        "createdBy": createdBy as String,
        "description": description as String,
        "members": members as Dictionary,
        "boards": boards ?? [:] as Dictionary
    ]
  }
}

extension Team {
    static let testData = [
        Team(name: "Scrum Master", description: "Tasks management app.", createdBy: "TfXGKyZEteZDk7a8dq6v0d1ficj1", key: "Scrum Master", members: [
            "TfXGKyZEteZDk7a8dq6v0d1ficj1": true,
            "sadas67tf89gdg67": true
        ]),
        Team(name: "Pied Piper", description: "Files compression algorithm.", createdBy: "IXg84XRPbEXM8z5H8MiT8xGf4tn1", key: "Scrum Master", members: [
            "IXg84XRPbEXM8z5H8MiT8xGf4tn1": true,
            "sadas67tf89gdg67": true
        ])
    ]
}
