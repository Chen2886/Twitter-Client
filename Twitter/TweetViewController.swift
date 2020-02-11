//
//  TweetViewController.swift
//  Twitter
//
//  Created by Tony Chen on 2/10/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    
    @IBOutlet weak var tweetContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetContent.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweetClicked(_ sender: Any) {
        if (!tweetContent.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetContent.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print("Tweet failed")
                print(Error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            print("empty tweet")
            self.dismiss(animated: true, completion: nil)
        }
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
