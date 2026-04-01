//
//  MainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class MainVC: BaseMenuVC {

    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("Alx_ad",    comment: ""), makeVC: { AlxMainVC() }),
        (title: NSLocalizedString("max_ad",    comment: ""), makeVC: { MaxMainVC() }),
        (title: NSLocalizedString("admob_ad",  comment: ""), makeVC: { AdmobMainVC() }),
        (title: NSLocalizedString("topOn_ad",  comment: ""), makeVC: { TopOnMainVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("ad_list", comment: "")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.requestATTPermission()
        }
    }

    // MARK: - ATT

    private func requestATTPermission() {
        if #available(iOS 14, *) {
            print("requestATTPermission")
            ATTrackingManager.requestTrackingAuthorization { status in
                UserDefaults.standard.set(true, forKey: "hasRequestedTrackingAuthorization")

                switch status {
                case .authorized:   print("Authorized")
                case .denied:       print("Denied")
                case .notDetermined:print("Not Determined")
                case .restricted:   print("Restricted")
                @unknown default:   print("Unknown")
                }
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("idfa:", idfa)
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("idfa:", idfa)
        }
    }

    // MARK: - Debug

    private func lookAppCacheDir() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        print("缓存目录路径：\(cacheURL)")
    }
}
