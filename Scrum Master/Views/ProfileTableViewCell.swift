import UIKit
import Kingfisher

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    func configure(profile: Profile) {
        if let url = URL(string: profile.photoURL) {
            profilePhotoImageView.kf.setImage(with: url)
        }
        displayNameLabel.text = profile.displayName
        emailLabel.text = profile.email
    }
}
