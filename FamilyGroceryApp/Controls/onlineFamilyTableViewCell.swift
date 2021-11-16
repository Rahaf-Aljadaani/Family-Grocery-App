
import UIKit

class onlineFamilyTableViewCell: UITableViewCell {
    
    private let UserEmailLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let imageIcon: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "20")
        image.layer.cornerRadius = image.frame.width/2
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(UserEmailLabel)
        contentView.addSubview(imageIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
    
        super.layoutSubviews()
        imageIcon.frame = CGRect(x: 30,
                                     y:10
                                     , width: 30 ,
                                     height: 30)
        UserEmailLabel.frame = CGRect(x: 70,
                                     y:5
                                     , width: contentView.frame.width ,
                                     height: contentView.frame.height-20/2)
    }


    
    public func configure(with Email: String){      
        self.UserEmailLabel.text = Email

}
}

