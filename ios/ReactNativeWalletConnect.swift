import Foundation
import WalletConnectSwift

protocol ReactNativeWalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

@objc(ReactNativeWalletConnect)
class ReactNativeWalletConnect: NSObject {
    var client: Client!
    var session: Session!
    var delegate: ReactNativeWalletConnectDelegate?

    let sessionKey = "sessionKey"

    override init() {
       super.init()
    }

    init(delegate: ReactNativeWalletConnectDelegate) {
        super.init()
        self.delegate = delegate
    }

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a+b)
    }

    func connect() -> String {
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://bridge.walletconnect.org")!,
                           key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: "Ally Now",
                                            description: "Manage and track all your crypto in one place. Safely and simply.",
                                            icons: [URL(string: "https://allynow.com/wp-content/uploads/2020/12/logo.png")!],
                                            url: URL(string: "https://allynow.com")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try! client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }

    func connectToMetamask() {

        let url = connect()
        let metamaskURL = "https://metamask.app.link/"

        let urlFull = "wc?uri=" + encodeUri(uri: url)
        let deepLinkUrl = metamaskURL + urlFull

        if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
        }
    }

    func encodeUri(uri : String) -> String {
        let urlAllowed: CharacterSet = .alphanumerics.union(.init(charactersIn: "-._~")) // as per RFC 3986

        guard let encodedUri = uri.addingPercentEncoding(withAllowedCharacters: urlAllowed) else {
            return ""
        }
        return encodedUri
    }

}

extension ReactNativeWalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate?.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate?.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate?.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
