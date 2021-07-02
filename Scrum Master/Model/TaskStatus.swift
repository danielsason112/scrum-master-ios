import UIKit

enum TaskStatus: Int, CaseIterable, Codable {
    case backlog
    case toDo
    case inProgress
    case review
    case done
    
    func displayName() -> String {
        switch self {
        case .backlog:
            return "Backlog"
        case .toDo:
            return "To Do"
        case .inProgress:
            return "In Progress"
        case .review:
            return "Review"
        case .done:
            return "Done"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .backlog:
            return UIColor.red
        case .toDo:
            return UIColor.orange
        case .inProgress:
            return UIColor.yellow
        case .review:
            return UIColor.blue
        case .done:
            return UIColor.green
        }
    }
}
