import Foundation
import Firebase

struct Board {
  
  let ref: DatabaseReference?
  let key: String
    let name: String
  let createdAt: String
    let logs: [String: String]
    var tasks: [String: Task]?
  
    init(key: String = "", name: String, createdAt: String, logs: [String: String]) {
    self.ref = nil
    self.key = key
    self.name = name
    self.createdAt = createdAt
        self.logs = logs
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let createdAt = value["createdAt"] as? String,
      let logs = value["logs"] as? [String: String] else {
      return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.createdAt = createdAt
    self.logs = logs
    
    let tasksDS = snapshot.childSnapshot(forPath: "tasks")
    var tasks: [String: Task] = [:]
    if tasksDS.exists() {
        for child in tasksDS.children {
            if let childDS = child as? DataSnapshot,
               let task = Task(snapshot: childDS),
               let key = task.key {
                tasks[key] = task
            }
        }
        self.tasks = tasks
    }
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name as String,
      "createdAt": createdAt as String,
        "logs": logs as [String: String],
        "tasks": (tasks ?? [:]) as [String: Any]
    ]
  }
}
