//
//  SearchResultSubtitleTableViewCell.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SDWebImage

// creates a cell with two lines of text and an optional icon image. The first line of text is a title and the second line is a subtitle, both labels are positioned below the icon image. The cell also has a disclosure indicator accessory type


//defines a custom UITableViewCell subclass called SearchResultSubtitleTableViewCell. This cell has three subviews: an icon image view, a title label, and a subtitle label
class SearchResultSubtitleTableViewCell: UITableViewCell {
  
    //The cell has a static identifier property that can be used to dequeue instances of this cell from a table view.
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
        
    }()
    
    private let subtitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
        
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    //In the init(style:reuseIdentifier:) method, the cell's subviews are added to its content view, and the accessoryType property is set to .disclosureIndicator.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(subtitlelabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    
    required override init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //The layoutSubviews() method is overridden to lay out the cell's subviews. The icon image view is positioned at the left edge of the cell, and its frame is set to a square with a size equal to the cell's height. The label and subtitle label are positioned to the right of the icon image view, with the label positioned at the top of the cell and the subtitle label positioned below it.
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = contentView.frame.height
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        let labelHeight = contentView.frame.height/2
        label.frame = CGRect(x: iconImageView.frame.maxX, y: 0, width: contentView.frame.width-iconImageView.frame.maxX, height: labelHeight)
        subtitlelabel.frame = CGRect(x: iconImageView.frame.maxX+10, y: labelHeight, width: contentView.frame.width-iconImageView.frame.maxX-15, height: labelHeight)
    }
    
    //The prepareForReuse() method is also implemented to reset the cell's properties when it is dequeued for reuse.
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitlelabel.text = nil
    }
    
    
    //, the cell has a configure(with:) method that takes a SearchResultSubtitleTableViewCellViewModel object and sets the cell's properties based on the data in the view model. The title label is set to the view model's title property, the subtitle label is set to the view model's subtitle property, and the icon image view is set to the image at the URL in the view model's imageURL property using the sd_setImage method from the SDWebImage library. If the image loading fails, a system placeholder image is used instead.
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitlelabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
    
}

