//
//  ModelProvider.swift
//  LUI
//
//  Created by Elliot Schrock on 7/21/20.
//

import SwiftUI
import Combine
import LithoOperators

public class ModelProvider<T>: ObservableObject {
    let modelPublisher: AnyPublisher<T, Never>
    @Published var model: T?
    var cancelBag = Set<AnyCancellable>()
    
    init(_ modelPublisher: AnyPublisher<T, Never>) {
        self.modelPublisher = modelPublisher
        modelPublisher.sink { [unowned self] model in self.model = model }.store(in: &cancelBag)
    }
}

public class TitledModelProvider<T>: ObservableObject, TitleProvider {
    let modelPublisher: AnyPublisher<T, Never>
    @Published var model: T?
    var titleProvider: (T) -> String
    var cancelBag = Set<AnyCancellable>()
    
    init(_ modelPublisher: AnyPublisher<T, Never>, _ titleProvider: @escaping (T) -> String) {
        self.modelPublisher = modelPublisher
        self.titleProvider = titleProvider
        modelPublisher.sink { [unowned self] model in self.model = model }.store(in: &cancelBag)
    }
    
    public func title() -> String {
        return (model ?> titleProvider) ?? "Loading..."
    }
}

public extension AnyPublisher where Failure == Never {
    func observable() -> ModelProvider<Output> {
        return ModelProvider<Output>(self)
    }
    
    func observable(_ titleProvider: @escaping (Output) -> String) -> TitledModelProvider<Output> {
        return TitledModelProvider<Output>(self, titleProvider)
    }
}
