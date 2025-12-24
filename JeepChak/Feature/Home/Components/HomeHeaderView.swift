//
//  HomeHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct HomeHeaderView: View {
    /// 검색바 영역 탭 시 외부 페이지(검색 화면)로 이동
    var onTapSearchArea: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image("Header_AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 27)

            Spacer()

            Button(action: onTapSearchArea) {
                HStack {
                    Text("찾으시는 방을 검색해보세요")
                        .font(.system(size: 14))
                        .foregroundColor(.customGray300)
                        .padding(.leading, 14)

                    Spacer()

                    Image("Search_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 14)
                }
                .frame(height: 44)
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color("customBlack").opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .environment(\.colorScheme, .light)
            .buttonStyle(PlainButtonStyle())
            .frame(width: 230, height: 44)
            .padding(.trailing, -24)

        }
        .background(Color("customBackgroundBlue"))
    }
}

