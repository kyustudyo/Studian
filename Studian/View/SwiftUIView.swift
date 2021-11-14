//
//  SwiftUIView.swift
//  Studian
//
//  Created by 이한규 on 2021/10/22.
//

import SwiftUI

import SwiftUI
import Combine
struct MainTabScene: View {

    @ObservedObject private var tabData = MainTabBarData(initialIndex: 1, customItemIndex: 2)

    var body: some View {
        TabView (selection: $tabData.itemSelected){

        // First Secection
        Text("First Section!")
        .tabItem {
            Image(systemName: "1.square.fill")
            Text("First!")
        }.tag(1)

        // Add Element
        Text("Custom Action")
        .tabItem {
            Image(systemName: "plus.circle")
            Text("Add Item")
        }
        .tag(2)

        // Events
        Text("Second Section!")
        .tabItem {
            Image(systemName: "2.square.fill")
            Text("Second")
        }.tag(3)

        }
        .font(.headline)
        .sheet(isPresented: $tabData.isCustomItemSelected, onDismiss: {
            print("dismiss")
        }) {
            Text("Custom action modal")
        }
    }

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabScene()
    }
}
    final class MainTabBarData: ObservableObject {

        /// This is the index of the item that fires a custom action
        let customActionteminidex: Int

        let objectWillChange = PassthroughSubject<MainTabBarData, Never>()

        var itemSelected: Int {
            didSet {
                if itemSelected == customActionteminidex {
                    itemSelected = oldValue
                    isCustomItemSelected = true
                }
                objectWillChange.send(self)
            }
        }

        /// This is true when the user has selected the Item with the custom action
        var isCustomItemSelected: Bool = false

        init(initialIndex: Int = 1, customItemIndex: Int) {
            self.customActionteminidex = customItemIndex
            self.itemSelected = initialIndex
        }
    }
}
