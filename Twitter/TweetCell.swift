//
//  TweetCell.swift
//  Twitter
//
//  Created by Tony Chen on 2/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var rt: UIButton!
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetID: Int = -1
    
    func setFavorited(_ isFav:Bool) {
        favorited = isFav
        if (favorited) {
            fav.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            fav.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    func setRT(_ isRT:Bool) {
        retweeted = isRT
        if (retweeted) {
            rt.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            rt.setImage(UIImage(named: "retweet-icon"), for: .normal)
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
    
    
    @IBAction func rtClicked(_ sender: Any) {
        if (retweeted) {
            TwitterAPICaller.client?.unrt(tweetID: tweetID, success: {
                print("success")
                self.setRT(false)
            }, failure: { (Error) in
                print("failed \(Error.localizedDescription)")
            })
        } else {
            TwitterAPICaller.client?.rt(tweetID: tweetID, success: {
                print("success")
                self.setRT(true)
            }, failure: { (Error) in
                print("failed \(Error.localizedDescription)")
            })
        }
    }
    
    @IBAction func favClicked(_ sender: Any) {
        if (favorited) {
            TwitterAPICaller.client?.unfavTweet(tweetID: tweetID, success: {
                print("success")
                self.setFavorited(false)
            }, failure: { (Error) in
                print("failed \(Error.localizedDescription)")
            })
        } else {
            TwitterAPICaller.client?.favTweet(tweetID: tweetID, success: {
                print("success")
                self.setFavorited(true)
            }, failure: { (Error) in
                print("failed \(Error.localizedDescription)")
            })
        }
    }
}
