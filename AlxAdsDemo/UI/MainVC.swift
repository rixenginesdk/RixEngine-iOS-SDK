//
//  MainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class MainVC: BaseUIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("ad_list", comment: "")
        
        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 10
        contentView.alignment = .top
        
        let bnAlx=createButton(title: NSLocalizedString("alx_ad", comment: ""), action: #selector(bnAlx))
        contentView.addArrangedSubview(bnAlx)
        
        let bnMax=createButton(title: NSLocalizedString("max_ad", comment: ""), action: #selector(bnMax))
        contentView.addArrangedSubview(bnMax)
        
        let bnAdmob=createButton(title: NSLocalizedString("admob_ad", comment: ""), action: #selector(bnAdmob))
        contentView.addArrangedSubview(bnAdmob)
        
        let bnTopOn=createButton(title: NSLocalizedString("topOn_ad", comment: ""), action: #selector(bnTopOn))
        contentView.addArrangedSubview(bnTopOn)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            bnAlx.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnAlx.heightAnchor.constraint(equalToConstant: 50),
            
            bnMax.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnMax.heightAnchor.constraint(equalToConstant: 50),
            
            bnAdmob.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnAdmob.heightAnchor.constraint(equalToConstant: 50),
            
            bnTopOn.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnTopOn.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
            self.requestATTPermission()
        }
        
    }
    
    func requestATTPermission() {
        if #available(iOS 14, *) {
            print("requestATTPermission")
            ATTrackingManager.requestTrackingAuthorization{ status in
                // 处理授权结果
                UserDefaults.standard.set(true, forKey: "hasRequestedTrackingAuthorization")
                
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("idfa:", idfa)
            }
        } else {
            //you got permission to track, iOS 14 is not yet installed
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("idfa:", idfa)
        }
    }
    
    @objc func bnAlx(){
        self.navigationController?.pushViewController(AlxMainVC(), animated: false)
    }
    
    @objc func bnMax(){
        self.navigationController?.pushViewController(MaxMainVC(), animated: false)
    }
    
    @objc func bnAdmob(){
        self.navigationController?.pushViewController(AdmobMainVC(), animated: false)
    }
    
    @objc func bnTopOn(){
        self.navigationController?.pushViewController(TopOnMainVC(), animated: false)
    }
    
    

}
