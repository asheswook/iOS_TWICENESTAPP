//
//  BoardViewController.swift
//  TWICENEST
//
//  Created by Jaewook Lee on 2021/07/02.
//

import UIKit
import WebKit
import SafariServices

extension WKWebView {

    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }

    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}

class BoardViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        
        
        webView.navigationDelegate = self
        
        loadWeb(htmlstr: "https://www.twicenest.com/")
        self.title = "트둥토크"
        
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.httpCookieStore.getAllCookies({ (cookies) in
            print(cookies)
        })
        
        webView.cleanAllCookies()
        webView.refreshCookies()
        
        dataStore.httpCookieStore.getAllCookies({ (cookies) in
            print(cookies)
        })
        
        sendPost(paramText: "_filter=widget_login&error_return_url=%2F&mid=index&user_id=wookboy00&passwords=akfmxlsh1!&module=member&act=procMemberLogin&_rx_ajax_compat=XMLRPC&_rx_csrf_token=&vid=", urlString: "https://www.twicenest.com")
        
        
        
        
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
    

    func sendPost(paramText: String, urlString: String) {
        // paramText를 데이터 형태로 변환
        let paramData = paramText.data(using: .utf8)

        // URL 객체 정의
        let posturl = URL(string: urlString)
        
        // URL Request 객체 정의
        var request = URLRequest(url: posturl!)
        request.httpMethod = "POST"
        request.httpBody = paramData

        // HTTP 메시지 헤더
        request.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("https://www.twicenest.com", forHTTPHeaderField: "Origin")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        request.setValue("www.twicenest.com", forHTTPHeaderField: "Host")
        request.setValue("ko-kr", forHTTPHeaderField: "Accept-Language")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        
        print(String(paramData!.count))

        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            DispatchQueue.main.async() {
                // 서버로부터 응답된 스트링 표시
                let outputStr = String(data: data!, encoding: String.Encoding.utf8)
                print("result: \(outputStr!)")
            }
            
        }
        // POST 전송
        task.resume()
    }
    
}

