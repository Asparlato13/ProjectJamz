//
//  AuthManager.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import Foundation

//an authentication manager for an iOS application that uses the Spotify API. It handles authentication and token management for the user's session



//The AuthManager is a singleton class, which means there can only be one instance of it in the application, and it is globally accessible via the shared property.
final class AuthManager {
    static let shared = AuthManager()
    
    
    //The class has several private properties and constants that are used to manage the authentication and token lifecycle, such as refreshingToken, accessToken, refreshToken, tokenExpirationDate, and shouldRefreshToken.
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "ab027d55519d415ab1f51c14affc4fd9"
        static let clientSecret = "8c0dbe2c182742028789cab1a2e3ceae"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    //The signInURL property is a computed property that returns the Spotify authorization URL, which the user can use to sign in to the application and authorize the app to access their Spotify data
    
    public var signInURL: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
        
        
       
    }
    
    
    //The exchangeCodeForToken method is used to exchange the authorization code received from the Spotify authorization server with an access token that can be used to make API calls. It sends a POST request to the Spotify token API with the authorization code and other parameters, and on success, it caches the token data in UserDefaults.
    public func exchangeCodeForToken(code: String, completion: @escaping((Bool) -> Void))
    {
    //get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in guard let data = data, error == nil else {
            completion(false)
            return
        }
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
}
    
    //The onRefreshBlocks property is an array of completion handlers that are executed when the token is refreshed. It is used to automatically retry the API call that failed due to an expired token after the token is refreshed.
    private var onRefreshBlocks = [((String) -> Void)]()
    
    
    //Supplies valid token to be used with API Calls
    //The withValidToken method is used to supply a valid access token to be used with API calls. If the token is expired, it automatically refreshes it if possible, and the new token is cached in UserDefaults. If the refresh fails, the completion handler is called with a false argument.
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            //append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            //refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
            
        }
        else if let token = accessToken {
            completion(token)
        }
    }
    
    
    //The refreshIfNeeded method is used to refresh the access token if it is expired. It sends a POST request to the Spotify token API with the refresh token and other parameters, and on success, it caches the new token data in UserDefaults. If the refresh fails, the completion handler is called with a false argument.
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
    }
    
        
        guard let refreshToken = self.refreshToken else {
            return
        }

        
        //refresh the token:
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
        
        
            return
        }
        
        refreshingToken = true
        
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
       
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
            completion?(false)
            return
        }
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{ $0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
        
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
    }
        
    
    //func to sign out
    public func signOut(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil,
                                       forKey: "access_token")
       
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        completion(true)
    }
        
    }
    
    






