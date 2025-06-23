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
  @State private var selectedDate: Date
  @Binding private var currentDate: Date
  @Binding private var didTapPickerFinishButton: UUID
  
  init(selectedDate: Binding<Date>, didTapPickerFinishButton: Binding<UUID>) {
    self.selectedDate = selectedDate.wrappedValue
    self._currentDate = selectedDate
    self._didTapPickerFinishButton = didTapPickerFinishButton
  }
  
  var body: some View {
    VStack(spacing: 0) {
      YearAndMonthPicker(selectedDate: $selectedDate)
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
          currentDate = selectedDate
          didTapPickerFinishButton = .init()
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
  YearAndMonthPickerView(selectedDate: .constant(.now), didTapPickerFinishButton: .constant(.init()))
}

struct YearAndMonthPicker: UIViewRepresentable {
  private var selectedYear: Int {
    didSet {
      selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!
    }
  }
  private var selectedMonth: Int  {
    didSet {
      selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!
    }
  }
  private let months: [Int] = Array(1...12)
  private let infiniteRows = 2001
  private let middleIndex: Int = 1001
  @Binding private var selectedDate: Date
  
  init(selectedDate: Binding<Date>) {
    self._selectedDate = selectedDate
    let yearAndMonth = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
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
      case 0: return "\(parent.selectedYear + row - parent.middleIndex)년"
      case 1: return "\(parent.months[row])월"
      default: return ""
      }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
        let distance = row - parent.middleIndex
        parent.selectedYear += distance
        pickerView.selectRow(parent.middleIndex, inComponent: component, animated: false)
        pickerView.reloadComponent(component)
      case 1:
        parent.selectedMonth = parent.months[row]
      default:
        break
      }
    }
  }
}
