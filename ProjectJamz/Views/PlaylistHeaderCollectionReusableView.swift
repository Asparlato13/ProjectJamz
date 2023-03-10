//
//  PlaylistHeaderCollectionReusableView.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SDWebImage

// a reusable view that can be used as a header in a collection view cell and responds to user interaction through a delegate.---adjust the album/playlist/user info to fit screen

//The PlaylistHeaderCollectionReusableView is a subclass of UICollectionReusableView that defines various UI elements for the header view, such as nameLabel, descriptionLabel, ownerLabel, imageView, and playAllButton. The playAllButton is a UIButton that when tapped, calls the didTapPlayAll method that in turn calls the PlaylistHeaderCollectionReusableViewDidTapPlayAll method on its delegate.
protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}


final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc private func didTapPlayAll(){
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    
    //The layoutSubviews method is called when the view's bounds change and sets the frames for all the UI elements based on the current frame size.
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = frame.height/1.8
        imageView.frame = CGRect(x: (frame.width-imageSize)/2, y: 29, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.frame.maxY, width: frame.width-20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.frame.maxY, width: frame.width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.frame.maxY, width: frame.width-20, height: 44)
        
        
        playAllButton.frame = CGRect(x: frame.width-80, y: frame.height-80, width: 60, height: 60)
        
    }
    
    //The configure method is used to configure the UI elements of the header view with the data from a PlaylistHeaderViewViewModel.
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
        
        
    }
}
