//
//  AdConfig.swift
//  AlxDemo
//
//


import Foundation

class AdConfig {
    
    // MARK: - Alx Ad Rix key&id
    // RixEnine 测试 Demo 广告位，包名：com.rixengine.ios
    // "https://rix.svr.rixengine.com/rtb"
    static let Alx_Host = "https://demo.use.svr.rixengine.com/rtb"
    // "39337"
    static let Alx_Sid = "36057"
    // "102797"
    static let Alx_App_Id = "102781"
    // "7c2963c27a39a1febafecde3f4031693"
    static let Alx_Token = "c976563eb2f1f134222d2730294e552d"
    // 原默认广告位，现在被强改为动态广告位｜新的默认广告为是204076
    /**
     iOS:
     reward_dynamic: 204083
     inter_html_dynamic: 204082
     inter_video_dynamic: 204081
     banner_dynamic: 204076
     native_dynamic: 204080
     */
    // "203815" ｜ Runner Ad ID
    static let Alx_Banner_Ad_Id = "204138"
    /// 说明：动态广告位，传底价，返底价｜默认广告位，传底价依旧返回后台设置底价
    static let Alx_Banner_Ad_Ids = [
               Alx_Banner_Ad_Id, // 测试专用ad id
               "203687", // 以前的test id，与github上demo一致
               "204076"
    ]
    // "203818"
    static let Alx_Reward_Video_Ad_Id = "204140"
    static let Alx_Reward_Video_Ad_Ids = [
               Alx_Reward_Video_Ad_Id, // 测试专用ad id
               "203690", // 以前的test id，与github上demo一致
               "204083"
    ]
    // "203817"
    static let Alx_Interstitial_Video_Ad_Id = "204139"
    static let Alx_Interstitial_Video_Ad_Ids = [
               Alx_Interstitial_Video_Ad_Id, // 测试专用ad id
               "203688", // 以前的test id，与github上demo一致
               "204081"
    ]
    static let Alx_Interstitial_Banner_Ad_Id = "203689"
    static let Alx_Interstitial_Banner_Ad_Ids = [
               "204142", // 测试专用ad id
               Alx_Interstitial_Banner_Ad_Id, // 以前的test id，与github上demo一致
               "204082"
    ]
    // "203816"
    static let Alx_Native_Ad_Id = "203691"
    static let Alx_Native_Ad_Ids = [
               "204141", // 测试专用ad id
               Alx_Native_Ad_Id, // 以前的test id，与github上demo一致
               "204080"
    ]
    
    // 配套的测试数据
//    static let Alx_Host = "https://raftingadx.use.svr.rixengine.com/rtb"
//    static let Alx_Sid = "36620"
//    static let Alx_App_Id = "102635"
//    static let Alx_Token = "f33651dde9becb06ac93d3df0519a3a9"
//    static let Alx_Banner_Ad_Id = "202236"
//    static let Alx_Reward_Video_Ad_Id = "203044"
//    static let Alx_Interstitial_Video_Ad_Id = "203688"
//    static let Alx_Interstitial_Banner_Ad_Id = "203689"
//    static let Alx_Native_Ad_Id = "203043"

    
    // MARK: - Max Ad Rix key&id
//    com.rixengine.ios
//    被封的MAX
//    static let Max_App_Key = "95-ffs7CG-uU8Z3exG1oky-tAdQGD1z1kHK365gIQdSIH90WNUv2fTCPFMBhVmH9Fx0o1GhhAX7DQDrnACsVIv"
//    static let Max_Banner_Ad_Id="4ce0e0a3e78b3f5b"
//    static let Max_Reward_Video_Ad_Id="1a05532b62640e63"
//    static let Max_Interstitial_Ad_Id="a4615c11c1624e9f"
//    static let Max_Interstitial_Banner_Ad_Id="9a3e74a2e6c5ca4e"
//    static let Max_Native_Ad_Id="27be3256abd0bad3"
    
