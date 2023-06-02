//  ProfileViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit


// the ProfileViewController class fetches the current user's profile data from an API, updates the UI with the fetched data, and shows an error message if the API request fails. It also creates a table header with the user's profile image and displays the user's profile information in a table view.
//This code defines a ProfileViewController class that inherits from UIViewController.

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //The tableView is created as a private constant property, which is hidden initially and registered with a default UITableViewCell.
    
  
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    
    //  There is an array called models which is used to store the profile information fetched from the API.
    private var models = [String]()
    private var profile: UserProfile
 

    init(profile: UserProfile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
 
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    //In the viewDidLoad method, the tableView is added as a subview of the view, and the fetchProfile() method is called to fetch the user's profile data from the API.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
        //print(fetchProfile())
        view.backgroundColor = .systemBackground
    }
        
 override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     tableView.frame = view.bounds
    }
    
    //In the fetchProfile() method, the APICaller shared instance is used to fetch the current user's profile data. If the request is successful, the updateUI(with:) method is called to update the UI with the fetched data. If the request fails, the failedToGetProfile() method is called to show an error message on the scree
    
    private func fetchProfile() {
        APICaller.shared.getUserProfiles { [weak self] result in
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
            //The updateUI(with:) method updates the models array with the profile information fetched from the API and calls the createTableHeader(with:) method to add the user's profile image to the table header.
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        //add profile image --- first go to terminal and install 3 thin g (44 mins into forth video)
        //createTableHeader(with: model.images.first.url)
        
        models.append("Plan: \(model.product)")
        tableView.reloadData()
        
    }
    
    
    
    //The createTableHeader(with:) method creates a UIImageView with the user's profile image and adds it as a subview to a UIView that is used as the table header. The tableHeaderView property of the tableView is set to this UIView.
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
         let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize , height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
       imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
     imageView.layer.masksToBounds =  true
         imageView.layer.cornerRadius = imageSize/2
    tableView.tableHeaderView = headerView
    
    }
 //   The failedToGetProfile() method shows a label with an error message on the screen when the API request fails.
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
        
        
    }
    
    //marrk: tableview
    
    //The tableView(_:numberOfRowsInSection:) method returns the number of rows in the models array, and the tableView(_:cellForRowAt:) method sets the text of each cell to the corresponding item in the models array.
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









