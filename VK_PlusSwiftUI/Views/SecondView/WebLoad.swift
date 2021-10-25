//
//  WebLoad.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    
    @Binding var isAuthorizationVK: Bool
    var changeIsAuthorizationVK: Bool = false {
        didSet {
            isAuthorizationVK = changeIsAuthorizationVK
        }
    }

    var coordinator = Coordinator()
    let webView: WKWebView
    
    func makeCoordinator() -> WebView.Coordinator {
        coordinator.delegate = self
        return coordinator
       }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    
    class Coordinator: NSObject, WKNavigationDelegate, ObservableObject {
        var delegate: WebView!
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

            guard let url = navigationResponse.response.url,
                url.path == "/blank.html",
                let fragment = url.fragment
            else
            { decisionHandler(.allow)
                return
            }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }

            print(params)
            
            guard let token = params["access_token"],
                let userIdString = params["user_id"],
                let _ = Int(userIdString) else {
                    decisionHandler(.allow)
                    return
            }

            DataAboutSession.data.token = token
            if let userIDInt = Int(userIdString) {
                DataAboutSession.data.userID = userIDInt
            }
    
            delegate.changeIsAuthorizationVK = true
            decisionHandler(.cancel)
            
//        DataAboutSession.data.userID = 647133643
//        DataAboutSession.data.token = "3ebbc520ab5e30960484d6e5fdac0f85e15d357c1ce2018d809ea455441466797554e076db250d8d8e8de"

        }
    }
}

class WebViewModel: ObservableObject {
    let webView: WKWebView
    
    private var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7968642"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
    ]
        return urlComponents
    }()
    
    lazy var request = URLRequest(url: urlComponents.url!)
    
    init() {
        webView = WKWebView (frame: .zero)
//        logOutSegue()
        loadUrl()
    }
    
    func loadUrl() {
        DispatchQueue.main.async { [self] in
            self.webView.load(request)
        }
    }
    
    func logOutSegue(){
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("vk") {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: { [weak self] in
                        self?.webView.load(self!.request)
                    })
                }
            }
        }
        DispatchQueue.main.async { [self] in
            self.webView.load(request)
        }
    }
}


struct WebLoad: View {
    @ObservedObject var model = WebViewModel()
    @State var isAuthorizationVK = false

    var body: some View {
        VStack {
            WebView(isAuthorizationVK: $isAuthorizationVK, webView: model.webView)
                .frame(height: UIScreen.main.bounds.height-400)
//            Text("Логин: +380970795220")
//            Text("Пароль: 171819B1")
//            Spacer()
        }
        .fullScreenCover(isPresented: $isAuthorizationVK, content: {
            SecondViewWithTab()
        })
    }
}






