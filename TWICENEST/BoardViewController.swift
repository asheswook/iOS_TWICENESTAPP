//
//  BoardViewController.swift
//  TWICENEST
//
//  Created by Jaewook Lee on 2021/07/02.
//

import UIKit
import WebKit
import SafariServices

class BoardViewController: UIViewController, WKNavigationDelegate {


    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadWeb(htmlstr: "https://www.twicenest.com/board")
    }

    func loadWeb(htmlstr: String){
        let url = URL(string: htmlstr)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("www.twicenest.com"),
                    UIApplication.shared.canOpenURL(url) {
                    // 외부 링크
                    
                    let safariViewController = SFSafariViewController(url: url) // safari present
                    present(safariViewController, animated: true, completion: nil)

                    print("no host. redirect to safari browser")
                    decisionHandler(.cancel)
                    
                } else {
                    // host 링크
                    if let urlStr = navigationAction.request.url?.absoluteString {
                        if isWebDocument(urlString: urlStr) {
                            let DocumentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as? DocumentViewController
                            DocumentViewController?.presentedURL = urlStr
                            
                            self.navigationController?.pushViewController(DocumentViewController!, animated: true)
                            decisionHandler(.cancel)
                            
                        } else {
                            print("Open it locally")
                            decisionHandler(.allow)
                        }
                    }
                    
                }
            } else {
                // 유저 인풋 no, just request
                print("not a user click")
                decisionHandler(.allow)
            }
        }
    
    func isWebDocument(urlString: String) -> Bool {
        let urlList = ["document_srl=", "/board/"]
        
        for (index, allowUrl) in urlList.enumerated() {
            if urlString.contains(allowUrl) {
                return true
            } else if index == urlList.count {
                return false
            }
        }
        return false
    }

    



}

