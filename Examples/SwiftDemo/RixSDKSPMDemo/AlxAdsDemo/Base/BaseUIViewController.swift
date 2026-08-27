//
//  BaseUIViewController.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

/// AlxAds Demo 各广告测试页的公共基类。
///
/// 职责：
/// - 提供统一的 Demo 按钮 / 标签工厂方法
/// - 提供可滚动布局安装方法（解决横屏控件挤压问题）
/// - 提供 Banner / 日志类页面的横竖屏布局参数
///
/// 使用方式：各 `Alx*VC` 继承本类，在 `setupUI()` 中调用对应工具方法即可。
public class BaseUIViewController: UIViewController {
    // === AI MODIFIED BEGIN | gpt-5.3-codex | 2026-07-02 | modified | YangXk ===
    private weak var transientTipView: UIView?
    // === AI MODIFIED END ===

    // MARK: - UI 工厂

    /// 创建 Demo 统一样式的操作按钮。
    ///
    /// - 视觉：白底、浅蓝描边（`#9CC4FF`）、圆角 8pt
    /// - 交互：按下缩放 + 背景变色，松手弹簧回弹（见 `handleButtonTouchDown/Up`）
    /// - 布局：已设置 `translatesAutoresizingMaskIntoConstraints = false`，可直接用 Auto Layout
    ///
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 点击回调（绑定到 `touchUpInside`）
    /// - Returns: 配置完成的 `UIButton`
    public func createButton(title: String, action: Selector) -> UIButton {
        let tintColor = UIColor.hex("#9CC4FF")
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.5
        button.layer.borderColor = tintColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(tintColor, for: .normal)
        button.backgroundColor = .white
        button.accessibilityNavigationStyle = .automatic
        // 按下 / 拖入：触发按压动画
        button.addTarget(self, action: #selector(handleButtonTouchDown(_:)), for: [.touchDown, .touchDragEnter])
        // 抬起 / 取消 / 拖出：恢复默认样式
        button.addTarget(self, action: #selector(handleButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        // 业务点击事件
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    /// 按钮按下时的视觉反馈：轻微缩小、降低透明度、切换浅蓝背景。
    @objc private func handleButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.14) {
            sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            sender.alpha = 0.86
            sender.backgroundColor = UIColor.hex("#EAF1FF")
        }
    }

    /// 按钮松开时的视觉反馈：弹簧动画恢复原始大小与样式。
    @objc private func handleButtonTouchUp(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.18,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.3
        ) {
            sender.transform = .identity
            sender.alpha = 1.0
            sender.backgroundColor = .white
        }
    }

    /// 创建 Demo 通用标签。
    ///
    /// 默认居中、可多行显示；已关闭 autoresizing，可直接约束布局。
    ///
    /// - Parameters:
    ///   - fontSize: 字号，默认 17
    ///   - font: 自定义字体；传 `nil` 时使用系统字体
    ///   - textColor: 文字颜色
    ///   - backgroundColor: 背景色
    ///   - cornerRadius: 圆角；大于 0 时自动开启 `masksToBounds`
    ///   - textAlignment: 对齐方式
    public func createLabel(
        fontSize: CGFloat = 17,
        font: UIFont? = nil,
        textColor: UIColor = .black,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        textAlignment: NSTextAlignment = .center
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font ?? UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = cornerRadius > 0
        label.textAlignment = textAlignment
        label.numberOfLines = .zero
        return label
    }

    /// 清空容器视图内的所有子视图。
    ///
    /// 常用于 Banner 广告容器切换展示 / 移除广告时，避免旧视图残留。
    ///
    /// - Parameter constainerView: 需要清空的容器（命名保留历史拼写）
    public func clearSubView(_ constainerView: UIView) {
        let views = constainerView.subviews
        for view in views {
            view.removeFromSuperview()
        }
    }

