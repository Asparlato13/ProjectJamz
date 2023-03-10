//
//  SearchResultDefaultTableViewCell.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SDWebImage

// creates a cell with a single line of text and an optional icon image. The text label is positioned to the right of the icon image, and the cell has a disclosure indicator accessory type.

// defines a custom table view cell subclass called SearchResultDefaultTableViewCell, which is used to display search results in a table view.

//The cell has a static identifier property, which can be used to dequeue cells of this type from a table view.


class SearchResultDefaultTableViewCell: UITableViewCell {

    static let identifier = "SearchResultDefaultTableViewCell"
    
    //The cell contains two subviews: a label and an image view. The label displays the search result's title, and the image view displays an icon or image associated with the search result.
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
        
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    
    required override init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    //The layoutSubviews() method lays out the subviews within the cell's content view. The image view is positioned in the top-left corner of the cell and is given a circular shape by setting its layer's cornerRadius property to half its height. The label is positioned to the right of the image view and takes up the remaining width of the cell's content view.
    override func layoutSubviews() {
        super.layoutSubviews()
        label.clipsToBounds.self
        imageView?.clipsToBounds.self
        let imageSize : CGFloat = contentView.frame.height-10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        label.frame = CGRect(x: iconImageView.frame.maxX+10, y: 0, width: contentView.frame.width-iconImageView.frame.maxX-15, height: contentView.frame.height)
    }
    
    
  
    //The prepareForReuse() method is called when a cell is about to be reused, and it resets the cell's state by setting the image view's image and the label's text to nil.
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    
    
    //the configure(with:) method is called to populate the cell's subviews with data from a view model. The view model contains a title and an image URL, which are used to set the text of the label and to download and set the image of the image view using the sd_setImage method provided by the SDWebImage library.
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
    
}

