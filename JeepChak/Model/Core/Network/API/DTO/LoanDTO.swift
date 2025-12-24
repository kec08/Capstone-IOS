import Foundation

// MARK: - Request
/// POST /api/loan 요청 DTO (명세 키 이름 그대로)
struct LoanGuideRequestDTO: Codable {
    let age: Int
    let isHouseholder: Bool
    let familyType: String
    let annualSalary: Int
    let monthlySalary: Int
    let incomeType: String
    let incomeCategory: String
    let rentalArea: String
    let houseType: String
    let rentalType: String
    let deposit: Int
    let managementFee: Int
    let availableLoan: Bool
    let creditRating: Int
    let loanType: String
    let overdueRecord: Bool
    let hasLeaseAgreement: Bool
    let confirmed: Bool

    static func from(_ data: LoanGuideData) -> LoanGuideRequestDTO {
        LoanGuideRequestDTO(
            age: data.age ?? 0,
            isHouseholder: data.isHeadOfHousehold ?? false,
            familyType: data.familyComposition?.apiValue ?? "SINGLE",
            annualSalary: data.annualIncome ?? 0,
            monthlySalary: data.monthlyIncome ?? 0,
            incomeType: data.incomeType?.apiValue ?? "EMPLOYEE",
            incomeCategory: data.incomeCategory?.apiValue ?? "EARNED",
            rentalArea: data.rentalArea ?? "",
            houseType: data.houseType?.apiValue ?? "VILLA",
            rentalType: data.leaseType?.apiValue ?? "JEONSE",
            deposit: data.deposit ?? 0,
            managementFee: data.managementFee ?? 0,
            availableLoan: data.isLoanEligible ?? true,
            creditRating: data.creditRating?.numericValue ?? 5,
            loanType: data.loanType?.apiValue ?? "OTHER",
            overdueRecord: data.hasDelinquencyRecord ?? false,
            hasLeaseAgreement: data.hasLeaseAgreement ?? false,
            confirmed: (data.fixedDateStatus == .received)
        )
    }
}

// MARK: - Response
struct LoanGuideResponseDTO: Codable {
    let loanAmount: Int
    let interestRate: Double
    let ownCapital: Int
    let monthlyInterest: Int
    let managementFee: Int
    let totalMonthlyCost: Int
    let loans: [LoanGuideBlockDTO]
    let procedures: [LoanGuideBlockDTO]
    let channels: [LoanGuideBlockDTO]
    let advance: [LoanGuideBlockDTO]
}

struct LoanGuideBlockDTO: Codable {
    let title: String
    let content: String
}

// MARK: - Enum mappings (UI rawValue와 분리)
private extension FamilyComposition {
    var apiValue: String {
        switch self {
        case .single:   return "SINGLE"
        case .newlywed: return "NEWLYWED"
        case .couple:   return "COUPLE"
        case .youth:    return "YOUTH"
        }
    }
}

private extension IncomeType {
    var apiValue: String {
        switch self {
        case .employee:     return "EMPLOYEE"
        case .freelancer:   return "FREELANCER"
        case .selfEmployed: return "SELF_EMPLOYED"
        }
    }
}

private extension IncomeCategory {
    var apiValue: String {
        switch self {
        case .earned:   return "EARNED"
        case .business: return "BUSINESS"
        case .other:    return "OTHER"
        }
    }
}

private extension HouseType {
    var apiValue: String {
        switch self {
        case .apartment: return "APARTMENT"
        case .officetel: return "OFFICETEL"
        case .villa:     return "VILLA"
        }
    }
}

private extension LoanGuideLeaseType {
    var apiValue: String {
        switch self {
        case .jeonse:  return "JEONSE"
        case .monthly: return "MONTHLY_RENT"
        }
    }
}

private extension CreditRating {
    var numericValue: Int {
        // "1등급" ~ "10등급"
        let digits = rawValue.filter(\.isNumber)
        return Int(digits) ?? 5
    }
}

private extension LoanType {
    var apiValue: String {
        switch self {
        case .credit:   return "CREDIT"
        case .jeonse:   return "JEONSE"
        case .mortgage: return "MORTGAGE"
        case .other:    return "OTHER"
        }
    }
}


