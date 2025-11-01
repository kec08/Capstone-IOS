//
//  HomeHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @State private var searchText = ""

    var body: some View {
        HStack(spacing: 16) {
            Image("Header_AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 27)

            Spacer()

            // MARK: - 검색창
            HStack {
                TextField("찾으시는 방을 검색해보세요", text: $searchText)
                    .font(.system(size: 12))
                    .foregroundColor(.customGray300)
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)

                Image("Home_search_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding(.trailing, 10)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .frame(width: 190, height: 38)
            .padding(.trailing, -24)
        }
        .background(Color.customBackgroundBlue)
    }
}

