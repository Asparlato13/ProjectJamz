//
//  LibraryToggleView.swift
//
//
//  Created by Adrianna Parlato on 9/16/22.
//

import UIKit


//defines a custom view called LibraryToggleView which contains two buttons and an indicator view to toggle between two states (i.e. playlist and album). It also defines a protocol LibraryToggleViewDelegate which defines two methods that should be implemented by any delegate of LibraryToggleView.

//connect switching pages bsed on which button (album or playlist) they click
//defines a protocol LibraryToggleViewDelegate with two methods. LibraryToggleViewDidTapPlaylist and LibraryToggleViewDidTapAlbum, that should be implemented by any delegate of the LibraryToggleView. This protocol makes sure that the delegate can receive notifications when the user taps on the playlist or album buttons.

protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbum(_ toggleView: LibraryToggleView)
}


//defines a class LibraryToggleView which contains two buttons and an indicator view. It also has a state property of type State that represents the current state of the view (i.e. playlist or album). It also has a weak reference to a delegate object of type LibraryToggleViewDelegate.
class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    
    //set up playlist button for library  page
    //creates a UIButton called playlistButton with a title "Playlists" and adds it as a subview to LibraryToggleView
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    
    //set up album button for library  page
    //creates a UIButton called albumButton with a title "Albums" and adds it as a subview to LibraryToggleView.
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    
    //set up signal for user to know which page they are on (album or playlist)
    //creates a UIView called indicatorView with a green background color and a rounded corner. This view is used to indicate the current state of the view.
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    //dds playlistButton, albumButton, and indicatorView as subviews to the LibraryToggleView. It also sets up actions for both buttons so that when the user taps on either of the buttons, the corresponding method is called.
    override init(frame: CGRect) {
        super.init(frame: frame)
        // backgroundColor = .blue
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    
    required init(coder: NSCoder) {
        fatalError()
        
    }
    
    @objc private func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.LibraryToggleViewDidTapPlaylist(self)
    }
    
    
    @objc private func didTapAlbums() {
        state = .album
        //animate green line
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.LibraryToggleViewDidTapAlbum(self)
    }
    
    //The layoutSubviews() method is called whenever the layout of the LibraryToggleView instance changes, such as when the view is first added to its superview or when the device is rotated. This method sets the frame of the playlist and album buttons and calls the layoutIndicator() method to position the green indicator line.
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
        
        //set up layouttoggle  green line under playlist and ablum  between the pages based on which 'state'(aka page) the user clicks
        
        
    }
    
    //The layoutIndicator() method positions the green indicator line based on the current state of the LibraryToggleView instance. If the state is .playlist, the green line is positioned beneath the "Playlists" button. If the state is .album, the green line is positioned beneath the "Albums" button.
    func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: playlistButton.bottom, width: 100, height: 3)
        }
    }
    

//  the update(for state: State) method is called to update the state property and update the position of the green indicator line when the LibraryToggleView instance is programmatically updated. This method is called with the desired state as a parameter and it updates the state property, then calls the layoutIndicator() method to update the position of the green indicator line. The green indicator line is also animated using a 0.2-second animation.
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
    }
    
}
