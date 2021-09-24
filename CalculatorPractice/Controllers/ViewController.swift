//
//  ViewController.swift
//  CalculatorPractice
//
//  Created by Tai Chin Huang on 2021/8/30.
//

import UIKit

class ViewController: UIViewController {
    
    var logic = LogicManager()
    // 在按下運算按鍵要清除label上的數字
    var willClearDisplay = false
    var previousIsOperation = false

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientBackground()
        labelFlash()
    }
    
    func createGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 227/255, green: 253/255, blue: 245/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 230/255, blue: 250/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1)
        // 第一個顏色漸層至第二個顏色到0.8
        gradientLayer.locations = [0, 0.8]
//        view.layer.addSublayer(gradientLayer)
        /*
         sublayers:[CALayer]?為array
         .addSublayer是為在sublayers上append新的CALayer，所以他會被擺到最後面
         .insertSublayer(_,at: index)則是放在你想要的index裡
         由於sublayers裡越後面代表越上層，0則是最底層，所以.addSublayer會顯示在最上面
         */
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func labelFlash() {
        label.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseOut) {
            self.label.alpha = 1
        }
    }
    
    func reset() {
        willClearDisplay = false
        previousIsOperation = false
        logic.clear()
        label.text = "0"
        print(logic.array, "現在數字：", logic.currentNumber)
    }
    
    // MARK: - 清除(全數)
    @IBAction func clearTapped(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            self.resetButton.setTitle("AC", for: .normal)
            self.resetButton.layoutIfNeeded()
        }
        labelFlash()
        reset()
    }
    // MARK: - 數字鍵+小數點
    @IBAction func numberTapped(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            self.resetButton.setTitle("C", for: .normal)
            self.resetButton.layoutIfNeeded()
        }
        // 感覺完全不會出現的情況(?
        if logic.array.count == 1 || label.text! == "Err" {
            reset()
            return
        }
        
        // 運算子按完再按數字會清除label上的內容
        if willClearDisplay == true {
            label.text = ""
            willClearDisplay = false
        }
        
        // 如果目前數字是0則不能把字串相加，而是要顯示按下的字串內容
        if label.text == "0" {
            label.text = sender.currentTitle
        } else if sender.currentTitle == "." {
            // 確保小數點只能顯示一次
            guard let number = Double(label.text!) else {
                fatalError("annot convert display lable text to a double.")
            }
            // floor(
            let isInt = floor(number) == number
            if !isInt {
                return
            }
            // 按下"7"再按"8"會變"78"
            label.text! += sender.currentTitle!
        } else {
            label.text! += sender.currentTitle!
        }
        // logicManager會儲存"78"到currentNumber裏
        logic.currentNumber = Double(label.text!)!
        
        previousIsOperation = false
        print(logic.array, "現在數字：",logic.currentNumber)
    }
    // MARK: - 運算(+,-,*,÷)
    @IBAction func operationTapped(_ sender: UIButton) {
        labelFlash()
        if label.text == "Err" {
            reset()
            return
        }
        // 用來判斷按下的是(+,-,*,÷)
        logic.currentTag = Double(sender.tag)
        // 判斷前一個是否也為運算子，若不是則將運算子轉換成tag並存入array裡面
        if previousIsOperation == false {
            logic.array.append(logic.currentNumber)
            // 例如10，按下*變成 10 *
            if logic.array.count == 1 {
                logic.array.append(logic.currentTag)
            } else if let result = logic.calculateArray(operation: "Operator") {
                label.text = logic.formatToString(num: result)
            }
        } else {
            // 例如：10 "÷" + -> 10 + (將第一個運算子換成第二個運算子)
            if logic.array.count == 2 {
                logic.array[1] = Double(sender.tag)
            }
            // 例如：10 ÷ 2 "=" + -> 5 +
            else if logic.array.count == 1 {
                logic.array.append(Double(sender.tag))
            }
        }
        
        willClearDisplay = true
        previousIsOperation = true
        print(logic.array, "現在數字：",logic.currentNumber)
    }
    // MARK: - 等於
    @IBAction func equalTapped(_ sender: UIButton) {
        labelFlash()
        if label.text == "Err" {
            reset()
            return
        }
        
        if let result = logic.calculateArray(operation: "Equal") {
            print("Result: \(result)")
            label.text = logic.formatToString(num: result)
            print("label.text = \(label.text)")
        }
        
        previousIsOperation = true
        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 清除(一碼)
    @IBAction func removeTapped(_ sender: UIButton) {
        labelFlash()
        
        if label.text?.dropLast() == "-" || label.text?.count == 1 || label.text == "Err" {
            reset()
            return
        }
        
        if logic.array.count == 2 || logic.array.count == 0 {
            logic.currentNumber = Double(label.text!.dropLast())!
            label.text = String(label.text!.dropLast())
        } else if logic.array.count == 1 {
            print(logic.currentNumber)
            logic.array[0] = Double(label.text!.dropLast())!
            label.text = String(label.text!.dropLast())
        }
        
        previousIsOperation = false
        print(logic.array, "現在數字：",logic.currentNumber)
    }
    // MARK: - 正負值
    @IBAction func plusMinusTapped(_ sender: UIButton) {
        labelFlash()
        
        if label.text == "0" || label.text! == "Err" {
            reset()
            return
        }
        if logic.array.count == 2 {
            if previousIsOperation == false {
                logic.currentNumber *= -1
                label.text = logic.formatToString(num: logic.currentNumber)
            } else {
                logic.array[0] *= -1
                label.text = logic.formatToString(num: logic.array[0])
            }
        } else if logic.array.count == 1 {
            logic.array[0] *= -1
            label.text = logic.formatToString(num: logic.array[0])
        } else {
            logic.currentNumber *= -1
            label.text = logic.formatToString(num: logic.currentNumber)
        }
        previousIsOperation = false
        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
}

