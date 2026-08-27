//
//  AlxRequestParamStore.swift
//  AlxAdsDemo
//

import Foundation
import AlxAds

final class AlxRequestParamStore {
    static let shared = AlxRequestParamStore()

    enum DebugAdType: String, CaseIterable {
        case rewardVideo = "reward_video"
        case interstitialVideo = "interstitial_video"
        case interstitialBanner = "interstitial_banner"

        var displayName: String {
            switch self {
            case .rewardVideo:
                return "激励视频"
            case .interstitialVideo:
                return "插屏视频"
            case .interstitialBanner:
                return "插屏Banner"
            }
        }
    }

    private enum Keys {
        static let selectedAdType = "alx_debug_request_selected_ad_type"
        static func bidFloorOverride(_ type: DebugAdType) -> String {
            return "alx_debug_user_ext_bid_floor_override_\(type.rawValue)"
        }
        static func videoExtJson(_ type: DebugAdType) -> String {
            return "alx_debug_video_ext_json_\(type.rawValue)"
        }
    }

    private static let defaultRewardVideoExtJson = """
{
  "skip": false,
  "skipafter": 5,
  "mute": false,
  "close": false,
  "usectrl": true,
  "silence": 12,
  "clkinvalid": false,
  "clkinvalidrate": 0.1,
  "closebtn": {
    "pos": 1,
    "count": 1,
    "countrate": 0,
    "jump": false,
    "jumprate": 0,
    "size": 1
  },
  "reward": {
    "clkskip": false,
    "clkskiprate": 0,
    "clkskipafter": 10
  },
  "track": {
    "viewurl": ["https://trk.rixengine.com/viewtime={VIEW_TIME}?123"]
  }
}
"""

    private static let defaultNonRewardVideoExtJson = """
{
  "skip": false,
  "skipafter": 5,
  "mute": false,
  "close": false,
  "usectrl": true,
  "silence": 12,
  "clkinvalid": false,
  "clkinvalidrate": 0.1,
  "closebtn": {
    "pos": 1,
    "count": 1,
    "countrate": 0,
    "jump": false,
    "jumprate": 0,
    "size": 1
  },
  "track": {
    "viewurl": ["https://trk.rixengine.com/viewtime={VIEW_TIME}?123"]
  }
}
"""

    private init() {}
    
    // video_ext 开关只在当前 app 会话中生效，避免历史状态污染联调结果
    private var runtimeVideoExtEnabledMap: [DebugAdType: Bool] = {
        var result: [DebugAdType: Bool] = [:]
        for type in DebugAdType.allCases {
            result[type] = false
        }
        return result
    }()

