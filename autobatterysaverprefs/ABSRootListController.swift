import UIKit
import Preferences

class ABSRootListController: PSListController {

    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            }
            let specifiers = loadSpecifiers(fromPlistName: "AutoBatterySaverPrefs", target: self)
            setValue(specifiers, forKey: "_specifiers")
            return specifiers
        }
        set {
            super.specifiers = newValue
        }
    }

    @objc func respring() {
        var pid: pid_t = 0
        let args: [UnsafeMutablePointer<CChar>?] = ["killall", "-9", "SpringBoard", nil].map { $0?.withCString(strdup) }
        posix_spawn(&pid, "/usr/bin/killall", nil, nil, args, nil)
        waitpid(pid, nil, WEXITED)
    }

    @objc func openTwitter() {
        guard let url = URL(string: "https://twitter.com/i4M1k0SU") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
