//
//  PlayerControlsView.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//
import Foundation
import UIKit


//provides a UI for controlling a media player.

//The view has a delegate playerControlsViewDelegate with four methods, which will be called when the user interacts with the view:

//        playerControlsViewDidTapPlayPauseButton: called when the play/pause button is tapped.
//        playerControlsViewDidTapNextButton: called when the next button is tapped.
//        playerControlsViewDidTapBackButton: called when the back button is tapped.
//        playerControlsView(_:didSlideSlider:): called when the user slides the volume slider.
protocol playerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView )
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView )
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView )
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}


struct PlayerControlsViewModel {
    let title: String?
    let subtitle: String?
}


//The view has several subviews:

//        nameLabel: a label showing the title of the media.
//        subtitleLabel: a label showing the subtitle of the media.
//        volumeSlider: a slider that controls the volume.
//        backButton: a button for skipping back to the previous track.
//        nextButton: a button for skipping to the next track.
//        playPauseButton: a button for playing or pausing the media.
final class PlayerControlsView: UIView {
    
    private var isPlaying = true
    
    
    weak var delegate: playerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "SOTD"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "smino"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc func didSlideSlider( _ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    
    @objc private func didTapBack () {
        delegate?.playerControlsViewDidTapBackButton(self)
    }
    
    @objc private func didTapNext () {
        delegate?.playerControlsViewDidTapNextButton(self)
        
    }
    
    @objc private func didTapPlayPause () {
        //update button to pause
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        //update icon based on button paused or play
        let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play , for: .normal)
        
    }
    //the layoutSubviews method is used to position and size the subviews, and the configure method is used to set the title and subtitle of the media.
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY+10, width: frame.width, height: 50)

        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.frame.maxY+20, width: frame.width-20, height: 44)

        let buttonSize: CGFloat = 60

        playPauseButton.frame = CGRect(x: (frame.width-buttonSize)/2, y: volumeSlider.frame.maxY+30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.frame.minX-80-buttonSize, y: playPauseButton.frame.maxX, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.frame.minY+80, y: playPauseButton.frame.maxX, width: buttonSize, height: buttonSize)
    }

    
    //a PlayerControlsViewModel object which is used to configure the view with the media's title and subtitle
    func configure(with viewModel: PlayerControlsViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    
}

