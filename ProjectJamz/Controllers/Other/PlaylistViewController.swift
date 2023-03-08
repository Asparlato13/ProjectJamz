//
//  PlaylistViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit

//n implementation of a view controller class, PlaylistViewController, which displays a list of tracks belonging to a Spotify playlist. The playlist can be shared and tracks can be removed from it.


//A new class, PlaylistViewController, is defined as a subclass of UIViewController.
class PlaylistViewController: UIViewController {
    //A private instance variable playlist is defined, of type Playlist. The keyword private restricts the access level of the variable so that it can only be accessed from within this class.
    private let playlist: Playlist
        
    //A public variable isOwner is defined, of type Bool, with a default value of false. This variable is used to determine whether the user is the owner of the playlist or not, which affects whether or not they can delete tracks from the playlist.
    public var isOwner = false
    
    
    
    //A private instance variable collectionView is defined, of type UICollectionView, with an initial value of a new instance of UICollectionView. The UICollectionView is initialized with a frame of zero and a UICollectionViewCompositionalLayout instance that is defined using a closure. The closure takes two parameters, _ and _, which are unused, and returns an NSCollectionLayoutSection. This closure defines the layout of the UICollectionView.
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        
            
            //item : A new instance of NSCollectionLayoutItem is created, with a size defined as 100% of the width and height of the section
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
                                              )
            )
            //The contentInsets property of the NSCollectionLayoutItem instance is set to NSDirectionalEdgeInsets with top, leading, bottom, and trailing values of 1, 2, 1, and 2, respectively. This creates a 1 point padding around each item in the collection view.
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
            //A new instance of NSCollectionLayoutGroup is created, with a vertical layout and a size defined as 100% of the width and a fixed height of 60 points. The group contains a single item, defined by the NSCollectionLayoutItem instance item
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1)
        
        //section: A new instance of NSCollectionLayoutSection is created, with the group defined by the NSCollectionLayoutGroup instance group.
            let section = NSCollectionLayoutSection(group: group)
            //boundarySupplementaryItems are set with a header of size that fits the entire width of the collection view.
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)]
            
            return section
    }))
    
    
    // initializes a view controller that is intended to show a playlist of audio tracks. It receives a Playlist object as an argument and sets it as an instance variable. In init, the superclass' init method is called with nibName and bundle set to nil. required init?(coder: NSCoder) is implemented but causes a fatal error.
        init(playlist: Playlist) {
            self.playlist = playlist
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
    
    //Two instance variables, viewModels and tracks, are declared as arrays of RecommendedTrackCellViewModel and AudioTrack, respectively. The viewDidLoad method of the view controller is then called.
    private var viewModels = [RecommendedTrackCellViewModel]()
    private var tracks = [AudioTrack]()
        
    
    //In viewDidLoad, the view controller sets its title to the playlist name and its background color to the system background color. The collection view is added to the view hierarchy of the view controller's view. The collection view is then registered with the RecommendedTrackCollectionViewCell and PlaylistHeaderCollectionReusableView classes. The background color of the collection view is also set to the system background color, and the collection view is set as the delegate and data source of the view controller.
        override func viewDidLoad() {
            super.viewDidLoad()
            title = playlist.name
            view.backgroundColor = .systemBackground
            
            view.addSubview(collectionView)
            collectionView.register(RecommendedTrackCollectionViewCell.self,
                                    forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
            collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
            collectionView.backgroundColor = .systemBackground
            collectionView.delegate = self
            collectionView.dataSource = self
//An API call is made to retrieve the details of the playlist specified by the playlist instance variable. On success, the tracks and viewModels instance variables are populated using data from the API response, and the collection view is reloaded with the new data. On failure, the error is printed to the console.
            APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
        DispatchQueue.main.async {
                switch result {
                    case .success(let model):
                        
                      // RecommendedTrackCellViewModel
                    self?.tracks = model.tracks.items.compactMap({ $0.track })
                        self?.viewModels = model.tracks.items.compactMap({
                            RecommendedTrackCellViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                            )
                        })
                        self?.collectionView.reloadData()
                    case .failure(let error):
                    //    break
                    print(error.localizedDescription)
                }
            }
        }
            //A UIBarButtonItem is added to the view controller's navigation item, and a UILongPressGestureRecognizer is created and added to the collection view, allowing users to delete tracks from the playlist by long-pressing on a track.
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(didTapShare))
            
//            func deleteLongTapGesture() {
                //when user holds down track in playlist athye can delete it
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
            collectionView.addGestureRecognizer(gesture)
            
    }
    //didLongPress is a method that handles a long press gesture on a track in the collection view. When the gesture begins, it retrieves the index path of the track that was pressed, creates an action sheet that prompts the user to delete the track, and calls an API function to remove the track from the playlist. If the removal is successful, the track is removed from the view and the collection view is reloaded.
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: trackToDelete.name, message: "Would you like to delete this from the playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
    
            APICaller.shared.removeTrackFromPlaylists(track: trackToDelete, playlist: strongSelf.playlist) { success in
                DispatchQueue.main.async {
                    if success {
                        print("removed")
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    }
                    else {
                        print("failed to remove")
                    }
                }
               
            }
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    //didTapShare is a method that handles a tap on the share icon. It creates a UIActivityViewController that allows the user to share the playlist with others.
  
    //options for when user clicks ion share icon -- they  can  message it to friend  etc
    @objc private func didTapShare() {
        //print(playlist.external_urls)
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: ["My SOTD", url],
            applicationActivities: [])
    
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    // viewDidLayoutSubviews is a method that resizes the collection view to fit the bounds of the parent view.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}


  //numberOfSections, numberOfItemsInSection, and cellForItemAt are all methods that provide data to the collection view to display the tracks in the playlist.
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
       // return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt IndexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: IndexPath)
        as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
       // cell.backgroundColor = .red
        cell.confgure(with: viewModels[IndexPath.row])
        return cell
    }
    
    //viewForSupplementaryElementOfKind is a method that provides data to the collection view to display the header of the playlist.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath)
            as? PlaylistHeaderCollectionReusableView,
           kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewViewModel(
            name: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artworkURL: URL(string: playlist.images.first?.url ?? ""))
        
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }

    
    
    //tap on item and play song
//didSelectItemAt is a method that handles a tap on a track in the collection view. It retrieves the selected track and calls a function to start playback of the track.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //play song
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        
        
    }
    
}
//PlaylistHeaderCollectionReusableViewDidTapPlayAll is a method that handles a tap on the "Play All" button in the header of the playlist. It calls a function to start playback of all tracks in the playlist.
extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
        
}



   
