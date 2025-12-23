//
//  MainTabView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/9/25.
//

import SwiftUI

struct MainTabView: View {
    init() {
        // UITabBar 색상 변경
        UITabBar.appearance().tintColor = UIColor(Color.customBlue)
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image("Home_icon")
                        .renderingMode(.template)
                    Text("홈")
                }
                .tag(0)
            
            AnalyzeView()
                .tabItem {
                    Image("Analyze_icon")
                        .renderingMode(.template)
                    Text("매물 분석")
                }
                .tag(1)
            
            MapView()
                .tabItem {
                    Image("Map_icon")
                        .renderingMode(.template)
                    Text("지도")
                }
                .tag(2)
            
            CheckListView()
                .tabItem {
                    Image("CheckList_icon")
                        .renderingMode(.template)
                    Text("체크리스트")
                }
                .tag(3)
            
            MyView()
                .tabItem {
                    Image("User_icon")
                        .renderingMode(.template)
                    Text("마이")
                }
                .tag(4)
        }
        .accentColor(Color.customBlue)
    }
}



struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
            MainTabView()
    }
}

