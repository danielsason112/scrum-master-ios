import UIKit
import Firebase
import Kingfisher

class TeamCardTableViewCell: UITableViewCell {
    typealias JoinButtonAction = (_ sender: TeamCardTableViewCell) -> Void
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var membersCountLabel: UILabel!
    @IBOutlet var profileImage1: UIImageView!
    @IBOutlet var profileImage2: UIImageView!
    @IBOutlet var profileImage3: UIImageView!
    
    var isJoinable = false
    var team: Team?
    var profileImages: [UIImageView]?
    var profilesRepository: ProfilesRepository?
        
    func configure(team: Team?, isJoinable: Bool) {
        self.team = team
        self.isJoinable = isJoinable
        
        resetImageViews()
        updateView()
    }
    
    func updateView() {
        nameLabel.text = team?.name
        descriptionLabel.text = team?.description
        if let count = team?.members.count {
            membersCountLabel.text = "\(count)"
        }
        
        updateProfileImages()
    }
    
    func updateProfileImages() {
        var index = 0
        if let members = team?.members {
            for k in members.keys.prefix(3) {
                profilesRepository?.getProfileByUid(uid: k) { data, error in
                    if let profile = Profile(snapshot: data as! DataSnapshot),
                    let url = URL(string: profile.photoURL) {
                        self.profileImages?[index].kf.setImage(with: url)
                        index += 1
                    }
                }
            }
        }
    }
    
    func resetImageViews() {
        profileImages?.forEach({profileImage in
            profileImage.image = nil
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImages = [profileImage1, profileImage2, profileImage3]
        profilesRepository = ProfilesRepository()
    }
}
