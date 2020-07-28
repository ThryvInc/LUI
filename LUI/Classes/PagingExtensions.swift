//
//  PagingExtensions.swift
//  LUI
//
//  Created by Elliot Schrock on 7/21/20.
//

import LUX
import SwiftUI

public extension LUXPageCallModelsManager where T: Identifiable {
    func didAppearFunction(pageSize: Int = 20, pageTrigger: Int = 5) -> (T) -> Void {
        return { t in
            var index = 0
            for model in self.models {
                if t.id == model.id { break }
                index += 1
            }
            let numberOfRows = self.models.count
            if numberOfRows - index == pageTrigger && numberOfRows % pageSize == 0  {
                self.nextPage()
            }
        }
    }
}
extension LUXCallPager: ObservableObject {}
extension LUXCallRefresher: ObservableObject {}