    var selectedAdType: DebugAdType {
        get {
            guard let raw = UserDefaults.standard.string(forKey: Keys.selectedAdType),
                  let type = DebugAdType(rawValue: raw) else {
                return .rewardVideo
            }
            return type
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.selectedAdType)
        }
    }

    var bidFloorOverride: String {
        get { bidFloorOverride(for: selectedAdType) }
        set { setBidFloorOverride(newValue, for: selectedAdType) }
    }

    var videoExtEnabled: Bool {
        get { videoExtEnabled(for: selectedAdType) }
        set { setVideoExtEnabled(newValue, for: selectedAdType) }
    }

    var videoExtJson: String {
        get { videoExtJson(for: selectedAdType) }
        set { setVideoExtJson(newValue, for: selectedAdType) }
    }

    func bidFloorOverride(for type: DebugAdType) -> String {
        UserDefaults.standard.string(forKey: Keys.bidFloorOverride(type)) ?? ""
    }

    func setBidFloorOverride(_ value: String, for type: DebugAdType) {
        UserDefaults.standard.set(value, forKey: Keys.bidFloorOverride(type))
    }

    func videoExtEnabled(for type: DebugAdType) -> Bool {
        runtimeVideoExtEnabledMap[type] ?? false
    }

    func setVideoExtEnabled(_ value: Bool, for type: DebugAdType) {
        runtimeVideoExtEnabledMap[type] = value
    }

    func videoExtJson(for type: DebugAdType) -> String {
        let raw = UserDefaults.standard.string(forKey: Keys.videoExtJson(type)) ?? defaultVideoExtJson(for: type)
        let normalized = normalizeVideoExtJson(raw, for: type)
        if normalized != raw {
            UserDefaults.standard.set(normalized, forKey: Keys.videoExtJson(type))
        }
        return normalized
    }

    func setVideoExtJson(_ value: String, for type: DebugAdType) {
        let normalized = normalizeVideoExtJson(value, for: type)
        UserDefaults.standard.set(normalized, forKey: Keys.videoExtJson(type))
    }

    func save(bidFloorOverride: String, videoExtEnabled: Bool, videoExtJson: String) {
        save(bidFloorOverride: bidFloorOverride, videoExtEnabled: videoExtEnabled, videoExtJson: videoExtJson, for: selectedAdType)
    }

    func save(bidFloorOverride: String, videoExtEnabled: Bool, videoExtJson: String, for type: DebugAdType) {
        setBidFloorOverride(bidFloorOverride, for: type)
        setVideoExtEnabled(videoExtEnabled, for: type)
        setVideoExtJson(videoExtJson, for: type)
    }

    func reset() {
        reset(for: selectedAdType)
    }

    func reset(for type: DebugAdType) {
        setBidFloorOverride("", for: type)
        setVideoExtEnabled(false, for: type)
        setVideoExtJson(defaultVideoExtJson(for: type), for: type)
        applyVideoExtDebugConfig(for: type)
    }

    /// 保留原始测试代码默认值，当调试页输入覆盖值时再替换
    func resolveBidFloor(defaultValue: String) -> String {
        resolveBidFloor(defaultValue: defaultValue, for: selectedAdType)
    }

    func resolveBidFloor(defaultValue: String, for type: DebugAdType) -> String {
        let value = bidFloorOverride(for: type).trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? defaultValue : value
    }

    func userExtForDefaultBidFloor(_ defaultValue: String) -> [String: String] {
        userExtForDefaultBidFloor(defaultValue, for: selectedAdType)
    }

    func userExtForDefaultBidFloor(_ defaultValue: String, for type: DebugAdType) -> [String: String] {
        return ["bid_floor": resolveBidFloor(defaultValue: defaultValue, for: type)]
    }

    func applyVideoExtDebugConfig() {
        applyVideoExtDebugConfig(for: selectedAdType)
    }

    func applyVideoExtDebugConfig(for type: DebugAdType) {
        guard videoExtEnabled(for: type) else {
            AlxVideoExtDebugConfig.reset()
            return
        }

        // 仅 Debug 构建允许本地 video_ext 覆盖，避免影响正式 SDK 行为。
        #if DEBUG
        guard let dict = parsedVideoExtDictionary(for: type) else {
            AlxVideoExtDebugConfig.reset()
            return
        }
        AlxVideoExtDebugConfig.rawValue = dict
        AlxVideoExtDebugConfig.isEnabled = true
        #else
        AlxVideoExtDebugConfig.reset()
        #endif
    }

    func parsedVideoExtDictionary() -> [String: Any]? {
        parsedVideoExtDictionary(for: selectedAdType)
    }

    func parsedVideoExtDictionary(for type: DebugAdType) -> [String: Any]? {
        let raw = videoExtJson(for: type).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty, let data = raw.data(using: .utf8) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }

    private func defaultVideoExtJson(for type: DebugAdType) -> String {
        supportsRewardConfig(for: type) ? Self.defaultRewardVideoExtJson : Self.defaultNonRewardVideoExtJson
    }

    private func supportsRewardConfig(for type: DebugAdType) -> Bool {
        type == .rewardVideo
    }

    /// 非激励类型自动剔除 reward 字段，避免出现“真实链路不支持但调试 JSON 有该段”的误导。
    private func normalizeVideoExtJson(_ raw: String, for type: DebugAdType) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return defaultVideoExtJson(for: type)
        }
        guard !supportsRewardConfig(for: type) else {
            return raw
        }
        guard let data = trimmed.data(using: .utf8),
              var json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            return raw
        }
        guard json["reward"] != nil else {
            return raw
        }
        json.removeValue(forKey: "reward")
        guard let normalizedData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
              let normalized = String(data: normalizedData, encoding: .utf8) else {
            return raw
        }
        return normalized
    }
}
