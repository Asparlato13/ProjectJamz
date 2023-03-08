//
//  PlayerViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SDWebImage

//a view controller that shows a player interface for playing audio.





protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapNext()
    func didTapBack()
    func didSlideSlider(_ value: Float)
}


// a delegate protocol called PlayerViewControllerDelegate with several methods that can be used to control playback,


class PlayerViewController: UIViewController {
    
    //and a property called dataSource which provides data for the view controller to display.
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?

    // displays the cover art of the audio being played,
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let controlsView = PlayerControlsView()
    
    //The viewDidLoad method adds the UIImageView and PlayerControlsView as subviews to the view controller's view,
    //and sets up the controlsView's delegate to the view controller.
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        
        configure()
        
    }
    // The viewDidLayoutSubviews method sets the frames for the UIImageView and PlayerControlsView, and brings both subviews to the front of the view hierarchy.
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.frame.width,
            height: view.frame.width)
        controlsView.frame = CGRect(
            x: 10, y: imageView.bottom+10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
        view.bringSubviewToFront(imageView)
        view.bringSubviewToFront(controlsView)
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.bringSubviewToFront(imageView)
//        view.bringSubviewToFront(controlsView)
//    }
    
    
    
    //takes datasoruce and confirgures ui components
    
    //The configure method sets the image for the UIImageView using the dataSource's imageURL property, and configures the PlayerControlsView using a PlayerControlsViewModel created from the dataSource's songName and subtitle properties.
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
       //adds song name and artist
        controlsView.configure(
            with: PlayerControlsViewModel(
            title: dataSource?.songName,
            subtitle: dataSource?.subtitle))
    }
    
    //buttons for closing presenting page in  top right corner
    //The configureBarButtons method sets up the left and right bar button items for the view controller's navigation bar.
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        //button for potiental options -- sharing, add to playlist  etc
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
                                                           
    @objc private func didTapAction() {
            //actions
        }
    func refreshUI() {
        configure()
    }
                                                               
}

//the PlayerViewController conforms to the PlayerControlsViewDelegate protocol, which allows it to receive events from the PlayerControlsView such as slider value changes, play/pause button taps, next/previous button taps.
//The view controller passes these events on to its delegate using the didTapPlayPause(), didTapNext(), didTapBack(), and didSlideSlider(_ value: Float) methods.


//PlayerControlsView that contains buttons for controlling playback, a progress slider, and labels for displaying the song name and artist.


extension PlayerViewController: playerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
        
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapNext()
    }
    
    func playerControlsViewDidTapBackButton(_ playeblrControlsView: PlayerControlsView) {
        delegate?.didTapBack()
    }
    
    
}
