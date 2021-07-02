import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    var logKey: String?
    var logValue: String?
    
    func configure(logKey: String, logValue: String?) {
        self.logKey = logKey
        self.logValue = logValue
        
        updateView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateView() {
        if let key = self.logKey,
           let value = self.logValue {
            keyLabel.text = DateConverter.toDisplayFullDate(dbDate: key)
            valueLabel.text = value
        }
    }
}
