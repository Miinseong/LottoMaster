//
//  network.swift
//  LottoMaster
//
//  Created by 백민성 on 2022/09/20.
//

import Foundation

final class Net {
  func networking(number: Int, completion: @escaping (Result<Data, Error>) -> Void) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    var urlComponents = URLComponents(
      string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    )
    let drwNO = URLQueryItem(name: "drwNo", value: "\(number)")
    urlComponents?.queryItems?.append(drwNO)

    guard let requestURL = urlComponents?.url else { return }
    let dataTask = session.dataTask(with: requestURL) { data, response, error in
      guard error == nil else { return }

      guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
            (200..<300).contains(statusCode) else { return }

      guard let resultData = data else { return }

      completion(.success(resultData))
    }

    dataTask.resume()
  }
}
