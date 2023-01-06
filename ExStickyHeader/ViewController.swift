//
//  ViewController.swift
//  ExStickyHeader
//
//  Created by 김종권 on 2023/01/06.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // MARK: Constants
    private enum Metric {
        // 1. statusBarHeight에 6을 더해야 진정한 statusBarheight가 구해지므로 주의
        static let statusBarHeight = UIApplication.shared.statusBarFrame.height + 6
        static let stickyHeaderHeightMin = 80.0
        static let stickyHeaderHeightMax = 180.0
        static var stickyHeaderHeightMaxWithoutStatusBar: Double {
            stickyHeaderHeightMax - statusBarHeight
        }
    }
    
    // MARK: UIs
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .lightGray
        print(Metric.statusBarHeight)
        // 2. contentInset의 top은 위 헤더뷰만큼 떨어져 있어야 스크롤 맨 위가 헤더뷰에 안가려짐
        // contentInset은 superview기준이 아니고 safearea기준이므로 statusBar의 높이값 제외해야함
        view.contentInset = .init(top: Metric.stickyHeaderHeightMaxWithoutStatusBar, left: 0, bottom: 0, right: 0)
        return view
    }()
    private let beforeHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    private let afterHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.alpha = 0
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.text = "1long text\n\n\n2long text\n\n\n\n\n3long textlong text\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n4textlongtextlong"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        [scrollView, beforeHeaderView, afterHeaderView]
            .forEach(view.addSubview(_:))
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(label)
        
        beforeHeaderView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Metric.stickyHeaderHeightMax)
        }
        afterHeaderView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Metric.stickyHeaderHeightMin)
        }
        scrollView.snp.makeConstraints {
            // 3. scorllView는 superview로 top 고정시켜놓으면 처음 offset이 safearea의 top으로 설정해야 offset 조정에 오차가 없음
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainingTopSpacing = -scrollView.contentOffset.y
        let reaminingTopSpacingRatio = remainingTopSpacing / Metric.stickyHeaderHeightMaxWithoutStatusBar
        
        beforeHeaderView.alpha = reaminingTopSpacingRatio
        afterHeaderView.alpha = 1 - reaminingTopSpacingRatio
    }
}
