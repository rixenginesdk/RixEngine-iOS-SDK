//
//  AlxTopOnTool.swift
//

import Foundation

@objc(AlxTopOnTool)
public class AlxTopOnTool:NSObject {
    
    // MARK: - 单例 / Singleton
    static let shared = AlxTopOnTool()
    
    private override init() {
        super.init()
        requestDic = NSMutableDictionary()
    }
    
    // MARK: - 私有存储（线程安全） / Private Storage (Thread-safe)
    private var requestDic: NSMutableDictionary = [:]
    
    
    /**
     * 保存请求项。
     * Save a request item.
     * @param request 要保存的请求对象 / The request object to save.
     * @param unitID 对应的unitID / The corresponding unitID.
     */
    func saveRequestItem(_ request: Any, withUnitId unitID: String) {
        synchronized(self) {
            requestDic.setValue(request, forKey: unitID)
        }
    }
    
    /**
     * 获取请求项。
     * Get a request item.
     * @param unitID 对应的unitID / The corresponding unitID.
     * @return 保存的请求对象，可能为nil / The saved request object, may be nil.
     */
    func getRequestItem(withUnitID unitID: String) -> Any? {
        synchronized(self) {
            return requestDic.object(forKey: unitID)
        }
    }
    
    /**
     * 移除请求项。
     * Remove a request item.
     * @param unitID 对应的unitID / The corresponding unitID.
     */
    func removeRequestItem(withUnitID unitID: String) {
        synchronized(self) {
            requestDic.removeObject(forKey: unitID)
        }
    }
    
}

/**
 * 线程同步辅助函数，模拟OC的@synchronized。
 * Thread synchronization helper function, simulating OC's @synchronized.
 */
private func synchronized<T>(_ lock: Any, closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try closure()
}
