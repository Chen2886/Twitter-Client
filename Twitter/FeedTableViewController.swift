//
//  FeedTableViewController.swift
//  Twitter
//
//  Created by Tony Chen on 2/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    var tweetArr = [NSDictionary]()
    let myrefresh = UIRefreshControl()
    var numOfTweets = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        loadTweets()
        myrefresh.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myrefresh
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadTweets()
    }
    
    @objc func loadTweets() {
        let tweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let param = ["counts": numOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: param, success: { (tweets: [NSDictionary]) in
            self.tweetArr.removeAll()
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            print(tweets)
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("can't get tweets")
        })
    }
    
    func loadMoreTweets() {
       let tweetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 200
        let param = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetURL, parameters: param, success: { (tweets: [NSDictionary]) in
            self.tweetArr.removeAll()
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            print(tweets)
            self.tableView.reloadData()
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("can't get tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == tweetArr.count) {
            loadMoreTweets()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        let imageURL = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: imageURL!)
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.name.text = (user["name"] as! String)
        cell.tweet.text = (tweetArr[indexPath.row]["text"] as! String)
        cell.setFavorited(tweetArr[indexPath.row]["favorited"] as! Bool)
        cell.tweet.numberOfLines = 0
        cell.tweetID = (tweetArr[indexPath.row]["id"] as! Int)
        cell.setRT(tweetArr[indexPath.row]["retweeted"] as! Bool)
        cell.tweet.lineBreakMode = .byWordWrapping
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArr.count
    }

    @IBAction func logoutClicked(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "loggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
}
