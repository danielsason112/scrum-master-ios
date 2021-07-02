import UIKit

class BoardTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    
    var board: Board?
    
    func configure(board: Board) {
        self.board = board
        nameLabel.text = board.name
        createdAtLabel.text = DateConverter.toDisplayDate(dbDate: board.createdAt)
    }
}
