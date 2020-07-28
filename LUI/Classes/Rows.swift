//
//  Rows.swift
//  LUI
//
//  Created by Elliot Schrock on 7/21/20.
//

import SwiftUI

public protocol Detailed {
    var titleString: String? { get set }
    var detailString: String? { get set}
}

public typealias DetailedView = View & Detailed

public struct DetailRowContent: DetailedView {
    public var titleString: String?
    public var detailString: String?
    public var body: some View {
        VStack(alignment: .leading) {
            Text(titleString ?? "").font(.system(size: 18))
            Text(detailString ?? "").font(.system(size: 14))
        }
    }
    
    public init(titleString: String?, detailString: String?) {
        self.titleString = titleString
        self.detailString = detailString
    }
}

public struct LeftDetailRowContent: DetailedView {
    public var titleString: String?
    public var detailString: String?
    public var body: some View {
        HStack(alignment: .center) {
            Text(detailString ?? "").font(.system(size: 14))
            Text(titleString ?? "").font(.system(size: 18))
        }
    }
    
    public init(titleString: String?, detailString: String?) {
        self.titleString = titleString
        self.detailString = detailString
    }
}

public struct RightDetailRowContent: DetailedView {
    public var titleString: String?
    public var detailString: String?
    public var body: some View {
        HStack(alignment: .center) {
            Text(titleString ?? "").font(.system(size: 18))
            Spacer()
            Text(detailString ?? "").font(.system(size: 14))
        }
    }
    
    public init(titleString: String?, detailString: String?) {
        self.titleString = titleString
        self.detailString = detailString
    }
}
