import SwiftUI
import WebKit

/// Thin WKWebView wrapper, used for the browser-based Fun & Games tools that live on simonsays.coach.
///
/// The site's navigation bar and footer are hidden so the page reads as part of the app,
/// and taps on links that would leave the tool are handed to Safari instead of navigating
/// the web view. When Simon publishes header-less copies under `/app/`, point `Theme.toolsBase`
/// at them and this stays a belt-and-braces fallback.
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    /// CSS that removes the site chrome. Injected at document start so it never flashes.
    private static let chromeHidingCSS = """
    nav.ss-nav, footer.ss-foot, .ss-nav, .ss-foot, header.site-header, .site-footer { display: none !important; }
    body { padding-top: 0 !important; }
    main { padding-top: 12px !important; }
    """

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let js = """
        (function() {
          var s = document.createElement('style');
          s.textContent = \(Self.chromeHidingCSS.debugDescription);
          (document.head || document.documentElement).appendChild(s);
        })();
        """
        config.userContentController.addUserScript(
            WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        )

        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = context.coordinator
        web.allowsBackForwardNavigationGestures = false
        web.load(URLRequest(url: url))
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        init(_ parent: WebView) { self.parent = parent }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Only user-initiated link taps are filtered; the initial load, redirects, and
            // in-page (hash) changes go through untouched.
            guard navigationAction.navigationType == .linkActivated,
                  let target = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            let samePage = target.host == parent.url.host && target.path == parent.url.path
            if samePage {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
                UIApplication.shared.open(target)
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}

struct WebPage: View {
    let title: String
    let url: URL
    @State private var isLoading = true

    var body: some View {
        ZStack {
            WebView(url: url, isLoading: $isLoading)
            if isLoading {
                ProgressView().controlSize(.large)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
