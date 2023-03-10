//
//  WelcomeViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import UIKit

//the welcome page


//The @IBOutlet declarations define outlets for four user interface elements: a UIImageView called logoImage, a UILabel called loveLabel, a UILabel called welcomeLabel, and a UIButton called loginButton.
class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var logoImage: UIImageView!
    
   
    @IBOutlet weak var loveLabel: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    //The lazy var gradient declaration initializes a CAGradientLayer object with an array of four colors, which are used to create a gradient effect. The locations property specifies the position of each color in the gradient.
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [ UIColor.systemPurple.cgColor,
                                   UIColor.systemIndigo.withAlphaComponent(255/255).cgColor,
       
                                   UIColor.systemTeal.cgColor,
                                   UIColor.systemGreen.withAlphaComponent(30/255).cgColor,
       
                       ]
                  gradient.locations = [0.34, 0.55, 0.8,1]

        return gradient
    }()
    
    
    
    //In the viewDidLoad method, the gradient object is configured and added to the view's layer hierarchy, as a sublayer at index 0. The loginButton, logoImage, welcomeLabel, and loveLabel are then brought to the front of the view's subview hierarchy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(logoImage)
        view.bringSubviewToFront(welcomeLabel)
        view.bringSubviewToFront(loveLabel)
        
        
        
    }
    
    
    //The didTapSignInButton method is called when the user taps the loginButton. It creates an instance of AuthViewController and sets its completionHandler property to a closure that updates the user interface based on the success or failure of the authentication process. Then it configures the navigation bar and pushes the new view controller onto the navigation stack

    @IBAction func didTapSignInButton(_ sender: Any) {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //The handleSignIn method is called by the closure that's passed to AuthViewController. It either logs the user in or presents an error message, based on the value of the success parameter. If the authentication was successful, it presents a TabBarViewController modally.
    private func handleSignIn(success: Bool) {
        //log user in or output at them for error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
    }
    
    
    
}



