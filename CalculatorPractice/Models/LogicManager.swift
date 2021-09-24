//
//  LogicManager.swift
//  CalculatorPractice
//
//  Created by Tai Chin Huang on 2021/9/22.
//

import Foundation

enum Operations: Int {
    case add = 0
    case subtract = 1
    case multiply = 2
    case divide = 3
}

class LogicManager {
    var array = [Double]()
    var currentNumber = 0.0
    var currentTag = 0.0
    
    func clear() {
        array = []
        currentNumber = 0.0
        currentTag = 0.0
    }
    
    func formatToString(num: Double) -> String {
        var formatString: String
        if String(num) == "inf" || String(num) == "nan" {
            return "Err"
        }
        if num != 0 {
            if (num * 1).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString = String(format: "%.0f", num)}
            else if (num * 10).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString = String(format: "%.1f", num)}
            else if (num * 100).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.2f", num) }
            else if (num * 1000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.3f", num) }
            else if (num * 10000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.4f", num) }
            else if (num * 100000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.5f", num) }
            else if (num * 1000000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.6f", num) }
            else if (num * 10000000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.7f", num) }
            else if (num * 100000000).truncatingRemainder(dividingBy: 1.0) == 0.0 { formatString =  String(format: "%.8f", num) }
            else { formatString = String(format: "%.9f", num)}
        } else {
            formatString = "0"
        }
        return formatString
    }
    
    func calculateArray(operation: String) -> Double? {
        if operation == "Operator" {
            // 當array裡面有數字一/運算子/數字二，就可以進行運算
            if array.count == 3 {
                let newValue = calculate(firstNumber: array[0], secondNumber: array[2], tag: Int(array[1]))
                array.removeAll()
                array.append(newValue)
                array.append(currentTag)
                return newValue
            }
        } else if operation == "Equal" {
            if array.count == 1 || array.count == 2 {
                let newValue = calculate(firstNumber: array[0], secondNumber: currentNumber, tag: Int(currentTag))
                array.removeAll()
                array.append(newValue)
                return newValue
            }
        }
        return nil
    }
    // tag為運算子
    func calculate(firstNumber: Double, secondNumber: Double, tag: Int) -> Double {
        var result = 0.0
        if let operation = Operations(rawValue: tag) {
            switch operation {
            case .add:
                result = firstNumber + secondNumber
            case .subtract:
                result = firstNumber - secondNumber
            case .multiply:
                result = firstNumber * secondNumber
            case .divide:
                result = firstNumber / secondNumber
            }
        }
        return result
    }
//    func floatCheck(firstNumber: Double, secondNumber: Double) -> String { //輸入二個數字字串
//        var c:Double = 0 //用做計算結果之用
//        var k:Double = 1 //作為十的次方之用
//        var firstNumberArray = [String]()
//        var secondNumberArray = [String]()
//        let a1 = Array(firstNumber) //轉換字串為字元陣列
//        let a2 = Array(secondNumber) //轉換字串為字元陣列
//        var counter1 = 0 //第一個陣列的元素個數
//        var counter2 = 0 //第二個陣列的元素個數
//        var afterPoint = 0 //看誰的小數點後面的數字個數多就給它
//        
//        firstNumberArray = Array(String(firstNumber))
//        //求出二個數字小數點之後的數字個數
//        for i in 0...(a1.count-1) {
//            if a1[i] == "." {
//                counter1 = a1.count - i - 1
//            }
//        }
//        for i in 0...(a2.count-1) {
//            if a2[i] == "." {
//                counter2 = a2.count - i - 1
//            }
//        }
//        
//        //將比較多的個數給予afterPoint
//        if counter1 >= counter2 {
//            afterPoint = counter1 }
//        else {
//            afterPoint = counter2
//        }
//        
//        //將afterPoint當成十的次方數
//        for _ in 1...afterPoint {
//            k = k*10
//        }
//        
//        c = (firstNumber*k - secondNumber*k)/k //先將二個數字乘上k都變成整數再相減，減完後再除以k回歸為浮點數
//        return String(c) //將結果轉換成字串回傳
//    }
}
