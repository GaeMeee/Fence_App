//
//  CustomModalViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/26/23.
//

import UIKit

class CustomModalViewController: UIViewController {
    
    let navigationBar = UINavigationBar()
    
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
        return label
    }()
    
    lazy var rangeSlider: UISlider = {
        let slider = UISlider()
        slider.backgroundColor = .gray
        slider.thumbTintColor = .blue
        slider.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 5.5
        return slider
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "from:"
        return label
    }()
    
    let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "to:"
        return label
    }()
    
    let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        configureUI()
        configureNavigationBarItem()
    }
    
    func configureNavigationBarItem() {
        navigationBar.items = [UINavigationItem()]
        navigationBar.items?[0].setRightBarButton(UIBarButtonItem(customView: applyButton), animated: true)
    }
    
    @objc func applyButtonTapped() {
        print(#function)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        currentRangeLabel.text = String(Int(value)) + "km"
    }
}

private extension CustomModalViewController {
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
            $0.width.height.equalTo(60)
        }
    }
    
    func configureCurrentRangeLabel() {
        view.addSubview(currentRangeLabel)
        
        currentRangeLabel.snp.makeConstraints {
            $0.centerY.equalTo(rangeLabel)
            $0.leading.equalTo(rangeLabel.snp.trailing).offset(5)
            $0.width.height.equalTo(60)
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
            $0.top.equalTo(rangeSlider.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(80)
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
            $0.top.equalTo(startDateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(80)
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