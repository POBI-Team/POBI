//
//  YearAndMonthPicker.swift
//  Pobi
//
//  Created by 이시원 on 5/2/25.
//

import SwiftUI
import UIKit

import PBDesignSystem

struct YearAndMonthPickerView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var seletedDate: Date
  @Binding private var currentDate: Date
  
  init(seletedDate: Binding<Date>) {
    self.seletedDate = seletedDate.wrappedValue
    self._currentDate = seletedDate
  }
  
  var body: some View {
    VStack(spacing: 0) {
      YearAndMonthPicker(seletedDate: $seletedDate)
      HStack {
        PBRoundButton(12) {
          dismiss()
        } label: {
          Text("닫기")
            .foregroundStyle(PBColors.navy._900.color)
        }
        .foregroundStyle(PBColors.navy._10.color)
        .frame(height: 52)
        
        PBRoundButton(12) {
          currentDate = seletedDate
          dismiss()
        } label: {
          Text("완료")
            .foregroundStyle(.white)
        }
        .foregroundStyle(PBColors.navy._900.color)
        .frame(height: 52)
      }
      .padding(.horizontal, 20)
    }
    .presentationCornerRadius(30)
    .presentationDetents([.height(348)])
  }
}

#Preview {
  YearAndMonthPickerView(seletedDate: .constant(.now))
}

struct YearAndMonthPicker: UIViewRepresentable {
  private var selectedYear: Int {
    didSet {
      seletedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!
    }
  }
  private var selectedMonth: Int  {
    didSet {
      seletedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!
    }
  }
  private var months: [Int] = Array(1...12)
  private let infiniteRows = 2000
  private var middleIndex: Int { infiniteRows / 2 }
  @Binding private var seletedDate: Date
  
  init(seletedDate: Binding<Date>) {
    self._seletedDate = seletedDate
    let yearAndMonth = Calendar.current.dateComponents([.year, .month], from: seletedDate.wrappedValue)
    self.selectedYear = yearAndMonth.year ?? 0
    self.selectedMonth = yearAndMonth.month ?? 0
  }
  
  func makeUIView(context: UIViewRepresentableContext<YearAndMonthPicker>) -> UIPickerView {
    let pickerView = UIPickerView()
    pickerView.delegate = context.coordinator
    pickerView.dataSource = context.coordinator
    
    pickerView.selectRow(middleIndex, inComponent: 0, animated: false)
    pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: false)
    return pickerView
  }
  
  func updateUIView(_ uiView: UIPickerView, context: Context) {}
  
  func makeCoordinator() -> YearAndMonthPicker.Coordinator {
    return YearAndMonthPicker.Coordinator(self)
  }
}

extension YearAndMonthPicker {
  private func year(forRow row: Int) -> Int {
    let baseYear = Calendar.current.component(.year, from: seletedDate)
    return baseYear + (row - middleIndex)
  }
}

// MARK: - Coordinator
extension YearAndMonthPicker {
  class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private var parent: YearAndMonthPicker
    
    init(_ pickerView: YearAndMonthPicker) {
      self.parent = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0: parent.infiniteRows
      case 1: parent.months.count
      default: 0
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      switch component {
      case 0: "\(parent.year(forRow: row))년"
      case 1: "\(parent.months[row])월"
      default: ""
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
        let distance = row - parent.middleIndex
        parent.selectedYear += distance
        pickerView.selectRow(parent.middleIndex, inComponent: component, animated: false)
      case 1:
        parent.selectedMonth = parent.months[row]
      default:
        break
      }
    }
  }
}
