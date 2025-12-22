//
//  TourSpotCard.swift
//  Eodigo
//
//  Created by 김은찬 on 12/18/25.
//

import SwiftUI

struct TourSpotCard: View {
    let spot: TourSpot

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageName = spot.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 92)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 92)
            }

            VStack(alignment: .leading, spacing: 5) {
                if let address = spot.address {
                    Text(address)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Text(spot.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)

                if let price = spot.priceText {
                    Text(price)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding(9)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 7, x: 0, y: 3)
        .frame(width: 150)
    }
}

