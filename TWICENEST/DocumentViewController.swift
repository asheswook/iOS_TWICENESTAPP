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
    
    var presentedURL: String = ""
    let twiceColor = UIColor(displayP3Red: 253, green: 98, blue: 162, alpha: 1)
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = twiceColor
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        
        loadWeb(htmlstr: presentedURL)
        
        self.title = "게시물"
        self.navigationController?.navigationBar.topItem?.title = "트둥토크"
    }
    
    @objc
    func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
    
    
    func loadWeb(htmlstr: String){
        let url = URL(string: htmlstr)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}

