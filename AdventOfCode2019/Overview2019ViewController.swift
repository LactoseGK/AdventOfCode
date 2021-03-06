//
//  ViewController.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Overview2019ViewController: UIViewController {
    private let mainStackView = UIStackView()
    private var subStackViews = [UIStackView]()

    private let verticalSpacing: CGFloat = 4
    private let horizontalSpacing: CGFloat = 16
    
    //Days start at 1, not 0.
    private var calendarDays: [Int: AoCVC.Type] = [1 : Day01VC.self,
                                                   2 : Day02VC.self,
                                                   3 : Day03VC.self,
                                                   4 : Day04VC.self,
                                                   5 : Day05VC.self,
                                                   6 : Day06VC.self,
                                                   7 : Day07VC.self,
                                                   8 : Day08VC.self,
                                                   9 : Day09VC.self,
                                                   10 : Day10VC.self,
                                                   11 : Day11VC.self,
                                                   12 : Day12VC.self,
                                                   13 : Day13VC.self,
                                                   14 : Day14VC.self,
                                                   15 : Day15VC.self,
                                                   16 : Day16VC.self,
                                                   17 : Day17VC.self,
                                                   19 : Day19VC.self,
                                                   20 : Day20VC.self,
                                                   22 : Day22VC.self,
                                                   24 : Day24VC.self
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advent of Code 2019"
        
        self.configureStackViews()
        self.configureButtons()
    }
    
    private func configureStackViews() {
        self.mainStackView.axis = .horizontal
        self.mainStackView.distribution = .fillEqually
        self.mainStackView.alignment = .center
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.spacing = self.horizontalSpacing
        self.view.addSubview(self.mainStackView)
        
        NSLayoutConstraint.activate([self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        for _ in 0..<4 {
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.distribution = .fillEqually
            subStackView.alignment = .center
            subStackView.spacing = self.verticalSpacing
            self.mainStackView.addArrangedSubview(subStackView)
            self.subStackViews.append(subStackView)
        }
    }

    private func makeAdventDayButton(day: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let dayString = String(format: "%02d", day)
        button.setTitle("Day \(dayString)", for: .normal)
        button.tag = day
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.isEnabled = (self.calendarDays[day] != nil)
        return button
    }
    
    private func configureButtons() {
        for i in 0..<24 {
            let day = i + 1
            let stackViewIndex = i % 4
            self.subStackViews[stackViewIndex].addArrangedSubview(self.makeAdventDayButton(day: day))
        }
        
        let sillyButton = self.makeAdventDayButton(day: 25)
        self.view.addSubview(sillyButton)
        NSLayoutConstraint.activate([sillyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     sillyButton.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: self.verticalSpacing)])

        let button = UIButton(type: .system)
        button.setTitle("2018", for: .normal)
        button.addTarget(self, action: #selector(self.tapped2018), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }

    @objc private func tapped2018() {
        let vc = Overview2018ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let vcType = self.calendarDays[sender.tag] else { fatalError("Invalid VC.") }
        let vc = vcType.init()
        vc.modalPresentationStyle = .overFullScreen
        vc.title = String(format: "Day %02d", sender.tag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
