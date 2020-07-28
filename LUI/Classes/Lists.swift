//
//  Lists.swift
//  LUI
//
//  Created by Elliot Schrock on 7/21/20.
//

import SwiftUI
import LUX
import LithoOperators
import Slippers

public protocol TitleProvider {
    func title() -> String
}

public struct RefreshingList<T, V>: View where T: Decodable & Identifiable, V: View {
    @ObservedObject var modelProvider: ModelProvider<[T]>
    @ObservedObject var refresher: LUXCallRefresher
    var rowCreator: (T) -> V
    public var body: some View {
        List(modelProvider.model ?? [T](), rowContent: rowCreator)
            .pullToRefresh(action: refresher.refresh, isShowing: $refresher.isFetching)
    }
    
    public init(modelProvider: ModelProvider<[T]>, _ refresher: LUXCallRefresher, rowCreator: @escaping (T) -> V) {
        self.modelProvider = modelProvider
        self.refresher = refresher
        self.rowCreator = rowCreator
    }
}

public struct PageableList<T, U>: View where T: Decodable & Identifiable, U: View {
    @ObservedObject var pageManager: LUXPageCallModelsManager<T>
    var rowCreator: (T) -> U
    public var body: some View {
        refreshableList()
            .onAppear(perform: pageManager.refresh)
    }
    
    public init(_ pageManager: LUXPageCallModelsManager<T>, rowCreator: @escaping (T) -> U) {
        self.pageManager = pageManager
        self.rowCreator = rowCreator
    }
    
    func refreshableList() -> some View {
        List(pageManager.models, rowContent: pagingTrackerRow)
            .pullToRefresh(action: pageManager.refresh, isShowing: $pageManager.isFetching)
    }
    
    func pagingTrackerRow(_ model: T) -> some View {
        return rowCreator(model).onAppear(perform: voidCurry(model, pageManager.didAppearFunction()))
    }
}

public struct TitledPageableList<T, U, V>: View where T: Decodable & Identifiable,
                                        U: View,
                                        V: ObservableObject & TitleProvider {
    @ObservedObject var viewModel: V
    @ObservedObject var pageManager: LUXPageCallModelsManager<T>
    var rowCreator: (T) -> U
    public var body: some View {
        NavigationView {
            refreshableList().navigationBarTitle(viewModel.title())
        }.onAppear(perform: pageManager.refresh)
    }
    
    public init(viewModel: V, _ pageManager: LUXPageCallModelsManager<T>, rowCreator: @escaping (T) -> U) {
        self.viewModel = viewModel
        self.pageManager = pageManager
        self.rowCreator = rowCreator
    }
    
    func refreshableList() -> some View {
        List(self.pageManager.models, rowContent: pagingTrackerRow)
            .pullToRefresh(action: pageManager.refresh, isShowing: $pageManager.isFetching)
    }
    
    func pagingTrackerRow(_ model: T) -> some View {
        return rowCreator(model).onAppear(perform: voidCurry(model, pageManager.didAppearFunction()))
    }
}
