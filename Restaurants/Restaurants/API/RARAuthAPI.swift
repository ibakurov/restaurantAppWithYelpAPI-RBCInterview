//
//  RARAuthAPI.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import Foundation
import Alamofire

class RARAuthAPI {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let keyGrantType = "grant_type"
        static let valueGrantType = "client_credentials"
        static let keyClientId = "client_id"
        static let keyClientSecret = "client_secret"
    }

    static let shared = RARAuthAPI()

    let manager: SessionManager = SessionManager()
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    /**
     This function authenticates current device to access Yelp's API
     
     @param success Called in non-main thread as a callback, after response from API request is received. Provides token to access Yealp's API
     @param failure Called in non-main thread as a cllback, if API request failed.
     */
    func authenticate(success: @escaping (String) -> (), failure: @escaping () -> () = {}) {
        
        //Generating parameters dictionary with all required parameters
        let parameters = [Constants.keyGrantType: Constants.valueGrantType,
                          Constants.keyClientId: RARConstantsAPI.clientId,
                          Constants.keyClientSecret: RARConstantsAPI.clientSecret]
        
        //Turning on spinning wheel on status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //Performing request to Yelp's API to obtain token.
        manager.request("\(RARConstantsAPI.baseAPIURL)/oauth2/token", method: .post, parameters: parameters).responseJSON { response in
            //Turning off spinning wheel on status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let result = response.result.value as? [String: Any], let token = result["access_token"] as? String {
                success(token)
                return
            }
            failure()
        }
    }
    
}
