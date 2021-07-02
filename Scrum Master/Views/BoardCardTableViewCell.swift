import UIKit

class BoardCardTableViewCell: UITableViewCell {
    let boardCellIdentifier = "boardCellIdentifier"
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var board: Board?
    
    func configure(board: Board) {
        self.board = board
        nameLabel.text = board.name
        createdAtLabel.text = DateConverter.toDisplayDate(dbDate: board.createdAt) ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
