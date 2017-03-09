//
//  ViewController.swift
//  ReactionTimeTest
//
//  Created by Madimo on 2017/3/9.
//  Copyright © 2017年 Madimo. All rights reserved.
//

import UIKit

enum State {
    case initial
    case waitForGreen
    case release
    case tapToKeepGoing
    case tooSoon
}

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var guideView: UIVisualEffectView!

    fileprivate var startDate: Date?
    fileprivate var times = [Int]() {
        didSet {
            let total = times.reduce(0, +)
            let tries = times.count
            let average = total / tries
            averageLabel.text = "Average: \(average)ms Tries: \(tries)"
        }
    }

    fileprivate lazy var effect: UIBlurEffect = UIBlurEffect(style: .dark)
    fileprivate var timer: Timer?

    fileprivate var state: State = .initial {
        didSet {
            switch state {
            case .initial:
                view.backgroundColor = UIColor(hex: "4386CB")
                messageLabel.text = "Put your finger on screen"
                subLabel.text = ""
            case .waitForGreen:
                view.backgroundColor = UIColor(hex: "BF383C")
                messageLabel.text = "Wait for green"
                subLabel.text = ""

                let min: UInt32 = 1
                let max: UInt32 = 4
                let time = Double(min + arc4random_uniform(max - min))


                timer = Timer(timeInterval: time, repeats: false) { [weak self] _ in
                    self?.nextStep()
                }
                RunLoop.main.add(timer!, forMode: .commonModes)
            case .release:
                timer?.invalidate()
                timer = nil

                view.backgroundColor = UIColor(hex: "74D777")
                messageLabel.text = "Release"
                subLabel.text = ""

                startDate = Date()
            case .tapToKeepGoing:
                let endDate = Date()
                let timeInS = endDate.timeIntervalSince(startDate ?? endDate)
                let timeInMs = Int(timeInS * 1000)
                times.append(timeInMs)

                view.backgroundColor = UIColor(hex: "4386CB")
                messageLabel.text = "\(timeInMs)ms"
                subLabel.text = "Tap to keep going"
            case .tooSoon:
                timer?.invalidate()
                timer = nil

                view.backgroundColor = UIColor(hex: "4386CB")
                messageLabel.text = "Too soon!"
                subLabel.text = "Tap to keep going"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        state = .initial
    }

    func nextStep() {
        switch state {
        case .initial:
            state = .waitForGreen
        case .waitForGreen:
            state = .release
        case .release:
            state = .tapToKeepGoing
        case .tapToKeepGoing:
            state = .initial
        case .tooSoon:
            state = .initial
        }
    }

    @IBAction func onShowGuide(_ sender: Any) {
        guideView.effect = nil

        UIView.beginAnimations(nil, context: nil)
        guideView.effect = effect
        guideView.alpha = 1
        UIView.commitAnimations()
    }

    @IBAction func onHideGuide(_ sender: Any) {
        UIView.beginAnimations(nil, context: nil)
        guideView.effect = nil
        guideView.alpha = 0
        UIView.commitAnimations()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard guideView.alpha == 0 else { return }

        if state == .initial {
            nextStep()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard guideView.alpha == 0 else { return }

        if state == .release || state == .tapToKeepGoing || state == .tooSoon {
            nextStep()
        } else if state == .waitForGreen {
            state = .tooSoon
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.all]
    }

}

