//
//  ReportType.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/8/23.
//

import Foundation

enum ReportType: String, CaseIterable {
    case AdvertisingPost = "광고성 글입니다."
    case Redundancy = "중복성 글입니다"
    case Inapposite = "부적절한 글입니다"
    case Abuse = "욕설이 포함된 글입니다"
    case Pornography = "음란물성 글입니다"
}
