//
//  BJKTVViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 27.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit

class BJKTVViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmbedVideo(videoId: "x31omum")
        
    self.title = "BJK TV"
 
    }
    
    func EmbedVideo(videoId:String) {
        let videoLink = URL(string: "https://www.dailymotion.com/embed/video/\(videoId)")
        myWebView.loadRequest(URLRequest(url: videoLink!))
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
