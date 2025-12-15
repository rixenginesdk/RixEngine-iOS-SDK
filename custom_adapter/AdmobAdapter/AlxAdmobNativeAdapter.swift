//
//  AlxAdmobNativeAdapter.swift
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlxAdmobNativeAdapter)
public class AlxAdmobNativeAdapter: AlxAdmobBaseAdapter,MediationNativeAd {
    
    private static let TAG = "AlxAdmobNativeAdapter"
    
    private var delegate:MediationNativeAdEventDelegate? = nil
    private var nativeAd:AlxNativeAd? = nil
    private var completionHandler: GADMediationNativeLoadCompletionHandler? = nil    
    
    public var headline: String?{
        nativeAd?.title
    }
    
    public var images: [NativeAdImage]?
    
    public var body: String?{
        nativeAd?.desc
    }
    
    public var icon: NativeAdImage?
    
    public var callToAction: String?{
        nativeAd?.callToAction
    }
    
    public var starRating: NSDecimalNumber?
    
    public var store: String?
    
    public var price: String?{
        get{
            if let price = nativeAd?.getPrice() {
                return String(price)
            }else{
                return nil
            }
        }
    }
    
    public var advertiser: String?{
        nativeAd?.adSource
    }
    
    public var extraAssets: [String : Any]?
    
    
    
    public func loadNativeAd(for adConfiguration: MediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        NSLog("%@: loadNativeAd",AlxAdmobNativeAdapter.TAG)
        guard let params = AlxAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlxAdmobNativeAdapter.TAG)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        if !AlxAdmobBaseAdapter.isInitialized {
            AlxAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlxAdmobNativeAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        NSLog("%@: loadNativeAd unitid=%@",AlxAdmobNativeAdapter.TAG,adId)
        self.completionHandler = completionHandler
        
        // load ad
        let loader=AlxNativeAdLoader(adUnitID: adId)
        loader.delegate = self
        loader.loadAd()
    }
    
    public func didRender(in view: UIView, clickableAssetViews: [GADNativeAssetIdentifier : UIView], nonclickableAssetViews: [GADNativeAssetIdentifier : UIView], viewController: UIViewController) {
        self.nativeAd?.rootViewController = viewController
        self.nativeAd?.registerView(container: view, clickableViews: Array(clickableAssetViews.values))
    }
    
    public func handlesUserClicks() -> Bool {
        return true
    }
    
    public func handlesUserImpressions() -> Bool {
        return true
    }
    
    private func downloadImages(nativeAd:AlxNativeAd,completion: @escaping () -> Void){
        if let icon = nativeAd.icon,let urlString = icon.url {
            if let url = URL(string: urlString) {
                let scale:CGFloat = icon.height == 0 ? 0 : CGFloat(icon.width / icon.height)
                self.icon = GoogleMobileAds.NativeAdImage(url: url, scale: scale)
            }
        }
        
        if let imageUrl = nativeAd.images?.first?.url {
            downloadImageAsync(imageUrl) { [weak self] result in
                if case .success(let image) = result {
                    self?.images = [GoogleMobileAds.NativeAdImage(image: image)]
                    completion()
                }else  {
                    completion()
                }
            }
        }
    }
    
    private func downloadImageAsync(_ urlString: String, completion: @escaping(Result<UIImage, NSError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(self.error(code: -101,msg: "Image URL is invalid")))
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let image = UIImage(data:data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(self.error(code: -102,msg: "Error while creating UIImage from received data")))
                    }
                }
            }catch{
                completion(.failure(self.error(code: -103,msg: error.localizedDescription)))
            }
        }
    }
    
}


extension AlxAdmobNativeAdapter:AlxNativeAdLoaderDelegate{
    
    public func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        NSLog("%@: nativeAdLoaded",AlxAdmobNativeAdapter.TAG)
        
        guard let nativeAd = ads.first else{
            if let handler=self.completionHandler{
                let errorStr="native ad data is empty"
                NSLog("%@: native ad data is empty",AlxAdmobNativeAdapter.TAG)
                self.delegate=handler(nil,self.error(code: -100,msg: errorStr))
            }
            return
        }
        
        self.nativeAd = nativeAd
        self.nativeAd?.delegate = self
        
        self.downloadImages(nativeAd: nativeAd){ [weak self] in
            guard let self = self else { return }
            if let handler = self.completionHandler{
                self.delegate=handler(self,nil)
            }
        }
        
    }
    
    public func nativeAdFailToLoad(didFailWithError error: Error) {
        NSLog("%@: nativeAdFailToLoad",AlxAdmobNativeAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(nil,error)
        }
    }
    
    
}

extension AlxAdmobNativeAdapter:AlxNativeAdDelegate{
    public func nativeAdImpression(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdImpression",AlxAdmobNativeAdapter.TAG)
        self.delegate?.reportImpression()
    }
    
    public func nativeAdClick(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdClick",AlxAdmobNativeAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func nativeAdClose(_ nativeAd:AlxNativeAd){
        NSLog("%@: nativeAdClose",AlxAdmobNativeAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
}
