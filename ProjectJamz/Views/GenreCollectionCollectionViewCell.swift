//
//  GenreCollectionCollectionViewCell.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SDWebImage


// defines a custom collection view cell that can be used to display categories of music in a collection view.
// defines a custom UICollectionViewCell called CategoryCollectionViewCell. This cell has a label and an image view, and it is designed to display a category of music.

//The cell contains the following properties:
//            identifier: a static constant that defines the identifier used to dequeue the cell from a                collection view.
//            imageView: a private instance of UIImageView that displays the artwork associated with the               category.
//            label: a private instance of UILabel that displays the title of the category.
//            colors: an array of UIColor instances used to randomly set the background color of the cell.


class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    
    private let colors: [UIColor] = [
        .systemBlue,
        .systemPink,
        .systemPurple,
        .systemGreen,
        .systemOrange,
        .systemYellow,
        .systemRed,
        .systemTeal,
        
    ]
    
    
    //The CategoryCollectionViewCell overrides the following methods:

    
    //   init(frame:): Initializes the cell's view hierarchy, sets the content view's corner radius, and adds the label and image view as subviews of the cell's content view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //    prepareForReuse(): Resets the label's text and the image view's image to their default values when the cell is reused.

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    //    layoutSubviews(): Lays out the subviews of the cell, setting the label and image view's frames within the cell's content view.
    override func layoutSubviews() {
        super.layoutSubviews()

       
   
        label.bounds.size
      //  view.bounds.size
        label.frame = CGRect(x: 10, y: contentView.frame.height/2, width: contentView.frame.width-20, height: contentView.frame.height/2)
        imageView.frame = CGRect(x: contentView.frame.width/2, y: 10, width: contentView.frame.width/2, height: contentView.frame.height/2)
    }
    
    
// defines a configure method that takes a CategoryCollectionViewCellViewModel as its argument. This method sets the label's text to the title of the category, sets the image view's image to the artwork associated with the category, and sets the cell's background color to a random element from the colors array.
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
    
    
}

