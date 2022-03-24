//
//  ViewController.swift
//  Combine Tutorial
//
//  Created by Abanoub Emil on 24/02/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    
    @IBOutlet weak var labelAssignSubscriber: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    var buttonTapCount = 0
    @Published
    var labelAssignSubscriberValueString: String? = "You dont tap the button"
    var str: String? = "" {
        didSet {
            self.labelAssignSubscriber.text = str
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
        useSinkExample()
        publishAndSubscribeExampleWithAssign()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        self.buttonTapCount = buttonTapCount + 1
        self.labelAssignSubscriberValueString = "You have tapped the button \(self.buttonTapCount) time"
    }
    
    @IBAction func viewModelAction(_ sender: Any) {
        guard var viewModel = self.viewModel else { return }
        viewModel.didSubscribeLabel()
        viewModel.changeVcText?.receive(on: DispatchQueue.main)
            .assign(to: \.text, on: labelAssignSubscriber)
            .store(in: &viewModel.cancellables)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel?.changeStr()
        }
    }
    
    @IBAction func useSubject(_ sender: Any) {
        viewModel?.subjectExampleWithSendFunctionAndPublisher()
    }
    
    @IBAction func testScanExample(_ sender: Any) {
        viewModel?.scanExample()
    }
    
    @IBAction func test1(_ sender: UIButton) {
        viewModel?.reduceExample()
    }
    
    @IBAction func test2(_ sender: UIButton) {
        viewModel?.combineLatestExample()
    }
    
    @IBAction func test3(_ sender: UIButton) {
        viewModel?.mergeExample()
    }
    
    @IBAction func test4(_ sender: UIButton) {
        viewModel?.zipExample()
    }
    
    @IBAction func test5(_ sender: UIButton) {
        guard var viewModel = self.viewModel else { return }
        viewModel.publishPostToVc()
        viewModel.networkingWithCombine()
        viewModel.postPublisher?.sink(receiveValue: { [weak self] repo in
            self?.labelAssignSubscriber.text = repo?.name ?? ""
        }).store(in: &viewModel.cancellables)

    }
    
    func useSinkExample() {
        viewModel?.useSinkExample()
    }
    
    private func publishAndSubscribeExampleWithAssign() {
        guard var viewModel = self.viewModel else { return }
        $labelAssignSubscriberValueString.receive(on: DispatchQueue.main)
            .assign(to: \.text, on: labelAssignSubscriber)
            .store(in: &viewModel.cancellables)
    }
}

class MyPublisher: Publisher {
    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, String == S.Input {
        print("MyPublisher")
    }
    
    typealias Output = String
    
    typealias Failure = Error
    
    
}

// MARK: Subject

extension ViewController {
    
}
