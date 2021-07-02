//
//  WriteViewController.swift
//  TWICENEST
//
//  Created by Jaewook Lee on 2021/07/03.
//

import Foundation
import WebKit
import UIKit

class WriteViewController: UIViewController {
    
    let writeFormUrl = "https://www.twicenest.com/index.php?mid=board&act=dispBoardWrite"
    let twiceColor = UIColor(displayP3Red: 253, green: 98, blue: 162, alpha: 1)
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = twiceColor
        super.viewDidLoad()
        loadWeb(htmlstr: writeFormUrl)
        
        self.title = "글쓰기"
    }
    
    
    func loadWeb(htmlstr: String){
        let url = URL(string: htmlstr)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let urlStr = navigationAction.request.url?.absoluteString {
                if urlStr != writeFormUrl {
                    loadWeb(htmlstr: writeFormUrl)
                }
            }
            
        }
    }
}
