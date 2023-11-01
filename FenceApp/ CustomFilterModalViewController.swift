//
//  CustomModalViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/26/23.
//

import UIKit

protocol CustomFilterModalViewControllerDelegate: AnyObject {
    func applyTapped(within: Double, fromDate: Date, toDate: Date)
}

class CustomFilterModalViewController: UIViewController {
    
    let navigationBar = UINavigationBar()
    
    var delegate: CustomFilterModalViewControllerDelegate?
//    lazy var startDate = self.startDatePicker.date
//    lazy var endDate = self.endDatePicker.date

    lazy var currentRangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = String(Int(rangeSlider.value)) + "km"
        return label
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "거리"
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var rangeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        slider.minimumValue = 1
        slider.maximumValue = 500
        slider.value = 250
        slider.thumbTintColor = UIColor(hexCode: "5DDFDE")
        slider.minimumTrackTintColor = UIColor(hexCode: "5DDFDE")
        slider.maximumTrackTintColor = .darkGray
        return slider
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "from:"
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var startDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        let currnetDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        datePicker.date = currnetDayAgo
        datePicker.maximumDate = currnetDayAgo
        datePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: UIControl.Event.valueChanged)
        return datePicker
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "to:"
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: UIControl.Event.valueChanged)
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSelf()
        configureUI()
        configureNavigationBarItem()
    }
    
    func setSelf() {
        self.view.backgroundColor = .white
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    func configureNavigationBarItem() {
        navigationBar.items = [UINavigationItem()]
        navigationBar.items?[0].setRightBarButton(UIBarButtonItem(customView: applyButton), animated: true)
    }
}

// MARK: - Actions
extension CustomFilterModalViewController {
    @objc func applyButtonTapped() {
        delegate?.applyTapped(within: Double(rangeSlider.value), fromDate: startDatePicker.date, toDate: endDatePicker.date)
        dismiss(animated: true)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        currentRangeLabel.text = String(Int(value)) + "km"
    }
    
    @objc func startDatePickerValueChanged(_ sender: UIDatePicker) {
        let value = sender.date
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: value)
    }
    
    @objc func endDatePickerValueChanged(_ sender: UIDatePicker) {
        let value = sender.date
        startDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: value)
    }
}

private extension CustomFilterModalViewController {
    func configureUI() {
        configureNavigationBar()
        configureRangeLabel()
        configureCurrentRangeLabel()
        configureRangeSlider()
        configureStartDateLabel()
        configureStartDatePicker()
        configureEndDateLabel()
        configureEndDatePicker()
    }
    
    func configureNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    
    
    func configureRangeLabel() {
        view.addSubview(rangeLabel)
        
        rangeLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    func configureCurrentRangeLabel() {
        view.addSubview(currentRangeLabel)
        
        currentRangeLabel.snp.makeConstraints {
            $0.centerY.equalTo(rangeLabel)
            $0.leading.equalTo(rangeLabel.snp.trailing).offset(5)
        }
    }
    
    func configureRangeSlider() {
        view.addSubview(rangeSlider)
        
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(rangeLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureStartDateLabel() {
        view.addSubview(startDateLabel)
        
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(rangeSlider.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    func configureStartDatePicker() {
        view.addSubview(startDatePicker)
        
        startDatePicker.snp.makeConstraints {
            $0.centerY.equalTo(startDateLabel)
            $0.leading.equalTo(startDateLabel)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureEndDateLabel() {
        view.addSubview(endDateLabel)
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    func configureEndDatePicker() {
        view.addSubview(endDatePicker)
        
        endDatePicker.snp.makeConstraints {
            $0.centerY.equalTo(endDateLabel)
            $0.leading.equalTo(endDateLabel)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
