//
//  AIResultView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct AIResultView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("AI 분석 리포트")
                    .font(.title3.bold())
                    .padding(.top, 20)

                Text("68점")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.orange)

                Text("주의가 필요한 상태입니다.")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))

                VStack(alignment: .leading, spacing: 12) {
                    Label("즉시 확인 필요", systemImage: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Label("3일 내 확인 필요", systemImage: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                    Label("양호", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)

                // 세부 결과
                VStack(alignment: .leading, spacing: 16) {
                    Text("세부 점검 결과")
                        .font(.headline)
                    Text("화장실 곰팡이: 심한 곰팡이 발견 → 즉시 조치 필요")
                    Text("벽면 상태: 일부 벽지 손상 → 3일 내 확인 권장")
                    Text("보일러 상태: 정상 작동")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)

                HStack(spacing: 10) {
                    Button("저장하기") {}
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                    Button("확인") {}
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(Color.white)
    }
}
