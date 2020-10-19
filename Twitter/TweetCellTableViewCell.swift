//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Jorge Garcia on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

//COmponents dragged from the cell

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let tobeFavorited = !favorited
               
               if(tobeFavorited){
                   TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                       self.setFavorite(true)
//                       self.favLabel.text = String(Int(self.favLabel.text!)!+1)
                   }, failure: { (error) in
                       print("Favorite failed \(error)")
                   })
               }else{
                   TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                       self.setFavorite(false)
//                       self.favLabel.text = String(Int(self.favLabel.text!)!-1)

                   }, failure: { (error) in
                       print("Unfavorite failed \(error)")
                   })
               }
    }
    
    @IBAction func retweet(_ sender: Any) {
        
    }
    

    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isRetweeted:Bool){
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
            
        }else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
