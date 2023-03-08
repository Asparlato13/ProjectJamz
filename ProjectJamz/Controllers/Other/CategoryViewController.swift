//
//  CategoryViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit
import SwiftUI


//defines a CategoryViewController class that displays a collection view of playlists for a given music category. The class inherits from UIViewController and implements UICollectionViewDelegate and UICollectionViewDataSource protocols to manage the content of the collection view.


class CategoryViewController: UIViewController {
//The CategoryViewController has a single property category of type Category that represents the category for which playlists are to be displayed.
    let category: Category
    
    // It also has a private property collectionView of type UICollectionView that is initialized with a collection view layout using the UICollectionViewCompositionalLayout API.
    
    private let collectionView = UICollectionView(frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitem: item, count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return NSCollectionLayoutSection(group: group)
                                                                 }))
    
    
    //MARK: init
    
    // CategoryViewController class has two initializers: one that takes a Category object as a parameter and another required initializer that is not implemented.
    init(category: Category) {
        
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private var playlists = [Playlist]()
    
//MARK - When the CategoryViewController is loaded, its viewDidLoad() function sets up the UI elements, such as setting the view's background color, registering a FeaturedPlaylistCollectionViewCell with the collection view, and configuring the collection view's data source and delegate.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //The getCategoryPlaylist() function is called to fetch the playlists for the given category. When the playlists are fetched, the collection view is reloaded to display the playlists.
        APICaller.shared.getCategoryPlaylist(category: category) { [weak self] reusult in
           
            DispatchQueue.main.async {
                switch reusult {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
            
            }
            
        }
        
    }
    
    //The viewDidLayoutSubviews() function is called when the view's bounds are updated, and it updates the collection view's frame to match the view's bounds.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
   
}
//The CategoryViewController class also implements the UICollectionViewDelegate and UICollectionViewDataSource protocols.


//The numberOfItemsInSection() function returns the number of playlists in the playlists array.
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    //The cellForItemAt() function dequeues and returns a FeaturedPlaylistCollectionViewCell and configures it with the corresponding Playlist object.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.confgure(with: FeaturedPlaylistCellViewModel(name: playlist.name,
                                                          artworkURL: URL(string: playlist.images.first?.url ?? ""),
                                                          creatorName: playlist.owner.display_name))
        return cell
    }
    
    // The didSelectItemAt() function is called when a playlist cell is selected and initializes and pushes a PlaylistViewController onto the navigation stack.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

