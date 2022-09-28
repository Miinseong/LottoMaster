//
//  json.swift
//  LottoMaster
//
//  Created by 백민성 on 2022/09/20.
//

import Foundation

struct LottoJSON: Decodable {
  let drwtNo1: Int
  let drwtNo2: Int
  let drwtNo3: Int
  let drwtNo4: Int
  let drwtNo5: Int
  let drwtNo6: Int
}