    // === AI MODIFIED BEGIN | gpt-5.3-codex | 2026-07-02 | modified | YangXk ===
    public func showAutoDismissTip(_ message: String, duration: TimeInterval = 1.4) {
        guard !message.isEmpty else { return }
        let safeDuration = max(0.8, duration)
        DispatchQueue.main.async {
            self.transientTipView?.removeFromSuperview()

            let tipContainer = UIView()
            tipContainer.translatesAutoresizingMaskIntoConstraints = false
            tipContainer.backgroundColor = UIColor.black.withAlphaComponent(0.78)
            tipContainer.layer.cornerRadius = 10
            tipContainer.layer.masksToBounds = true
            tipContainer.alpha = 0

            let tipLabel = UILabel()
            tipLabel.translatesAutoresizingMaskIntoConstraints = false
            tipLabel.text = message
            tipLabel.textAlignment = .center
            tipLabel.numberOfLines = 0
            tipLabel.font = .systemFont(ofSize: 13, weight: .medium)
            tipLabel.textColor = .white

            tipContainer.addSubview(tipLabel)
            self.view.addSubview(tipContainer)
            self.transientTipView = tipContainer
            NSLayoutConstraint.activate([
                tipContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                tipContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                tipContainer.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
                tipContainer.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20),

                tipLabel.topAnchor.constraint(equalTo: tipContainer.topAnchor, constant: 8),
                tipLabel.bottomAnchor.constraint(equalTo: tipContainer.bottomAnchor, constant: -8),
                tipLabel.leadingAnchor.constraint(equalTo: tipContainer.leadingAnchor, constant: 12),
                tipLabel.trailingAnchor.constraint(equalTo: tipContainer.trailingAnchor, constant: -12)
            ])

            UIView.animate(withDuration: 0.18, animations: {
                tipContainer.alpha = 1
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + safeDuration) {
                    UIView.animate(withDuration: 0.2, animations: {
                        tipContainer.alpha = 0
                    }, completion: { _ in
                        tipContainer.removeFromSuperview()
                    })
                }
            })
        }
    }
    // === AI MODIFIED END ===

    // MARK: - 可滚动布局

    /// 为 Demo 页安装「ScrollView + 垂直 StackView」的可滚动内容区。
    ///
    /// 背景：横屏时 safe area 高度变小，固定布局会导致日志区与按钮重叠；
    /// 将控件放入此方法返回的 `contentStack` 后，内容超出屏幕时可垂直滚动。
    ///
    /// 约束说明：
    /// - `scrollView` 四边贴 `containerView` 的 safe area
    /// - `contentStack` 的 leading/trailing 相对 `frameLayoutGuide`（决定可视宽度）
    /// - `contentStack` 的 top/bottom 相对 `contentLayoutGuide`（决定可滚动内容高度）
    ///
    /// 返回值中的 `topConstraint` / `bottomConstraint` 需保留引用，
    /// 以便横竖屏切换时动态调整上下边距（见 `DemoBannerLayoutMetrics` / `DemoAdLogLayoutMetrics`）。
    ///
    /// - Parameters:
    ///   - containerView: 通常为 `view`
    ///   - spacing: StackView 子视图间距
    ///   - topInset: 内容区顶部内边距
    ///   - horizontalInset: 内容区左右内边距
    ///   - bottomInset: 内容区底部内边距
    public func installScrollableContentStack(
        in containerView: UIView,
        spacing: CGFloat = 12,
        topInset: CGFloat = 12,
        horizontalInset: CGFloat = 16,
        bottomInset: CGFloat = 16
    ) -> (
        scrollView: UIScrollView,
        contentStack: UIStackView,
        topConstraint: NSLayoutConstraint,
        bottomConstraint: NSLayoutConstraint
    ) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        containerView.addSubview(scrollView)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = spacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        let topConstraint = contentStack.topAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.topAnchor,
            constant: topInset
        )
        let bottomConstraint = contentStack.bottomAnchor.constraint(
            equalTo: scrollView.contentLayoutGuide.bottomAnchor,
            constant: -bottomInset
        )

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),

            topConstraint,
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: horizontalInset),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -horizontalInset),
            bottomConstraint,
        ])

        return (scrollView, contentStack, topConstraint, bottomConstraint)
    }

    // MARK: - 横竖屏布局参数

    /// Banner 类 Demo 页（`AlxBannerVC` / `AlxBannerXibVC`）的横竖屏布局参数。
    ///
    /// 横屏判断：`size.width > size.height`
    ///
    /// 使用方式：
    /// 1. 在 `setupUI()` 中保存日志高度、top/bottom 约束等引用
    /// 2. 在 `viewDidLayoutSubviews` 中检测方向变化，读取 `current(for:)` 并更新约束
    public struct DemoBannerLayoutMetrics {
        /// 主 StackView 子视图间距
        public let contentSpacing: CGFloat
        /// ScrollView 内容区顶部边距
        public let topInset: CGFloat
        /// ScrollView 内容区底部边距
        public let bottomInset: CGFloat
        /// 日志卡片高度
        public let logCardHeight: CGFloat
        /// Banner 广告展示区域高度
        public let adAreaHeight: CGFloat
        /// ID 选择行与按钮区之间的间距
        public let controlsSpacing: CGFloat
        /// 按钮网格行间距
        public let buttonGridSpacing: CGFloat
        /// 按钮网格列间距（同一行两个按钮之间）
        public let buttonRowSpacing: CGFloat

        /// 根据当前尺寸返回 Banner 页布局参数。
        ///
        /// 横屏采用更紧凑的间距与更低的日志区 / 广告区高度，避免控件挤压。
        public static func current(for size: CGSize) -> DemoBannerLayoutMetrics {
            let isLandscape = size.width > size.height
            if isLandscape {
                return DemoBannerLayoutMetrics(
                    contentSpacing: 8,
                    topInset: 8,
                    bottomInset: 8,
                    logCardHeight: 120,
                    adAreaHeight: 60,
                    controlsSpacing: 8,
                    buttonGridSpacing: 8,
                    buttonRowSpacing: 10
                )
            }
            return DemoBannerLayoutMetrics(
                contentSpacing: 16,
                topInset: 12,
                bottomInset: 16,
                logCardHeight: 220,
                adAreaHeight: 80,
                controlsSpacing: 12,
                buttonGridSpacing: 12,
                buttonRowSpacing: 16
            )
        }
    }

    /// 带日志输出框的 Demo 页（`AlxRewardVideoVC` / `AlxInterstitialVC`）横竖屏布局参数。
    ///
    /// 与 `DemoBannerLayoutMetrics` 的区别：不包含广告展示区与按钮网格参数，
    /// 仅覆盖日志卡片 + 操作按钮区的常用间距。
    public struct DemoAdLogLayoutMetrics {
        /// 主 StackView 子视图间距（日志卡片与按钮区之间）
        public let contentSpacing: CGFloat
        public let topInset: CGFloat
        public let bottomInset: CGFloat
        /// 日志打印框（logCard）高度
        public let logCardHeight: CGFloat
        /// ID 选择行与按钮 Stack 之间的间距
        public let controlsSpacing: CGFloat

        /// 根据当前尺寸返回日志类 Demo 页布局参数。
        ///
        /// 横屏时日志框高度默认 120pt（竖屏 220pt），可在本方法内统一调整。
        public static func current(for size: CGSize) -> DemoAdLogLayoutMetrics {
            let isLandscape = size.width > size.height
            if isLandscape {
                return DemoAdLogLayoutMetrics(
                    contentSpacing: 8,
                    topInset: 8,
                    bottomInset: 8,
                    logCardHeight: 120,
                    controlsSpacing: 8
                )
            }
            return DemoAdLogLayoutMetrics(
                contentSpacing: 16,
                topInset: 12,
                bottomInset: 16,
                logCardHeight: 220,
                controlsSpacing: 12
            )
        }
    }

    /// 将 `DemoAdLogLayoutMetrics` 应用到已保存的约束与 StackView 上。
    ///
    /// 典型调用时机：`viewDidLayoutSubviews` 中检测到横竖屏切换后。
    ///
    /// 注意：
    /// - `bottomConstraint.constant` 需取负值（约束定义时使用 `-bottomInset`）
    /// - 传入的约束 / StackView 引用应在 `setupUI()` 阶段创建并保存
    public func applyDemoAdLogLayoutMetrics(
        _ metrics: DemoAdLogLayoutMetrics,
        contentStack: UIStackView?,
        topConstraint: NSLayoutConstraint?,
        bottomConstraint: NSLayoutConstraint?,
        logCardHeightConstraint: NSLayoutConstraint?,
        controlsStack: UIStackView?
    ) {
        contentStack?.spacing = metrics.contentSpacing
        topConstraint?.constant = metrics.topInset
        bottomConstraint?.constant = -metrics.bottomInset
        logCardHeightConstraint?.constant = metrics.logCardHeight
        controlsStack?.spacing = metrics.controlsSpacing
    }
}
