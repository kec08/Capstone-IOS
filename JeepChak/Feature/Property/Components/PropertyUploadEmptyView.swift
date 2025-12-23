//
//  PropertyUploadEmptyView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("매물이 없습니다.")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.customBlack)
            Text("체크리스트에서 매물을 먼저 추가해 주세요.")
                .font(.system(size: 16))
                .foregroundColor(.customDarkGray)
            Spacer()
        }
    }
}


struct PropertyUploadEmptyView_Previews: PreviewProvider {
    static var previews: some View {
            PropertyUploadEmptyView()
    }
}
