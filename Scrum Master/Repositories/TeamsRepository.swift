import Foundation
import Firebase

class TeamsRepository: NSObject {
    typealias ResponseObserver = (_ data: Any?, _ error: Error?) -> Void
    
    private let TEAMS_DB_BASE_REF = "teams"
    private let db: Database
    private let baseRef: DatabaseReference
    
    override init() {
        db = Database.database()
        baseRef = db.reference(withPath: TEAMS_DB_BASE_REF)
    }
    
    func storeTeam(name: String, description: String, userId: String, responseObserver: @escaping ResponseObserver) {
        baseRef.child(name).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                responseObserver(nil, TeamRepositoryError.TeamNameExists)
            } else {
                let members = [userId: true]
                let team = Team(name: name, description: description, createdBy: userId, members: members)
                self.baseRef.child(name).setValue(team.toAnyObject()) { (error: Error?, ref: DatabaseReference) in
                    responseObserver(ref, error)
                }
                
            }
        })
    }
    
    func findAll(responseObserver: @escaping ResponseObserver) {
        baseRef.observeSingleEvent(of: .value, with: { snapshot in
            responseObserver(snapshot, nil)
        })
    }
    
    func findTeamByKey(key: String, responseObserver: @escaping ResponseObserver) {
        baseRef.child(key).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                responseObserver(nil, TeamRepositoryError.NoSuchTeam)
            } else {
                responseObserver(snapshot, nil)
            }
        })
    }
    
    func joinTeam(userId: String, key: String, responseObserver: @escaping ResponseObserver) {
        baseRef.child(key).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                self.baseRef.child(key).child("members").child(userId).setValue(true) { (error:Error?, ref:DatabaseReference) in
                    responseObserver(ref, error)
                }
            }
        })
    }
    
    func addBoard(teamKey: String, user: User, boardName: String, responseObserver: @escaping ResponseObserver) {
        let now = DateConverter.toDbDate(date: Date())
        let logs = [now: "\(user.displayName ?? "User") created this board."]
        let board = Board(name: boardName, createdAt: now, logs: logs)
        baseRef.child(teamKey).child("boards").childByAutoId().setValue(board.toAnyObject()) { (error:Error?, ref:DatabaseReference) in
            responseObserver(ref, error)
        }
    }
    
    func addTask(task: Task, board: Board, user: User, responseObserver: @escaping ResponseObserver) {
        board.ref?.child("tasks").childByAutoId().setValue(task.toAnyObject()) { (error:Error?, ref:DatabaseReference) in
            if error == nil {
                board.ref?.child("logs").child(DateConverter.toDbDate(date: Date())).setValue("\(user.displayName ?? "user") created a new task: \(task.name)") { (error:Error?, ref:DatabaseReference) in
                        responseObserver(ref, error)
                }
            }
        }
    }
    
    func findBoardByRef(boardRef: DatabaseReference, responseObserver: @escaping ResponseObserver) {
        boardRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                responseObserver(nil, TeamRepositoryError.NoSuchBoard)
            } else {
                responseObserver(snapshot, nil)
            }
        })
    }
    
    func updateTaskByRef(taskRef: DatabaseReference, task: Task, responseObserver: @escaping ResponseObserver) {
            taskRef.setValue(task.toAnyObject()) { (error:Error?, ref:DatabaseReference) in
                responseObserver(ref, error)
            }
    }
    
    func removeTaskByRef(taskRef: DatabaseReference, responseObserver: @escaping ResponseObserver) {
        taskRef.removeValue() { (error:Error?, ref:DatabaseReference) in
            responseObserver(ref, error)
        }
    }
}

enum TeamRepositoryError: Error {
    case TeamNameExists
    case NoSuchTeam
    case NoSuchBoard
}
