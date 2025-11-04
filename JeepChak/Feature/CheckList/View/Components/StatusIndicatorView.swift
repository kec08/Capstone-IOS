//
//  StatusIndicatorView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct StatusIndicatorView: View {
    let status: String
    
    var body: some View {
        Group {
            switch status {
            case "checkmark":
                Image("CheckList_Good_L")
                    .resizable()
                    .frame(width: 32, height: 32)
            case "warning":
                Image("CheckList_Warning_L")
                    .resizable()
                    .frame(width: 32, height: 32)
            case "danger":
                Image("CheckList_Danger_L")
                    .resizable()
                    .frame(width: 32, height: 32)
            default:
                Image("CheckList_Normal_L")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StatusIndicatorView(status: "checkmark")
        StatusIndicatorView(status: "warning")
        StatusIndicatorView(status: "danger")
        StatusIndicatorView(status: "none")
    }
    .padding()
    .background(Color(UIColor.systemGray6))
}
