//
//  SavedModel.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SavedProperty: Identifiable {
    let id: Int
    let propertyId: Int
    var image: UIImage?
    let type: String
    let name: String
    let details: String
    let description: String
    let price: String
    let createdAt: String?
    let floor: Int?
    let area: Int?
    let leaseType: String?
    let deposit: Int?
    let monthlyRent: Int?
}

extension SavedProperty {
    static func from(_ r: PropertyListResponse) -> SavedProperty {
        // PropertyType을 한글로 변환
        let typeString: String
        if let propertyType = r.propertyType {
            switch propertyType {
            case "APARTMENT": typeString = "아파트"
            case "VILLA": typeString = "빌라"
            case "OFFICETEL": typeString = "오피스텔"
            case "ONE_ROOM": typeString = "원룸"
            default: typeString = "기타"
            }
        } else {
            typeString = "매물"
        }
        
        // 층수와 평수 정보
        let description: String
        if let floor = r.floor, let area = r.area {
            description = "\(floor)층, \(area)평"
        } else {
            description = ""
        }
        
        // 가격 정보 동적 생성
        let priceString: String
        if let deposit = r.deposit, let monthlyRent = r.monthlyRent, let leaseType = r.leaseType {
            if leaseType == "JEONSE" {
                priceString = "전세 \(formatNumber(deposit))"
            } else {
                priceString = "월세 \(formatNumber(deposit))/\(formatNumber(monthlyRent))"
            }
        } else {
            priceString = ""
        }
        
        // CheckListHouse 이미지 중 랜덤하게 선택 (1~5)
        let houseImageNames = ["CheckListHouse1", "CheckListHouse2", "CheckListHouse3", "CheckListHouse4", "CheckListHouse5"]
        let randomImageName = houseImageNames[r.propertyId % houseImageNames.count]
        let houseImage = UIImage(named: randomImageName)
        
        return SavedProperty(
            id: r.propertyId,
            propertyId: r.propertyId,
            image: houseImage,
            type: typeString,
            name: r.name,
            details: r.address,
            description: description,
            price: priceString,
            createdAt: r.createdAt,
            floor: r.floor,
            area: r.area,
            leaseType: r.leaseType,
            deposit: r.deposit,
            monthlyRent: r.monthlyRent
        )
    }
    
    static func from(_ r: PropertyResponse) -> SavedProperty {
        // PropertyType을 한글로 변환
        let typeString: String
        switch r.propertyType {
        case "APARTMENT": typeString = "아파트"
        case "VILLA": typeString = "빌라"
        case "OFFICETEL": typeString = "오피스텔"
        case "ONE_ROOM": typeString = "원룸"
        default: typeString = "기타"
        }
        
        // 층수와 평수 정보
        let description = "\(r.floor)층, \(r.area)평"
        
        // 가격 정보 동적 생성
        let priceString: String
        if let deposit = r.deposit, let monthlyRent = r.monthlyRent, let leaseType = r.leaseType {
            if leaseType == "JEONSE" {
                priceString = "전세 \(formatNumber(deposit))"
            } else {
                priceString = "월세 \(formatNumber(deposit))/\(formatNumber(monthlyRent))"
            }
        } else {
            priceString = ""
        }
        
        // CheckListHouse 이미지 중 랜덤하게 선택 (1~5)
        let houseImageNames = ["CheckListHouse1", "CheckListHouse2", "CheckListHouse3", "CheckListHouse4", "CheckListHouse5"]
        let randomImageName = houseImageNames[r.propertyId % houseImageNames.count]
        let houseImage = UIImage(named: randomImageName)
        
        return SavedProperty(
            id: r.propertyId,
            propertyId: r.propertyId,
            image: houseImage,
            type: typeString,
            name: r.name,
            details: r.address,
            description: description,
            price: priceString,
            createdAt: r.createdAt,
            floor: r.floor,
            area: r.area,
            leaseType: r.leaseType,
            deposit: r.deposit,
            monthlyRent: r.monthlyRent
        )
    }
    
    static func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