    // TODO: other test max key and id
//    com.plugin.test.app
//    static let Max_App_Key = "0Gecf2oOmiV0Ix-in2SZRoopX1MTzc-m9o-B2I54bZx-MaVGLSyV1wRRyBZPRSyyS6Zye05kNeyhQ0n1aT6K-T"
//    static let Max_Banner_Ad_Id="1fa71d68b911e4fc"
//    static let Max_Reward_Video_Ad_Id="f3147e99059a4ca5"
//    static let Max_Interstitial_Ad_Id="517fc74b26c1ddd7"
//    static let Max_Interstitial_Banner_Ad_Id="9a3e74a2e6c5ca4e"
//    static let Max_Native_Ad_Id="140b462882a5fec4"
    
    // TODO: Beijing 产品的max广告id配置
      static let Max_App_Key = "LXrxVNFmMFIZBeGqQIGfBOUQTt13Ng_m5n8rDOi-StwquDUCgSP99c9Mo2ta_ypss-BEDB-OrP1T3r5Hhru8S2"
      static let Max_Banner_Ad_Id="8394f825906daa4c"
      static let Max_Reward_Video_Ad_Id="aea129e165dd54fc"
      static let Max_Interstitial_Ad_Id="26268f22c44236ac"
      static let Max_Interstitial_Banner_Ad_Id="9a3e74a2e6c5ca4e"
      static let Max_Native_Ad_Id="47b7ff074b4c592d"
    
    // MARK: - Admob Ad Rix key&id
//    static let Admob_App_Id="ca-app-pub-2258587227088809~1554295176"
//    static let Admob_Banner_Ad_Id="ca-app-pub-2258587227088809/3393118310"
//    static let Admob_Reward_Video_Ad_Id="ca-app-pub-2258587227088809/3217541268"
//    static let Admob_Interstitial_Ad_Id="ca-app-pub-2258587227088809/1043955443"
//    static let Admob_Native_Ad_Id="ca-app-pub-2258587227088809/1521316212"
    
    static let Admob_App_Id="ca-app-pub-2258587227088809~6648440499"
    static let Admob_Banner_Ad_Id="ca-app-pub-2258587227088809/2939036448"
    static let Admob_Reward_Video_Ad_Id="ca-app-pub-2258587227088809/3315700146"
    static let Admob_Interstitial_Ad_Id="ca-app-pub-2258587227088809/1120781646"
    static let Admob_Native_Ad_Id="ca-app-pub-2258587227088809/4419639079"
    
//    static let TopOn_App_Key="a7a6d21ff1f85aaa0afc0cbbf0382d136"
//    static let TopOn_App_Id="h68a3e1eb59b60"
//    static let TopOn_Banner_Ad_Id="n68a3e434b3558"
//    static let TopOn_Reward_Video_Ad_Id="n68a3e4bb05907"
//    static let TopOn_Interstitial_Ad_Id="n68a3f5643a56d"
//    static let TopOn_Native_Ad_Id="n68a3f57229d3d"
    
    // MARK: - TopOn Ad Rix key&id
    static let TopOn_App_Key="a87d1838eea1661750528505c04dbbf91"
    static let TopOn_App_Id="h691544f1682f5"
    static let TopOn_Banner_Ad_Id="n1gtrgjtiq391k"
    static let TopOn_Reward_Video_Ad_Id="n1gtrgjtiq3f5a"
    static let TopOn_Interstitial_Ad_Id="n1gtrgjtiq3i9r"
    static let TopOn_Native_Ad_Id="n1gtrgjtiq3m0r"
    
    // MARK: - LevelPlay (Unity IronSource) Ad key&id
    // IronSource/LevelPlay App Key
    static let LevelPlay_App_Key = "252802e15"
    // LevelPlay 广告位 ID（LevelPlay 平台 Ad Unit ID）
    static let LevelPlay_Banner_Ad_Id = "2za4ei5bgqb6ay6c"
    static let LevelPlay_Reward_Ad_Id = "2wd8vglu3ux1g383"
    static let LevelPlay_Interstitial_Ad_Id = "q7y7331oytmeozp1"
    // AlxAds SDK 参数（配置在 LevelPlay 平台 custom adapter 参数中）
    static let LevelPlay_Alx_App_Id = "102781"
    static let LevelPlay_Alx_Sid = "36057"
    static let LevelPlay_Alx_Token = "c976563eb2f1f134222d2730294e552d"
    
}

