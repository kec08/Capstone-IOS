//
//  StatusButtonView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct StatusButtonView: View {
    @Binding var selectedStatus: String
    
    let statuses = [
        (id: "checkmark", small: "CheckList_Good_S", large: "CheckList_Good_L"),
        (id: "warning", small: "CheckList_Warning_S", large: "CheckList_Warning_L"),
        (id: "danger", small: "CheckList_Danger_S", large: "CheckList_Danger_L")
    ]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(statuses, id: \.id) { status in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if selectedStatus == status.id {
                            selectedStatus = "none"
                        } else {
                            selectedStatus = status.id
                        }
                    }
                }) {
                    Image(selectedStatus == status.id ? status.large : status.small)
                        .resizable()
                        .frame(width: 33, height: 33)
                        .shadow(color: selectedStatus == status.id ? Color.black.opacity(0.15) : .clear, radius: 3, x: 0, y: 2)
                        .scaleEffect(selectedStatus == status.id ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.15), value: selectedStatus)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
