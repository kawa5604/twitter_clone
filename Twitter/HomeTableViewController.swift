//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Jorge Garcia on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
  
class HomeTableViewController: UITableViewController {

    
    //tweet array
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    // Refresh controller instance
    let myRefreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //the function to get the tweets gets called whrn the view loads
        loadTweet()
        // Std refresh coontroller will call the function to reload tweets
        myRefreshController.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshController
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweet()
    }
    // function to pull the tweets from the API
    @objc func loadTweet(){
        numberOfTweet = 50
        //from the twitter developer API website
        let twitterBaseURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let twitterParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterBaseURL, parameters: twitterParams as [String : Any], success: { (tweets:[NSDictionary]) in
            for tweet in tweets {
                self.tweetArray.removeAll()
                self.tweetArray.append(tweet)
                //any time we call the API we repopulate the data
                self.tableView.reloadData()
                //when the table gets updated you stop the refreshing
                self.myRefreshController.endRefreshing()
            }
        }, failure: { (Error) in
            print("could not retrieve tweets here")
        })
    }
    
    
    func loadMoreTweets(){
            
            let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            
            numberOfTweet+=20
            
            let myParams = ["count": numberOfTweet]
            
            
            TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: {
                ( tweets: [NSDictionary]) in
                
                self.tweetArray.removeAll()
                for tweet in tweets {
                    self.tweetArray.append(tweet)
                }
                
                self.tableView.reloadData()
                self.myRefreshController.endRefreshing()
                
            }, failure: { (Error) in
                print("Could not load tweets")
            })
        }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        //dismiss the screen when loggin out
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedin")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as!  TweetCellTableViewCell
        // extract the user dict from thje tweet array
        // user has several vallues and we need to extract name from it
        //this user will also hold the profile image
        let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.usernameLabel.text = user["screen_name"] as? String
        cell.tweetLabel.text = (self.tweetArray[indexPath.row]["text"] as! String)
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        //retweet and like
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //How many sections do you want?
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //depends on how many tweets we are getting
        
        return self.tweetArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
