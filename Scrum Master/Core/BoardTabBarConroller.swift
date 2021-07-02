import UIKit

class BoardTabBarViewController: UITabBarController {
    var board: Board?
    
    func configure(board: Board) {
        self.board = board
    }
    
    
}
