//
//  LoginViewController.swift
//  Twitter
//
//  Created by Jorge Garcia on 10/8/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedin") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterToken = "https://api.twitter.com/oauth/request_token"
//        https://developer.twitter.com/en/docs/authentication/api-reference/request_token
        TwitterAPICaller.client?.login(url: twitterToken, success:{
            UserDefaults.standard.set(true, forKey: "userLoggedin")
            self.performSegue(withIdentifier: "loginToHome",sender: self)},
                                       failure: { (Error) in
            print("could not login")
        })
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
