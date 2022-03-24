//
//  MainViewModel.swift
//  Combine Tutorial
//
//  Created by Abanoub Emil on 24/02/2022.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    var cancellables: Set<AnyCancellable> { get set }
    var changeVcText: AnyPublisher<String?, Never>? { get }
    var postPublisher: AnyPublisher<Repository?, Never>? { get }
    func useSinkExample()
    func didSubscribeLabel()
    func publishPostToVc()
    func changeStr()
    func subjectExampleWithSendFunctionAndPublisher()
    func scanExample()
    func reduceExample()
    func combineLatestExample()
    func mergeExample()
    func zipExample()
    func networkingWithCombine()
}

class MainViewModel: MainViewModelProtocol {
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
    let url1 = URL(string: "https://api.github.com/repos/johnsundell/publish")!
    var cancellables = Set<AnyCancellable>()
    var changeVcText: AnyPublisher<String?, Never>?
    @Published
    var str: String? = ""
    var postPublisher: AnyPublisher<Repository?, Never>?
    @Published
    var repo: Repository?
    
    func didSubscribeLabel() {
        changeVcText = $str.eraseToAnyPublisher()
    }
    
    func publishPostToVc() {
        postPublisher = $repo.eraseToAnyPublisher()
    }
    
    func changeStr() {
        str = "Set Label from the View Model"
    }
    
    func useSinkExample() {
        let _ = Just("Abanoub Ghaly")
            .map { (value) -> String in
                return value.uppercased()
            }
            .sink { receivedValue in
                print(receivedValue)
            }
    }
    
    func subjectExampleWithSendFunctionAndPublisher() {
        var cancellables = Set<AnyCancellable>()
        
        let subject = CurrentValueSubject<String, Never>("CurrentValueSubject")
        subject.send("Sending Zero object")
        
        let publisher = subject.eraseToAnyPublisher()
        
        let _ = publisher.sink { value in
            print(value.lowercased())
        }.store(in: &cancellables)
        
        subject.send("Sending 1st object")
        subject.send("Sending 2nd object")
        
        let _ = publisher.sink { value in
            print(value.uppercased())
        }.store(in: &cancellables)
        // Below send function is always used to send values to the subscriber..
        
        subject.send("Sending Third object")
        subject.send("Sending Fourth object")
        
        //subscribe a subject to a publisher
        //        let _ = Just("World!").subscribe(subject)
        
        //If above function will be uncommented then below code will not be executed. Because of Just publisher. It only emits an output to each subscriber just once, and then finishes
        
        subject.send("Sending Fifth object")
        let _ = Just("Publishing the Value for subject").subscribe(subject)
        cancellables.forEach { $0.cancel() }
        
    }
    
    func scanExample() {
        let _ = (0...5).publisher
            .scan(0, { $0 + $1 })
            .sink { print ("\($0)", terminator: " ") }
    }
    
    func reduceExample() {
        let _ = (0...5).publisher
            .reduce(0, {preVal, newVal -> Int in
                preVal + newVal
            })
            .sink { print ("\($0)", terminator: " ") }
    }
    
    func combineLatestExample() {
        let usernamePublisher = PassthroughSubject<String, Never>()
        let passwordPublisher = PassthroughSubject<String, Never>()
        let validatedCredentials = Publishers.CombineLatest(usernamePublisher, passwordPublisher)
            .map { (username, password) -> Bool in
                !username.isEmpty && !password.isEmpty && password.count > 12 && Character("\(password.prefix(1))").isUppercase
            }.eraseToAnyPublisher()
        
        
        let firstSubscriber = validatedCredentials.sink { (valid) in
            print("First Subscriber: CombineLatest: Are the credentials valid: \(valid)")}
        let secondSubscriber = validatedCredentials.sink { (valid) in
            print("Second Subscriber: CombineLatest: Are the credentials valid: \(valid)")}
        
        // Nothing will be printed yet as `CombineLatest` requires both publishers to have send at least one value.
        
        usernamePublisher.send("User Name")
        
        passwordPublisher.send("weakpass")
        passwordPublisher.send("verystrongpassword")
        passwordPublisher.send("SuccesPassword")
    }
    
    func mergeExample() {
        let germanCities = PassthroughSubject<String, Never>()
        let italianCities = PassthroughSubject<String, Never>()
        let mergePublisher = Publishers.Merge(germanCities, italianCities).map({ value -> String in
            value
        }).eraseToAnyPublisher()
        
        let mergeSubscriber = mergePublisher.sink { city in
            print("\(city) is a city in europe")}
        
        germanCities.send("Munich")
        italianCities.send("Milano")
        
    }
    
    func zipExample() {
        let usernamePublisher = PassthroughSubject<String, Never>()
        let passwordPublisher = PassthroughSubject<Int, Never>()
        
        let validatedCredentials = Publishers.Zip(usernamePublisher, passwordPublisher).map { $0 }.sink { mergedValue in
            print("\(mergedValue)")
        }
        usernamePublisher.send("Name1")
        passwordPublisher.send(9999)
        passwordPublisher.send(8888)
        usernamePublisher.send("Abanoub")
        
    }
    
    func networkingWithCombine() {
        let publisher = NetworkManager.shared.request(url1, decodeTo: Repository.self)
        publisher.sink(receiveCompletion: { completion in
            // Called once, when the publisher was completed.
            print(completion)
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] value in
            // Can be called multiple times, each time that a
            // new value was emitted by the publisher.
            print(value)
            self?.repo = value
        }).store(in: &cancellables)
    }
    
}
