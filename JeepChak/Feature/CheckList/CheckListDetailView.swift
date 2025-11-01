import SwiftUI

struct CheckListDetailView: View {
    let title: String
    @State private var items: [DetailItem] = [
        .init(name: "화장실 곰팡이 확인하기"),
        .init(name: "벽과 바닥 상태 확인하기"),
        .init(name: "창문 틈새 확인하기"),
        .init(name: "보일러 작동 확인하기")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(title) 체크리스트")
                .font(.title3.bold())
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach($items) { $item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Text(item.name)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                // 이미지 버튼 3개
                                StatusButtonView(selectedStatus: $item.status)
                            }
                            
                            TextField("메모 입력", text: $item.memo)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                    }
                }
                .padding()
            }
            
            NavigationLink(destination: CheckListFinalView(items: items)) {
                Text("확인")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatusButtonView: View {
    @Binding var selectedStatus: String
    // 이미지 이름을 바탕으로 상태 정의
    let options = ["checkmark", "warning", "danger"]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Image(option)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .scaleEffect(selectedStatus == option ? 1.2 : 1.0)
                    .animation(.spring(), value: selectedStatus)
                    .onTapGesture {
                        if selectedStatus == option {
                            selectedStatus = "none" // 취소
                        } else {
                            selectedStatus = option
                        }
                    }
            }
        }
    }
}

struct CheckListFinalView: View {
    var items: [DetailItem]
    @State private var showAIReport = false
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.system(size: 16, weight: .medium))
                        Text(item.memo)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        HStack {
                            StatusIndicatorView(status: item.status)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
            }
            
            Spacer()
            
            Button(action: {
                showAIReport = true
            }) {
                Image(systemName: "sparkles") // AI 버튼 이미지
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
            }
            .sheet(isPresented: $showAIReport) {
                AIResultView()
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct StatusIndicatorView: View {
    let status: String
    
    var body: some View {
        switch status {
        case "checkmark":
            Circle().fill(Color.blue).frame(width: 24, height: 24)
        case "warning":
            Circle().fill(Color.orange).frame(width: 24, height: 24)
        case "danger":
            Circle().fill(Color.red).frame(width: 24, height: 24)
        default:
            Circle().fill(Color.gray.opacity(0.3)).frame(width: 24, height: 24)
        }
    }
}

struct DetailItem: Identifiable {
    let id = UUID()
    var name: String
    var status: String = "none"
    var memo: String = ""
}

