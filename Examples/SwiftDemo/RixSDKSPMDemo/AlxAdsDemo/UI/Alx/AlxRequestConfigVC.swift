//
//  AlxRequestConfigVC.swift
//  AlxAdsDemo
//

import UIKit

final class AlxRequestConfigVC: BaseUIViewController, UITextViewDelegate {
    private let bidFloorField = UITextField()
    private let videoExtSwitch = UISwitch()
    private let videoExtTextView = UITextView()
    private let previewLabel = UILabel()
    private var videoExtTextViewHeightConstraint: NSLayoutConstraint?
    private var lastMeasuredTextViewWidth: CGFloat = 0
    private let minVideoExtTextViewHeight: CGFloat = 260
    private let adTypeSegmentedControl: UISegmentedControl = {
        let items = AlxRequestParamStore.DebugAdType.allCases.map { $0.displayName }
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "请求参数调试"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        reloadForm()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateVideoExtTextViewHeightIfNeeded()
    }

    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        scrollView.addSubview(stack)

        let adTypeCard = segmentedCard(title: "调试目标广告", tip: "切换后可分别配置激励视频/插屏视频/插屏Banner")
        stack.addArrangedSubview(adTypeCard)

        let floorCard = inputCard(
            title: "user_ext.bid_floor",
            tip: "不填则使用原代码默认值",
            textField: bidFloorField
        )
        stack.addArrangedSubview(floorCard)

        let enableRow = row(title: "启用 video_ext 调试覆盖", rightView: videoExtSwitch)
        stack.addArrangedSubview(enableRow)

        let jsonCard = multiLineCard(
            title: "video_ext JSON",
            tip: "仅在开关开启时生效，可编辑 skip/mute/close/usectrl/closebtn/reward/track"
        )
        stack.addArrangedSubview(jsonCard)

        let buttonRow = UIStackView()
        buttonRow.axis = .horizontal
        buttonRow.spacing = 10
        buttonRow.distribution = .fillEqually
        buttonRow.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(buttonRow)

