import Flutter
import GenericJSONType
import JSBridge
import Marionette
import PromiseKit
import UIKit

extension Promise where T == Void {
    func flutter(_ result: @escaping FlutterResult) {
        self.done { _ in
            result(nil)
        }.catch {
            if let err = $0 as? JSError {
                result(FlutterError(code: err.code ?? "EUNKNOWN", message: err.message, details: nil))
            } else {
                result(FlutterError(code: "EUNKNOWN", message: $0.localizedDescription, details: nil))
            }
        }
    }
}

extension Promise where T: Encodable {
    func flutter(_ result: @escaping FlutterResult) {
        self.done {
            let encoder = JSONEncoder()
            result(String(data: try! encoder.encode([$0]).dropFirst().dropLast(), encoding: .utf8)!)
        }.catch {
            if let err = $0 as? JSError {
                result(FlutterError(code: err.code ?? "EUNKNOWN", message: err.message, details: nil))
            } else {
                result(FlutterError(code: "EUNKNOWN", message: $0.localizedDescription, details: nil))
            }
        }
    }
}

public class SwiftFlutterMarionettePlugin: NSObject, FlutterPlugin {
    static var pages = Dictionary<String, Marionette>()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_marionette", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMarionettePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "init":
                let id = UUID().uuidString
                let page = Marionette()
                page.webView.frame = page.webView.frame.offsetBy(dx: -4000, dy: -4000)
                UIApplication.shared.windows.first?.addSubview(page.webView)
                SwiftFlutterMarionettePlugin.pages[id] = page
                result(id)
            case "dispose":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.webView.removeFromSuperview()
                SwiftFlutterMarionettePlugin.pages.removeValue(forKey: id)
            case "click":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let selector = (call.arguments as! Dictionary<String, AnyObject>)["selector"] as! String
                (SwiftFlutterMarionettePlugin.pages[id]!.click(selector)).flutter(result)
            case "evaluate":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let script = (call.arguments as! Dictionary<String, AnyObject>)["script"] as! String
                (SwiftFlutterMarionettePlugin.pages[id]!.evaluate(script) as Promise<JSON>).flutter(result)
            case "goto":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let url = (call.arguments as! Dictionary<String, AnyObject>)["url"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.goto(URL(string: url)!).flutter(result)
            case "setContent":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let html = (call.arguments as! Dictionary<String, AnyObject>)["html"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.setContent(html).flutter(result)
            case "type":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let selector = (call.arguments as! Dictionary<String, AnyObject>)["selector"] as! String
                let text = (call.arguments as! Dictionary<String, AnyObject>)["text"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.type(selector, text).flutter(result)
            case "reload":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.reload().flutter(result)
            case "waitForFunction":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let fn = (call.arguments as! Dictionary<String, AnyObject>)["fn"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.waitForFunction(fn).flutter(result)
            case "waitForNavigation":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.waitForNavigation().flutter(result)
            case "waitForSelector":
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let selector = (call.arguments as! Dictionary<String, AnyObject>)["selector"] as! String
                SwiftFlutterMarionettePlugin.pages[id]!.waitForSelector(selector).flutter(result)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
