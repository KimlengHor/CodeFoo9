//
//  WebViewController.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/16/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //Outlets
    @IBOutlet weak var webView: WKWebView!
    
    //Variables
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
