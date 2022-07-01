//
//  ViewController.swift
//  Calculator
//
//  Created by Luca Park on 2022/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var holder: UIView!
    
    var decimal_check = 0
    var float_check = 0
    var s_decimal_check = 0
    var firstNumber = 0
    var resultNumber = 0
    var f_firstNumber: Float = 0
    var f_resultNumber: Float = 0
    var clearButton_check = 0 //0=AC, 1=backspace
    var currentOperations: Operation?
    
    enum Operation {
        case add, sub, mul, div
    }
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica-Bold", size: 40)
        return label
    }()
    
    private var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 20)
        return label
    }()
    
    private var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 20)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNumberPad()
    }
    
    private func setupNumberPad() {
        let buttonSize = view.frame.size.width / 4
        
        //number zero button(0, size=2*1)
        let zeroButton = UIButton(frame: CGRect(x: 0, y: holder.frame.size.height-buttonSize, width: buttonSize * 2, height: buttonSize))
        zeroButton.backgroundColor = .white
        zeroButton.setTitleColor(.black, for: .normal)
        zeroButton.setTitle("0", for: .normal)
        holder.addSubview(zeroButton)
        zeroButton.tag = 0
        zeroButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        
        //number button(1~9, size=1*1, layout=3*3)
        for x in 0..<3 {
            for y in 0..<3 {
                let numberButton = UIButton(frame: CGRect(x: buttonSize * CGFloat(y), y: holder.frame.size.height-(buttonSize*CGFloat((2+x))), width: buttonSize, height: buttonSize))
                numberButton.backgroundColor = .white
                numberButton.setTitleColor(.black, for: .normal)
                numberButton.setTitle("\((3*x)+(y+1))", for: .normal)
                holder.addSubview(numberButton)
                numberButton.tag = (3*x)+(y+1)
                numberButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            }
        }
        
        //all clear button(size=1*1)
        let clearButton = UIButton(frame: CGRect(x: 0, y: holder.frame.size.height-(buttonSize*5), width: buttonSize, height: buttonSize))
        clearButton.backgroundColor = .white
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.setTitle("AC", for: .normal)
        holder.addSubview(clearButton)
        
        //positive negative button(±, size=1*1)
        let pnButton = UIButton(frame: CGRect(x: buttonSize*1, y: holder.frame.size.height-(buttonSize*5), width: buttonSize, height: buttonSize))
        pnButton.backgroundColor = .white
        pnButton.setTitleColor(.black, for: .normal)
        pnButton.setTitle("±", for: .normal)
        holder.addSubview(pnButton)
        
        //percentage button(%, size=1*1)
        let perButton = UIButton(frame: CGRect(x: buttonSize*2, y: holder.frame.size.height-(buttonSize*5), width: buttonSize, height: buttonSize))
        perButton.backgroundColor = .white
        perButton.setTitleColor(.black, for: .normal)
        perButton.setTitle("%", for: .normal)
        holder.addSubview(perButton)
        
        //arithmetic operation button(+-*/, size=1*1, layout=1*4)
        let operations = ["=", "+", "-", "*", "/"]
        
        for x in 0..<5{
            let operButton = UIButton(frame: CGRect(x: buttonSize*3, y: holder.frame.size.height-(buttonSize*CGFloat((1+x))), width: buttonSize, height: buttonSize))
            operButton.backgroundColor = .orange
            operButton.setTitleColor(.white, for: .normal)
            operButton.setTitle(operations[x], for: .normal)
            holder.addSubview(operButton)
            operButton.tag = x
            operButton.addTarget(self, action: #selector(operationPressed(_:)), for: .touchUpInside)
        }
        
        //decimal point button(., size=1*1)
        let decimalButton = UIButton(frame: CGRect(x: buttonSize*2, y: holder.frame.size.height-buttonSize, width: buttonSize, height: buttonSize))
        decimalButton.backgroundColor = .white
        decimalButton.setTitleColor(.black, for: .normal)
        decimalButton.setTitle(".", for: .normal)
        holder.addSubview(decimalButton)
        decimalButton.addTarget(self, action: #selector(decimalPressed(_:)), for: .touchUpInside)
        
        //first box
        firstLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: buttonSize/2)
        holder.addSubview(firstLabel)
        
        //second box
        secondLabel.frame = CGRect(x: 0, y: buttonSize/2, width: view.frame.size.width, height: buttonSize/2)
        holder.addSubview(secondLabel)
        
        
        //result box
        resultLabel.frame = CGRect(x: 0, y: clearButton.frame.origin.y-buttonSize, width: view.frame.size.width, height: buttonSize)
        holder.addSubview(resultLabel)
        
        //Actions
        clearButton.addTarget(self, action: #selector(clearResult), for: .touchUpInside)
        
        
    }
    
    //AC func
    @objc func clearResult() {
        resultLabel.text = "0"
        firstLabel.text = "0"
        secondLabel.text = "0"
        decimal_check = 0
        float_check = 0
        currentOperations = nil
        firstNumber = 0
        f_firstNumber = 0
    }
    
    @objc func numberPressed(_ sender: UIButton) {
        let tag = sender.tag
        if resultLabel.text == "0" {
            resultLabel.text = "\(tag)"
        } else if let text = resultLabel.text {
            resultLabel.text = "\(text)\(tag)"
        }
    }
    
    @objc func decimalPressed(_ sender: UIButton) {
        float_check = 1
        if decimal_check != 1 {
            if resultLabel.text == "0" {
                resultLabel.text = "0."
                decimal_check = 1
            } else if let text = resultLabel.text {
                resultLabel.text = "\(text)."
                decimal_check = 1
            }
        }
    }
    
    @objc func operationPressed(_ sender: UIButton) {
        let tag = sender.tag
        let before_tag = tag
        print(tag)
        if float_check == 1 {
            if let text = resultLabel.text, let value = Float(text), firstNumber == 0, f_firstNumber == 0 {
                f_firstNumber = value
                firstLabel.text = resultLabel.text
                resultLabel.text = "0"
                decimal_check = 0
            }
        } else if float_check == 0 {
            if let text = resultLabel.text, let value = Int(text), firstNumber == 0 {
                firstNumber = value
                firstLabel.text = resultLabel.text
                resultLabel.text = "0"
            }
        }
        
        if tag == 0 {
            // =
            if float_check == 0 {
                if let operation = currentOperations {
                    var secondNumber = 0
                    if let text = resultLabel.text, let value = Int(text) {
                        secondNumber = value
                        secondLabel.text = "\(value)"
                    }
                    switch operation {
                    case .add:
                        let result = firstNumber + secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .sub:
                        let result = firstNumber - secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .mul:
                        let result = firstNumber * secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .div:
                        var result = Double(firstNumber) / Double(secondNumber)
                        result = Double(result)
                        resultLabel.text = "\(result)"
                        break
                    }
                }
            } else if float_check == 1 {
                if let operation = currentOperations {
                    var secondNumber: Float = 0
                    if let text = resultLabel.text, let value = Float(text) {
                        secondNumber = value
                        secondLabel.text = "\(value)"
                    }
                    switch operation {
                    case .add:
                        let result = f_firstNumber + secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .sub:
                        let result = f_firstNumber - secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .mul:
                        let result = f_firstNumber * secondNumber
                        resultLabel.text = "\(result)"
                        break
                        
                    case .div:
                        let result = f_firstNumber / secondNumber
                        resultLabel.text = "\(result)"
                        break
                    }
                }
            }
        } else if tag == 1 {
            currentOperations = .add
        } else if tag == 2 {
            currentOperations = .sub
        } else if tag == 3 {
            currentOperations = .mul
        } else if tag == 4 {
            currentOperations = .div
        }
    }
}
