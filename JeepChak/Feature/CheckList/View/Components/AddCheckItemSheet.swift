//
//  AddCheckItemSheet.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct AddCheckItemSheet: View {
    @Binding var newItemName: String
    var onAdd: () -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("체크리스트 항목 추가")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                
                TextField("항목을 입력하세요", text: $newItemName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: onDismiss) {
                        Text("취소")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                    }
                    
                    Button(action: onAdd) {
                        Text("추가")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(Color.white)
        }
    }
}
