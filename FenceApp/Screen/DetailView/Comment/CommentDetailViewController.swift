//
//  CommentViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit
import SnapKit

class CommentDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let commentDetailView = CommentDetailView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = commentDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        commentDetailView.rightButtonItem.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        commentDetailView.commentTableView.dataSource = self
        commentDetailView.commentTableView.delegate = self
        
        commentDetailView.commentTableView.estimatedRowHeight = 60
        commentDetailView.commentTableView.rowHeight = UITableView.automaticDimension
        
        commentDetailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commentDetailView.commentTableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}

// MARK: - Actions
extension CommentDetailViewController {
    @objc func rightButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.commentDetailView.myCommentTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        commentDetailView.myCommentTextView.transform = .identity
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension CommentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentDetailView.commentTableView.dequeueReusableCell(withIdentifier: CommentDetailTableViewCell.identifier, for: indexPath)
        
        return cell
    }
}


