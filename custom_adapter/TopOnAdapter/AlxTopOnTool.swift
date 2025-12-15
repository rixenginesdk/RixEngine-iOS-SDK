//
//  AlxTopOnTool.swift
//

import Foundation

@objc(AlxTopOnTool)
public class AlxTopOnTool:NSObject {
    
    // MARK: - 单例
    static let shared = AlxTopOnTool()
    
    private override init() {
        super.init()
        requestDic = NSMutableDictionary()
    }
    
    // MARK: - 私有存储（线程安全）
    private var requestDic: NSMutableDictionary = [:]
    
    
    /// 保存请求项
    /// - Parameters:
    ///   - request: 要保存的请求对象
    ///   - unitID: 对应的unitID
    func saveRequestItem(_ request: Any, withUnitId unitID: String) {
        synchronized(self) {
            requestDic.setValue(request, forKey: unitID)
        }
    }
    
    /// 获取请求项
    /// - Parameter unitID: 对应的unitID
    /// - Returns: 保存的请求对象，可能为nil
    func getRequestItem(withUnitID unitID: String) -> Any? {
        synchronized(self) {
            return requestDic.object(forKey: unitID)
        }
    }
    
    /// 移除请求项
    /// - Parameter unitID: 对应的unitID
    func removeRequestItem(withUnitID unitID: String) {
        synchronized(self) {
            requestDic.removeObject(forKey: unitID)
        }
    }
    
}

// 线程同步辅助函数，模拟OC的@synchronized
private func synchronized<T>(_ lock: Any, closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try closure()
}
