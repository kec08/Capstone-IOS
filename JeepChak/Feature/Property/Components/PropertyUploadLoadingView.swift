//
//  PropertyUploadLoadingView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("매물 목록을 불러오는 중...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, 16)
            Spacer()
        }
    }
}


struct PropertyUploadLoadingView_Previews: PreviewProvider {
    static var previews: some View {
            PropertyUploadLoadingView()
    }
}
