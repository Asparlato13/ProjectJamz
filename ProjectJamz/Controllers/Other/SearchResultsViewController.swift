//
//  SearchResultsViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}


//defines a SearchResultsViewController which is a subclass of UIViewController. The view controller displays a list of search results in a table view. The SearchResultsViewController has a delegate property of type SearchResultsViewControllerDelegate that can be set to an object that implements the didTapResults(_:) method.

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResults(_ result: SearchResult)
}



//The SearchResultsViewController has a sections property that is an array of SearchSection objects, where each section has a title and an array of SearchResult objects.

//he SearchResultsViewController conforms to the UITableViewDelegate and UITableViewDataSource protocols and implements their required methods.
class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    //The tableView(_:cellForRowAt:) method returns a table view cell for a given index path. The tableView(_:didSelectRowAt:) method is called when a user taps a cell in the table view and calls the didTapResults(_:) method on the delegate.
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //The update(with:) method is called to update the search results displayed by the SearchResultsViewController. It filters the search results into different arrays based on the type of SearchResult, creates SearchSection objects with the filtered arrays, and sets the sections property to an array of the SearchSection objects. It also reloads the table view and sets the isHidden property to true if the search results are empty.
    func update(with results: [SearchResult]) {
        let artists = results.filter( {
            switch $0 {
            case .artists: return true
            default: return false
            }})
        let albums = results.filter( {
            switch $0 {
            case .album: return true
            default: return false
            }})
        let tracks = results.filter( {
            switch $0 {
            case .track: return true
            default: return false
            }})
        let playlists = results.filter( {
            switch $0 {
            case .playlist: return true
            default: return false
            }}
            )
//        let profiles = results.filter( {
//            switch $0 {
//            case .profile: return true
//            default: return false
//            }}
//            )
      
       
        
        self.sections = [
        SearchSection(title: "Songs", results: tracks),
        SearchSection(title: "Artists", results: artists),
        SearchSection(title: "Playlists", results: playlists),
        SearchSection(title: "Albums", results: albums),
     //   SearchSection(title: "User Profiles", results: profiles)
        ]
        
        
        tableView.reloadData()
        //if empty it will result to true and is hidden
        tableView.isHidden = results.isEmpty
        
    }
    
    
  //  The numberOfSections(in:) method returns the number of sections in the sections property. The tableView(_:numberOfRowsInSection:) method returns the number of rows in a given section.


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
      //  let Acell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch result {
        case .artists(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .album(let album):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "-",
                imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .profile(let profile):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: profile.name,
                subtitle: profile.owner.display_name,
                imageURL: URL(string: profile.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell

            
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResults(result)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}



