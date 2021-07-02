import Foundation
import Firebase

struct Task {
    var ref: DatabaseReference?
    let key: String?
    let name: String
    let createdAt: String
    let description: String
    let taskStatus: TaskStatus
    let comments: [String: String]
    let dueDate: String
    
    init(key: String = "", name: String, createdAt: String, description: String, taskStatus: TaskStatus, comments: [String: String], dueDate: String) {
        self.key = key
        self.name = name
        self.createdAt = createdAt
        self.description = description
        self.taskStatus = taskStatus
        self.comments = comments
        self.dueDate = dueDate
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String:AnyObject],
              let name = value["name"] as? String,
              let createdAt = value["createdAt"] as? String,
              let description = value["description"] as? String,
              let taskStatusRaw = value["taskStatus"] as? Int,
              let taskStatus = TaskStatus(rawValue: taskStatusRaw),
              let dueDate = value["dueDate"] as? String
        
        else { return nil }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.createdAt = createdAt
        self.description = description
        self.taskStatus = taskStatus
        self.comments = [:]
        self.dueDate = dueDate
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name as String,
            "createdAt": createdAt as String,
            "description": description as String,
            "taskStatus": taskStatus.rawValue as Int,
            "comments": comments as Dictionary,
            "dueDate": dueDate as String
        ]
    }
}