        let saveButton = createButton(title: "保存并生效", action: #selector(saveTapped))
        let resetButton = createButton(title: "恢复默认", action: #selector(resetTapped))
        saveButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        buttonRow.addArrangedSubview(saveButton)
        buttonRow.addArrangedSubview(resetButton)

        let previewCard = UIView()
        previewCard.backgroundColor = .white
        previewCard.layer.cornerRadius = 12
        previewCard.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(previewCard)

        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        previewLabel.numberOfLines = 0
        previewLabel.textColor = UIColor(red: 0.2, green: 0.22, blue: 0.26, alpha: 1.0)
        previewCard.addSubview(previewLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),

            previewLabel.topAnchor.constraint(equalTo: previewCard.topAnchor, constant: 12),
            previewLabel.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 12),
            previewLabel.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -12),
            previewLabel.bottomAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: -12)
        ])

        adTypeSegmentedControl.addTarget(self, action: #selector(adTypeChanged), for: .valueChanged)
        bidFloorField.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
        videoExtSwitch.addTarget(self, action: #selector(inputChanged), for: .valueChanged)
        videoExtTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func row(title: String, rightView: UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 56).isActive = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        card.addSubview(label)

        rightView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(rightView)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            rightView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            rightView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14)
        ])
        return card
    }

    private func inputCard(title: String, tip: String, textField: UITextField) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .black

        let tipLabel = UILabel()
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.text = tip
        tipLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tipLabel.textColor = UIColor.gray

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none

        card.addSubview(titleLabel)
        card.addSubview(tipLabel)
        card.addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            tipLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            tipLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tipLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            textField.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 36),
            textField.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])

        return card
    }

    private func multiLineCard(title: String, tip: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .black

        let tipLabel = UILabel()
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.text = tip
        tipLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tipLabel.numberOfLines = 0
        tipLabel.textColor = UIColor.gray

        videoExtTextView.translatesAutoresizingMaskIntoConstraints = false
        videoExtTextView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        videoExtTextView.layer.borderWidth = 1
        videoExtTextView.layer.borderColor = UIColor.systemGray4.cgColor
        videoExtTextView.layer.cornerRadius = 8
        videoExtTextView.autocorrectionType = .no
        videoExtTextView.autocapitalizationType = .none
        videoExtTextView.isScrollEnabled = false

        card.addSubview(titleLabel)
        card.addSubview(tipLabel)
        card.addSubview(videoExtTextView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            tipLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            tipLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tipLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            videoExtTextView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 8),
            videoExtTextView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            videoExtTextView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            videoExtTextView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        videoExtTextViewHeightConstraint = videoExtTextView.heightAnchor.constraint(equalToConstant: minVideoExtTextViewHeight)
        videoExtTextViewHeightConstraint?.isActive = true

        return card
    }

    private func segmentedCard(title: String, tip: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .black

        let tipLabel = UILabel()
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.text = tip
        tipLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tipLabel.textColor = UIColor.gray
        tipLabel.numberOfLines = 0

        card.addSubview(titleLabel)
        card.addSubview(tipLabel)
        card.addSubview(adTypeSegmentedControl)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            tipLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            tipLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tipLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            adTypeSegmentedControl.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 10),
            adTypeSegmentedControl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            adTypeSegmentedControl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            adTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            adTypeSegmentedControl.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        return card
    }

    private var selectedAdType: AlxRequestParamStore.DebugAdType {
        let index = adTypeSegmentedControl.selectedSegmentIndex
        if AlxRequestParamStore.DebugAdType.allCases.indices.contains(index) {
            return AlxRequestParamStore.DebugAdType.allCases[index]
        }
        return .rewardVideo
    }

    private func reloadForm() {
        let store = AlxRequestParamStore.shared
        if let selectedIndex = AlxRequestParamStore.DebugAdType.allCases.firstIndex(of: store.selectedAdType) {
            adTypeSegmentedControl.selectedSegmentIndex = selectedIndex
        } else {
            adTypeSegmentedControl.selectedSegmentIndex = 0
        }
        reloadFieldsForSelectedAdType()
    }

    private func reloadFieldsForSelectedAdType() {
        let store = AlxRequestParamStore.shared
        let target = selectedAdType
        bidFloorField.text = store.bidFloorOverride(for: target)
        videoExtSwitch.isOn = store.videoExtEnabled(for: target)
        videoExtTextView.text = store.videoExtJson(for: target)
        updateVideoExtTextViewHeightIfNeeded(force: true)
        refreshPreview()
    }

    private func updateVideoExtTextViewHeightIfNeeded(force: Bool = false) {
        let width = videoExtTextView.bounds.width
        guard width > 0 else { return }
        if !force, abs(width - lastMeasuredTextViewWidth) < 0.5 {
            return
        }
        lastMeasuredTextViewWidth = width
        let fittingSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let targetHeight = max(minVideoExtTextViewHeight, ceil(videoExtTextView.sizeThatFits(fittingSize).height))
        if abs((videoExtTextViewHeightConstraint?.constant ?? 0) - targetHeight) > 0.5 {
            videoExtTextViewHeightConstraint?.constant = targetHeight
        }
    }

    private func refreshPreview() {
        let target = selectedAdType
        let floorInput = (bidFloorField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let floor = floorInput.isEmpty ? "1.68 (原默认值)" : floorInput
        let videoState = videoExtSwitch.isOn ? "开启" : "关闭"
        let jsonText = videoExtTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let jsonValid: String
        if !videoExtSwitch.isOn {
            jsonValid = "-"
        } else if let data = jsonText.data(using: .utf8),
                  (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) != nil {
            jsonValid = "有效"
        } else {
            jsonValid = "无效"
        }
        previewLabel.text = """
                            当前生效配置：
调试目标 = \(target.displayName)
user_ext.bid_floor = \(floor)
video_ext 调试覆盖 = \(videoState)
video_ext JSON 校验 = \(jsonValid)
"""
    }

    @objc private func adTypeChanged() {
        AlxRequestParamStore.shared.selectedAdType = selectedAdType
        reloadFieldsForSelectedAdType()
    }

    @objc private func inputChanged() {
        refreshPreview()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func textViewDidChange(_ textView: UITextView) {
        updateVideoExtTextViewHeightIfNeeded(force: true)
        refreshPreview()
    }

    @objc private func saveTapped() {
        if videoExtSwitch.isOn {
            let jsonText = videoExtTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard let data = jsonText.data(using: .utf8),
                  (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) != nil else {
                showAlert(msg: "video_ext JSON 格式无效，请修正后再保存")
                return
            }
        }
        let target = selectedAdType
        AlxRequestParamStore.shared.save(
            bidFloorOverride: bidFloorField.text ?? "",
            videoExtEnabled: videoExtSwitch.isOn,
            videoExtJson: videoExtTextView.text ?? "",
            for: target
        )
        AlxRequestParamStore.shared.selectedAdType = target
        AlxRequestParamStore.shared.applyVideoExtDebugConfig(for: target)
        refreshPreview()
        showAlert(msg: "已保存（\(target.displayName)），后续该类型 loadAd 立即生效")
    }

    @objc private func resetTapped() {
        let target = selectedAdType
        AlxRequestParamStore.shared.reset(for: target)
        reloadFieldsForSelectedAdType()
        showAlert(msg: "已恢复默认值（\(target.displayName)）")
    }

    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "请求参数调试", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
