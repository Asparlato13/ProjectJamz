//
//  AccountViewController.swift
//  ProjectJamz
//
//  Created by Adrianna Parlato on 3/10/23.
//

import UIKit

class AccountViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Create a UITableView instance
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    // Create an array to store profile information
    private var models = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the view controller
        title = "Profile"
        // Set the delegate and data source of the table view
        tableView.delegate = self
        tableView.dataSource = self
        // Add the table view to the view hierarchy
        view.addSubview(tableView)
        // Fetch the user's profile information
        fetchProfile()
        view.backgroundColor = .systemBackground
    }
        
 override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     tableView.frame = view.bounds
    }
    
    
    // Fetch the user's profile information from an API
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    //print(result)
                    // Update the UI with the received profile information
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("Profile Error: \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        
        }

        
    }
    // Update the UI with the user's profile information
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        // Add profile information to the models array
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        //add profile image --- first go to terminal and install 3 thin g (44 mins into forth video)
        createTableHeader(with: model.images.first?.url)
        
        models.append("Plan: \(model.product)")
        tableView.reloadData()
        
    }
    // Create a custom table header view with a profile image
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        // Create a view for the table header
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
           // Create an image view for the profile image
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize , height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        // Set the content mode and load the image using SDWebImage library
       imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with:url, completed: nil)
        // Apply styling to the profile image
     imageView.layer.masksToBounds =  true
         imageView.layer.cornerRadius = imageSize/2
    tableView.tableHeaderView = headerView
    
    }
    
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


