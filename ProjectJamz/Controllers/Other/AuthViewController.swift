//
//  AuthViewController.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//


// defines an AuthViewController class, which is a UIViewController that displays a WKWebView. The purpose is to allow the user to sign in to an external service (SPOTIFY) by showing a web page where the user can enter their credentials.

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate  {

    
    //In the viewDidLoad method, the view controller sets up the WKWebView by creating a WKWebViewConfiguration with a WKWebpagePreferences that allows JavaScript, and then creating a WKWebView with this configuration. It then loads a URL into the WKWebView by creating a URLRequest with the signInURL property from an AuthManager instance and passing it to the load method of the WKWebView.
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    
    //The AuthViewController has a completionHandler property, which is a closure that will be called when the authentication process is complete. This closure takes a single Bool argument, which indicates whether the authentication was successful or not.
    public var completionHandler: ((Bool) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
   
    
    
    //In the webView(_:didStartProvisionalNavigation:) method, the view controller handles the user signing in. When the user successfully signs in, the external service will redirect the web page to a URL that contains a query parameter called code, which contains an authorization code. The view controller extracts this code and passes it to the AuthManager's exchangeCodeForToken method, which exchanges the authorization code for an access token.
                //If the exchange is successful, the view controller dismisses itself and shows a TabBarViewController, which is the main view controller of the app.
                //If the exchange is not successful, the view controller dismisses itself and returns the failure to the completionHandler closure.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        //exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return
        }
        
        webView.isHidden = true
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in DispatchQueue.main.async {
            let mainAppTabBarVC = TabBarViewController()
            mainAppTabBarVC.modalPresentationStyle = .fullScreen
            self?.present(mainAppTabBarVC, animated: true)
            self?.navigationController?.popToRootViewController(animated: true)
           // self?.performSegue(withIdentifier: "loggedinsegue", sender: nil)
            self?.completionHandler?(success)
        }
            
        }
    }
    
}

