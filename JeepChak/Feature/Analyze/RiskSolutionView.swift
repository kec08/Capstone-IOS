//
//  RiskSolutionView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import SwiftUI

struct RiskSolutionView: View {
    @Environment(\.dismiss) private var dismiss
    
    let solutionData: RiskSolutionResponseDTO?
    
    @State private var checklist: [ChecklistItem] = []
    
    init(solutionData: RiskSolutionResponseDTO? = nil) {
        self.solutionData = solutionData
        if let data = solutionData {
            _checklist = State(initialValue: data.checklist.map { ChecklistItem(text: $0, checked: false) })
        } else {
            _checklist = State(initialValue: [])
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.customBlack)
                }
                
                Spacer()
                
                Text("위험 요소별 대처 방안")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.customBlack)
                
                Spacer()
                
                Spacer().frame(width: 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 타이틀
                    Text("주요 위험 대처 방법")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.customBlack)
                        .padding(.top, 18)
                    
                    if let data = solutionData {
                        ForEach(data.coping, id: \.title) { copingItem in
                            RiskSolutionCard(
                                title: copingItem.title,
                                items: copingItem.list
                            )
                        }
                    } else {
                        // 기본 데이터 (API 응답이 없을 경우)
                    RiskSolutionCard(
                        title: "가압류 설정",
                        items: [
                            "임대인에게 가압류 해제 계획 확인",
                            "가압류 채권액과 채권자 정보 확인",
                            "변호사 상담을 통한 법적 검토",
                            "계약 보류 또는 가압류 해제 후 계약 진행 권장"
                        ]
                    )
                    
                    RiskSolutionCard(
                        title: "높은 근저당권 비율",
                        items: [
                            "전세보증보험 가입 필수",
                            "HUG(주택도시보증공사) 보증 가능 여부 확인",
                            "임대인의 대출 상환 계획서 요청",
                            "선순위 채권 규모 정확히 파악"
                        ]
                    )
                    
                    RiskSolutionCard(
                        title: "잦은 소유권 이전",
                        items: [
                            "소유권 이전 사유 확인 (상속, 증여, 매매 등)",
                            "현 소유자의 보유 기간 확인",
                            "투기 목적 여부 파악",
                            "중개사를 통한 매물 이력 조회"
                        ]
                    )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("필수 안전 수칙 체크리스트")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.customBlack)
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            ForEach($checklist) { $item in
                                HStack(alignment: .top, spacing: 10) {
                                    Button {
                                        item.checked.toggle()
                                    } label: {
                                        Image(
                                            systemName: item.checked
                                            ? "checkmark.square.fill"
                                            : "square"
                                        )
                                        .font(.system(size: 20))
                                        .foregroundColor(.customBlue)
                                    }
                                    
                                    Text(item.text)
                                        .font(.system(size: 13))
                                        .foregroundColor(.customBlack)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(14)
                        .background(Color(white: 0.97))
                        .cornerRadius(12)
                    }
                    
                    // 추가 정보 및 리소스
                    VStack(alignment: .leading, spacing: 12) {
                        Text("추가 정보 및 리소스")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.customBlack)
                            .padding(.top, 20)
                        
                        VStack(spacing: 10) {
                            ResourceCard(
                                title: "전세보증보험 신청",
                                subtitle: "HUG, SGI서울보증 보증 신청"
                            )
                            ResourceCard(
                                title: "피터팬의 좋은방 구하기",
                                subtitle: "커뮤니티 후기 및 상담"
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 50)
            }
            
            Button {
                // 나중에 새 분석 시작 화면으로 라우팅
                dismiss()
            } label: {
                Text("새로운 매물 분석하기")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundColor(.white)
                    .background(Color.customBlue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 22)
            .padding(.top, 10)
        }
        .background(Color.customBackgroundGray)
        .navigationBarHidden(true)
    }
}


struct RiskSolutionView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                RiskSolutionView()
            }
    }
}
