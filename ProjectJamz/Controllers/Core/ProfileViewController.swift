//  ProfileViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit

//This code defines a ProfileViewController class that inherits from UIViewController.
//It has a private instance variable userID of type UserProfile.

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var models = [String]()
   
    private var profile = UserProfile.self
    

    
    init(profile: UserProfile) {
        self.profile = UserProfile.self
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
        view.backgroundColor = .systemBackground
    }
        
 override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     tableView.frame = view.bounds
    }
    
    
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("Profile Error: \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        
        }

        
    }
            
    private func updateUI(with model:  UserProfile){
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        //add profile image --- first go to terminal and install 3 thin g (44 mins into forth video)
        //createTableHeader(with: model.images.first.url)
        
        models.append("Plan: \(model.product)")
        tableView.reloadData()
        
    }
    
    
    

    //private func createTableHeader(with string: String?) {
        //guard let urlString = string, let url = URL(string: URLString) else {
          //  return
      //  }
    //   let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
    //     let imageSize: CGFloat = headerView.height/2
    //    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize , height: imageSize))
    //    headerView.addSubview(imageView)
    //    imageView.center = headerView.center
    //   imageView.contentMode = .scaleAspectFill
    //     imageView.sd_setImage(with url, completed: nil)
    // imageView.layer.masksToBounds =  true
        // imageView.layer.cornerRadius = imageSize/2
 //   tableView.tableHeaderView = headerView
    
    //}
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
        
        
    }
    
    //marrk: tableview
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}














//
//
//
//class ProfileViewController: UIViewController {
////
////, UITableViewDataSource, UITableViewDelegate
////{
//    //    private let userID: UserProfile
////    private let tableView: UITableView = {
////        let tableView = UITableView()
////        tableView.isHidden = true
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
////        return tableView
//  //  }()
//
// //   private var models = [String]()
//
//
//
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        title = "Profile"
////        tableView.delegate = self
////        tableView.dataSource = self
////        view.addSubview(tableView)
////        fetchProfile()
////        view.backgroundColor = .systemBackground
////
//    }
//
//
//    //This view controller is designed to show the profile of a particular user. The init method takes a UserProfile object as a parameter and sets the userID instance variable accordingly. This ensures that when creating an instance of ProfileViewController, the user profile is passed as an argument.
//    //    init(userID: UserProfile) {
//    //        self.userID = userID
//    //        super.init(nibName: nil, bundle: nil)
//    //    }
//
//    //The required init(coder:) method is implemented, but it is marked with fatalError which means that if it is called, the app will crash because this method has not been implemented yet.
//
//    //    required init?(coder: NSCoder) {
//    //        fatalError("init(coder:) has not been implemented")
//    //    }
//    //
//    //
//
//    //    func fetchData(){
//    //        APICaller.shared.getCurrentUserProfile (for: UserProfile) { [weak self] result in
//    //            DispatchQueue.main.sync {
//    //                switch result {
//    //                    //fetch tracks in actual album
//    //                case .success(let model):
//    //                    self?.UserProfile = model.name
//    //                    self?.viewModels = model.display_name.compactMap({
//    //                        AlbumCollectionViewCellViewModel(
//    //                        name: $0.name,
//    //                        artistName: $0.artists.first?.name ?? "-"
//    //
//    //                        )
//    //                    })
//    //                    self?.collectionView.reloadData()
//    //                case .failure(let error):
//    //                    //    break
//    //                    print(error.localizedDescription)
//    //                }
//    //            }
//    //        }
//    //    }
//    //
//    //override func viewDidLayoutSubviews() {
//    //    super.viewDidLayoutSubviews()
//    //    tableView.frame = view.bounds
//    //   }
//    //
//    //    private func fetchProfile() {
//    //       APICaller.shared.getCurrentUserProfile { [weak self] result in
//    //           DispatchQueue.main.async {
//    //               switch result {
//    //               case .success(let model):
//    //                   self?.updateUI(with: model)
//    //               case .failure(let error):
//    //                   print("Profile Error: \(error.localizedDescription)")
//    //                   self?.failedToGetProfile()
//    //            }
//    //        }
//    //    }
//    //}
//    //   private func updateUI(with model:  UserProfile){
//    //       tableView.isHidden = false
//    //       models.append("Full Name: \(model.display_name)")
//    //       models.append("Email Address: \(model.email)")
//    //       models.append("User ID: \(model.id)")
//    //       //add profile image --- first go to terminal and install 3 thin g (44 mins into forth video)
//    //       //createTableHeader(with: model.images.first.url)
//    //
//    //       models.append("Plan: \(model.product)")
//    //       tableView.reloadData()
//    //
//    //   }
//    //
//    ////   private func createTableHeader(with string: String?) {
//    ////       guard let urlString = string, let url = URL(string: URLString) else {
//    ////           return
//    ////       }
//    ////      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
//    ////        let imageSize: CGFloat = headerView.height/2
//    ////       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize , height: imageSize))
//    ////       headerView.addSubview(imageView)
//    ////       imageView.center = headerView.center
//    ////      imageView.contentMode = .scaleAspectFill
//    ////        imageView.sd_setImage(with url, completed: nil)
//    ////    imageView.layer.masksToBounds =  true
//    ////        imageView.layer.cornerRadius = imageSize/2
//    ////   tableView.tableHeaderView = headerView
//    ////
//    ////   }
//    ////
//    //   private func failedToGetProfile() {
//    //       let label = UILabel(frame: .zero)
//    //       label.text = "Failed to load profile."
//    //       label.sizeToFit()
//    //       label.textColor = .secondaryLabel
//    //       view.addSubview(label)
//    //       label.center = view.center
//    //
//    //
//    //   }
//    //
//    //   //marrk: tableview
//    //
//    //
//    //   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    //       return models.count
//    //   }
//    //   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    //       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//    //       cell.textLabel?.text = models[indexPath.row]
//    //       cell.selectionStyle = .none
//    //       return cell
//    //   }
//    //}
//}
//
