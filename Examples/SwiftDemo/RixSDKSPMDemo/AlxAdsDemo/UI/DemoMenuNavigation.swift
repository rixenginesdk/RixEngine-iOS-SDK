//
//  DemoMenuNavigation.swift
//  AlxAdsDemo
//
//  菜单导航辅助：预加载二级页面、延后 push，降低首次跳转卡顿。
//

import UIKit

enum DemoMenuNavigation {

    private static var didWarmupPlatformClasses = false

    /// 主页面首帧展示后预触达二级页面 Class，提前完成 dyld / 静态链接开销。
    static func warmupPlatformViewControllersIfNeeded() {
        guard !didWarmupPlatformClasses else { return }
        didWarmupPlatformClasses = true
        DispatchQueue.main.async {
            _ = AlxMainVC.self
            _ = AdmobMainVC.self
            _ = MaxMainVC.self
//            _ = TopOnMainVC.self
            _ = LevelPlayMainVC.self
            _ = TestMainVC.self
        }
    }

    /// 将 VC 创建与 push 切到下一 runloop，避免与点击反馈、转场动画同帧争抢主线程。
    static func push(_ type: UIViewController.Type, from navigationController: UINavigationController?) {
        DispatchQueue.main.async {
            let vc = type.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

/// 聚合 SDK 初始化统一延后到转场结束后再执行，避免 push 动画期间掉帧。
protocol DemoDeferredSDKInitializing: AnyObject {
    var didScheduleSDKInit: Bool { get set }
    func performSDKInitialization()
}

extension DemoDeferredSDKInitializing where Self: UIViewController {
    func scheduleSDKInitializationIfNeeded() {
        guard !didScheduleSDKInit else { return }
        didScheduleSDKInit = true
        DispatchQueue.main.async { [weak self] in
            self?.performSDKInitialization()
        }
    }
}
