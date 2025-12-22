//
//  PropertyDetailSheet.swift
//  JeepChak
//
//  Created by 김은찬 on 12/22/25.
//

import SwiftUI

struct PropertyDetailSheet: View {
    let property: MapProperty
    let onClose: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 매물 이미지
                let imageName = "property_\(property.id)"
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 280)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    // 매물 이름
                    Text(property.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    // 주소
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                        Text(property.address)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                
                // 기본 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text("기본 정보")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    PropertyInfoRow(title: "매물 유형", value: property.displayPropertyType)
                    PropertyInfoRow(title: "층수", value: "\(property.floor)층")
                    PropertyInfoRow(title: "준공년도", value: "\(property.builtYear)년")
                    PropertyInfoRow(title: "면적", value: "\(property.area)평")
                }
                
                Divider()
                
                // 가격 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text("가격 정보")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    PropertyInfoRow(title: "시세", value: "\(formatNumber(property.marketPrice))만원")
                    PropertyInfoRow(title: "임대 유형", value: property.displayLeaseType)
                    PropertyInfoRow(title: "보증금", value: "\(formatNumber(property.deposit))만원")
                    if let monthlyRent = property.monthlyRent {
                        PropertyInfoRow(title: "월세", value: "\(formatNumber(monthlyRent))만원")
                    }
                    PropertyInfoRow(title: "가격", value: property.displayPrice)
                }
                
                Divider()
                
                // 메모
                if !property.memo.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메모")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(property.memo)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                    Spacer(minLength: 20)
                }
                .padding(20)
            }
        }
        .background(Color.white)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct PropertyInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.vertical, 4)
    }
}

