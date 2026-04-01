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
        (title: NSLocalizedString("levelPlay_ad",  comment: ""), makeVC: { LevelPlayMainVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("ad_list", comment: "")
        // 添加底部标识 Label
        setupFooterLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.requestATTPermission()
        }
    }
    
    /// 设置底部标识 Label
    private func setupFooterLabel() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        footerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = "♠️ AlxAds Swift Demo"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        tableView.tableFooterView = footerView
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
