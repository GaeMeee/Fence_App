//
//  ReportViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/8/23.
//

import UIKit
import MessageUI

enum PostKind {
    case lost
    case found
    case comment
}

class ReportViewController: UIViewController {
    
    let lost: Lost?
    let comment: Comment?
    let found: Found?
    
    let postKind: PostKind
    
    private let reportingLabel: UILabel = {
        let label = UILabel()
        label.text = "신고하는 이유를 선택하세요."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = "누적 신고 횟수가 3회 이상인 사용자는 게시글 작성이 제한됩니다."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var reportTalbeView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(lost: Lost? = nil, comment: Comment? = nil, found: Found? = nil, postKind: PostKind) {
        self.lost = lost
        self.comment = comment
        self.found = found
        self.postKind = postKind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ReportViewController {
    func configureUI() {
        self.title = "신고하기"
        view.backgroundColor = .white
        
        configureReportingLabel()
        configureReportLabel()
        configureReportTableView()
    }
    
    func configureReportingLabel() {
        view.addSubview(reportingLabel)
        
        reportingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }
    
    func configureReportLabel() {
        view.addSubview(reportLabel)
        
        reportLabel.snp.makeConstraints {
            $0.top.equalTo(reportingLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureReportTableView() {
        view.addSubview(reportTalbeView)
        
        reportTalbeView.snp.makeConstraints {
            $0.top.equalTo(reportLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
    }
}

extension ReportViewController {
    func sendReportEmail(indexPath: IndexPath, postKind: PostKind) {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients(["teamfenceapp@gmail.com"])
            compseVC.setSubject(ReportType.allCases[indexPath.row].rawValue)
            var identifier: String = ""
            var postKindTitle: String = ""
            switch postKind {
            case .lost:
                identifier = lost!.lostIdentifier
                postKindTitle = "잃어버린 반려동물 게시판"
            case .found:
                identifier = found!.foundIdentifier
                postKindTitle = "발견한 반려동물 게시판"
            case .comment:
                identifier = comment!.commentIdentifier
                postKindTitle = "댓글"
            }
            compseVC.setMessageBody("\(postKindTitle)\n식별코드: \(identifier)", isHTML: false)
            	
            self.present(compseVC, animated: true)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
            // 앱스토어로 이동하기(Mail)
            if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        sendMailErrorAlert.addAction(goAppStoreAction)
        sendMailErrorAlert.addAction(cancleAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}

extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(ReportType.allCases[indexPath.row].rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "신고하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.sendReportEmail(indexPath: indexPath, postKind: self!.postKind)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
}

extension ReportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        let finishAlertController = UIAlertController(title: "신고", message: "신고 내용은 24시간 이내 관리자로부터 조취됩니다.", preferredStyle: .alert)
        let cancelAtion = UIAlertAction(title: "확인", style: .cancel)
        finishAlertController.addAction(cancelAtion)
        present(finishAlertController, animated: true)
    }
}
