//
//  DocumentViewController.swift
//  TWICENEST
//
//  Created by Jaewook Lee on 2021/07/02.
//

import Foundation
import WebKit
import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeb(htmlstr: "https://www.twicenest.com/")
    }
    
    func loadWeb(htmlstr: String){
        let url = URL(string: htmlstr)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
