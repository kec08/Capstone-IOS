//
//  AnalyzeHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct AnalyzeHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("부동산 위험 매물 분석")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.customBlack)
                .padding(.bottom, 10)
            
            Text("등기부등본과 건축물대장을\n업로드하여 매물의 위험도를 확인하세요.")
                .font(.system(size: 15))
                .foregroundColor(.customDarkGray)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
}


struct AnalyzeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
            AnalyzeHeaderView()
    }
}
