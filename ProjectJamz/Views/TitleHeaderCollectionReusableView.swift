//
//  TitleHeaderCollectionReusableView.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 2/13/23.
//

import UIKit


// this reusable view has a single label that is added as a subview to the view, and its text can be set through the configure(with:) method. It is used to display a title header in a UICollectionView.

//class TitleHeaderCollectionReusableView: UICollectionReusableView - This line declares a class TitleHeaderCollectionReusableView that extends UICollectionReusableView, which is a base class for reusable views in UICollectionView.
class TitleHeaderCollectionReusableView: UICollectionReusableView {
//static let identifier = "TitleHeaderCollectionReusableView" - This line declares a static variable identifier of type String which holds the identifier of the reusable view. This identifier is used to register and dequeue the reusable view from the UICollectionView.

    static let identifier = "TitleHeaderCollectionReusableView"
    
    
    //private let label: UILabel = { ... }() - This line declares a private constant label of type UILabel and initializes it with a closure that creates a new UILabel object and sets some of its properties.
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
        //override init(frame: CGRect) - This line overrides the init(frame:) method of UICollectionReusableView to set the background color of the view to .systemBackground and add the label as a subview to the view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    //required init?(coder: NSCoder) - This line overrides the init?(coder:) method of UICollectionReusableView. It is marked with the required keyword to ensure that this method is implemented by any subclass. This method is required when the reusable view is created from a storyboard or a nib file, but in this case, it just calls fatalError() to crash the app, as the reusable view should always be created programmatically.
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //override func layoutSubviews() - This line overrides the layoutSubviews() method of UICollectionReusableView to set the frame of the label to fill the entire width of the view with a margin of 15 points on the left and right sides.
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width-30, height: height)
    }
    //func configure(with title: String) - This line declares a method called configure(with:) which takes a title parameter of type String. This method is used to configure the label with the given title.

    func configure(with title: String){
        label.text = title
        
    }
    
}

