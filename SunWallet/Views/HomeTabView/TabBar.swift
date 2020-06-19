//
//  TabBar.swift
//  SunWallet
//
//  Created by Alex Ilin on 11.06.2020.
//  Copyright © 2020 Alex Ilin. All rights reserved.
//

import SwiftUI

struct TabView: View {
    var body: some View {
        TabView {
            VStack {
                Text("Home Tab")
            }
            .tabItem({ TabLabel(imageName: "house.fill", label: "Home") })

            VStack {
                Text("Search Tab")
            }
            .tabItem({ TabLabel(imageName: "magnifyingglass", label: "Search") })

        }

    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}

struct TabLabel: View {
    let imageName: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(label)
        }
    }
}
