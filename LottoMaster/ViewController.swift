//
//  ViewController.swift
//  LottoMaster
//
//  Created by Minseong on 2022/09/15.
//

import UIKit

final class ViewController: UIViewController {

  @IBOutlet private var firstLineLottoNumberLabel: [UILabel]!
  @IBOutlet private var secondLineLottoNumberLabel: [UILabel]!
  @IBOutlet private var thirdLineLottoNumberLabel: [UILabel]!
  @IBOutlet private var fourthLineLottoNumberLabel: [UILabel]!
  @IBOutlet private var fifthLineLottoNumberLabel: [UILabel]!
  @IBOutlet weak var gameCountLabel: UILabel!
  @IBOutlet weak var lastGameTime: UITextField!

  private let net = Net()
  private var gameCount = 0
  private var lottoList: [LottoJSON] = []
  private var lottoNumberCountCollection: [Int: Int] = [
    1: 0, 2: 0, 3: 0, 4: 0, 5: 0,
    6: 0, 7: 0, 8: 0, 9: 0, 10: 0,
    11: 0, 12: 0, 13: 0, 14: 0, 15: 0,
    16: 0, 17: 0, 18: 0, 19: 0, 20: 0,
    21: 0, 22: 0, 23: 0, 24: 0, 25: 0,
    26: 0, 27: 0, 28: 0, 29: 0, 30: 0,
    31: 0, 32: 0, 33: 0, 34: 0, 35: 0,
    36: 0, 37: 0, 38: 0, 39: 0, 40: 0,
    41: 0, 42: 0, 43: 0, 44: 0, 45: 0
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.gameCountLabel.text = String(gameCount)
    makeLottoList()
  }
  // 추첨시작
  @IBAction private func drawNumberButton(_ sender: UIButton) {
    countLottoNumber()
    allocateLottoNumberLabel(numberOfGames: gameCount)
  }

  @IBAction func plusButton(_ sender: UIButton) {
    if gameCount < 5 {
      self.gameCount += 1
    }

    self.gameCountLabel.text = String(gameCount)
  }

  @IBAction func minusButton(_ sender: UIButton) {
    if gameCount > 0 {
      self.gameCount -= 1
    }

    self.gameCountLabel.text = String(gameCount)
  }

  // 네트워크통신을 통한 26회차분 로또 번호들 가져오기
  private func makeLottoList() {
    let endGameNumber = 1034
    let startGameNumber = endGameNumber - 26

    for gameNumber in startGameNumber...endGameNumber {
      net.networking(number: gameNumber) { result in
        switch result {
        case .success(let data):
          guard let decodedData = try? JSONDecoder().decode(LottoJSON.self, from: data) else { return }
          self.lottoList.append(decodedData)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  // 숫자 세기
  private func countLottoNumber() {
    for index in 0...25 {
      lottoNumberCountCollection[lottoList[index].drwtNo1]! += 1
      lottoNumberCountCollection[lottoList[index].drwtNo2]! += 1
      lottoNumberCountCollection[lottoList[index].drwtNo3]! += 1
      lottoNumberCountCollection[lottoList[index].drwtNo4]! += 1
      lottoNumberCountCollection[lottoList[index].drwtNo5]! += 1
      lottoNumberCountCollection[lottoList[index].drwtNo6]! += 1
    }
  }

  // 화면에 숫자 세팅
  private func allocateLottoNumberLabel(numberOfGames: Int) {
    var gameCount = 0
    let repeatStartNumber = 0
    let repeatEndNumber = 5

    while gameCount < numberOfGames {
      let lottoNumbers = sortLottoNumbers()
      for index in repeatStartNumber...repeatEndNumber {
        switch gameCount {
        case 0:
          firstLineLottoNumberLabel[index].text = lottoNumbers[index].description
        case 1:
          secondLineLottoNumberLabel[index].text = lottoNumbers[index].description
        case 2:
          thirdLineLottoNumberLabel[index].text = lottoNumbers[index].description
        case 3:
          fourthLineLottoNumberLabel[index].text = lottoNumbers[index].description
        case 4:
          fifthLineLottoNumberLabel[index].text = lottoNumbers[index].description
        default:
          return
        }
      }
      gameCount += 1
    }
  }

  // 오름차순
  private func sortLottoNumbers() -> [Int] {
    let sortedLottoNumbers = Array(drawSixNumbers())
      .compactMap { $0 }
      .sorted()

    return sortedLottoNumbers
  }

  // 6개 랜덤 뽑기
  private func drawSixNumbers() -> Set<Int?> {
    let repeatNumber = 6
    var lottoNumbers: Set<Int?> = []

    while lottoNumbers.count < repeatNumber {
      lottoNumbers.insert(drawLottoNuberCountMoreThanThree().randomElement()?.key)
    }

    return lottoNumbers
  }
  // 3개 이상 번호 뽑기
  private func drawLottoNuberCountMoreThanThree() -> [Int: Int] {
    let repeatNumber = 3
    let filteringNumber = lottoNumberCountCollection.filter {
      $0.value >= repeatNumber
    }

    return filteringNumber
  }
}
