//
//  ContentView.swift
//  UniCalculator
//
//  Created by KENICHIRO Suzuki on 7/25/23.
//

import SwiftUI

enum OtherButtons: String {
    case allclear = "AC"
    case delete = "arrow.backward"
}

enum NumberButtons: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case decimal = "."
    case fraction = "a/b"
}

enum NumberFractionButtons: String {
    case zero = "0"
    case oneeighth = "1/8"
    case quarter = "1/4"
    case threeeighth = "3/8"
    case half = "1/2"
    case fiveeighth = "5/8"
    case threequarter = "3/4"
    case seveneighth = "7/8"
    case sixteenth = "◻︎/16"
    case thirtysecond = "◻︎/32"
    case decimal = "."
    case fraction = "n"
}

enum UnitButtons: String {
    case mile = "mi"
    case yard = "yd"
    case ftin = "ft in"
    case feet = "ft"
    case inch = "in"
}

enum UnitSquareButtons: String {
    case mile2 = "mi²"
    case acre = "Acre"
    case yard2 = "yd²"
    case feet2 = "ft²"
    case inch2 = "in²"
}

enum CalculateButtons: String {
    case add = "plus"
    case minus = "minus"
    case multiply = "multiply"
    case divide = "divide"
    case equal = "equal"
}

enum UnitOfNumber {
    case mile, yard, ftin, feet, inch, mile2, acre, yard2, feet2, inch2, none, error
}

enum Operation {
    case add, minus, multiply, divide, equal, none
}

struct ContentView: View {
    @State private var displayValue = "0"
    @State private var value1 = ""
    @State private var value2 = ""
    @State private var inputValue = ""
    @State private var computedValue = 0.0
    @State private var pastFormulas = [String]()
    @State private var unitOfNumber: UnitOfNumber = .none
    @State private var unitOfFormula: UnitOfNumber = .none
    @State private var currentOperation: Operation = .none
    @State private var isFraction = false
    @State private var isSquare = false
    @State private var isInputValue2 = false
    
    let otherButtons: [OtherButtons] = [.allclear, .delete]
    let numberButtons: [[NumberButtons]] = [
        [.seven, .eight, .nine],
        [.four, .five, .six],
        [.one, .two, .three],
        [.zero, .decimal, .fraction]
    ]
    let numberFractionButtons: [[NumberFractionButtons]] = [
        [.seveneighth, .sixteenth, .thirtysecond],
        [.half, .fiveeighth, .threequarter],
        [.oneeighth, .quarter, .threeeighth],
        [.zero, .decimal, .fraction]
    ]
    let unitButtons: [UnitButtons] = [.mile, .yard, .ftin, .feet, .inch]
    let unitSquareButtons: [UnitSquareButtons] = [.mile2, .acre, .yard2, .feet2, .inch2]
    let calculateButtons: [CalculateButtons] = [.divide, .multiply, .minus, .add, .equal]
    
    let numeratorOf16s = [1, 3, 5, 7, 9, 11, 13, 15]
    let numeratorOf32s = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31]
    
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing) {
                Spacer()
                
                // Past formulas
                ScrollView {
                    VStack(alignment: .trailing) {
                        ForEach(pastFormulas, id: \.self) {
                            Text($0)
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .padding(.bottom)
                .defaultScrollAnchor(.bottom)
                .scrollBounceBehavior(.basedOnSize)

                // Display
                Text("\(displayValue)")
                    .font(.largeTitle)
                    .padding()
                
                // Buttons
                HStack {
                    VStack {
                        // Other buttons
                        HStack {
                            ForEach(otherButtons, id: \.self) { item in
                                Button {
                                    self.didTapOthers(button: item)
                                } label: {
                                    if item.rawValue == "AC" {
                                        Text(item.rawValue)
                                            .font(.title)
                                            .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                            .background(.gray)
                                            .foregroundStyle(.white)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: item.rawValue)
                                            .font(.largeTitle)
                                            .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                            .background(.gray)
                                            .foregroundStyle(.white)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            
                            if !isSquare {
                                Button {
                                    isSquare.toggle()
                                } label: {
                                    ZStack {
                                        Image(systemName: "rectangle")
                                            .font(.largeTitle)
                                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                                            .font(.title2.bold())
                                    }
                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                    .background(.gray)
                                    .foregroundStyle(.white)
                                    .clipShape(Circle())
                                }
                            } else {
                                Button {
                                    isSquare.toggle()
                                } label: {
                                    HStack(spacing: -10) {
                                        Image(systemName: "arrow.left.to.line.compact")
                                        Image(systemName: "arrow.right.to.line.compact")
                                    }
                                    .font(.title2.bold())
                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                    .background(.gray)
                                    .foregroundStyle(.white)
                                    .clipShape(Circle())
                                }
                            }
                        }
                        // Number buttons
                        if !isFraction {
                            ForEach(numberButtons, id: \.self) { rows in
                                HStack {
                                    ForEach(rows, id: \.self) { item in
                                        Button {
                                            self.didTapNumbers(button: item)
                                        } label: {
                                            Text(item.rawValue)
                                                .font(.title)
                                                .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                                .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                                .foregroundStyle(.white)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                        } else {
                            ForEach(numberFractionButtons, id: \.self) { rows in
                                HStack {
                                    ForEach(rows, id: \.self) { item in
                                        if item.rawValue == "◻︎/16" {
                                            Menu {
                                                ForEach(numeratorOf16s, id: \.self) { numerator in
                                                    Button("\(numerator)/16", action: {
                                                        didTapSixteenth(numeratorOf: numerator)
                                                    })
                                                }
                                            } label: {
                                                Text("◻︎/16")
                                                    .font(.title)
                                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                                    .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                                    .foregroundStyle(.white)
                                                    .clipShape(Circle())
                                            }
                                        } else if item.rawValue == "◻︎/32" {
                                            Menu {
                                                ForEach(numeratorOf32s, id: \.self) { numerator in
                                                    Button("\(numerator)/32", action: {
                                                        didTapThirtysecond(numeratorOf: numerator)
                                                    })
                                                }
                                            } label: {
                                                Text("◻︎/32")
                                                    .font(.title)
                                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                                    .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                                    .foregroundStyle(.white)
                                                    .clipShape(Circle())
                                            }
                                        } else {
                                            Button {
                                                self.didTapFractions(button: item)
                                            } label: {
                                                Text(item.rawValue)
                                                    .font(.title)
                                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                                    .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                                    .foregroundStyle(.white)
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Unit buttons
                    if !isSquare {
                        VStack {
                            ForEach(unitButtons, id: \.self) { item in
                                Button {
                                    self.didTapUnits(button: item)
                                } label: {
                                    Text(item.rawValue)
                                        .font(.title)
                                        .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                        .background(Color(red: 0.6, green: 0.1, blue: 0.9))
                                        .foregroundStyle(.white)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    } else {
                        VStack {
                            ForEach(unitSquareButtons, id: \.self) { item in
                                Button {
                                    self.didTapSquares(button: item)
                                } label: {
                                    Text(item.rawValue)
                                        .font(.title)
                                        .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                        .background(Color(red: 0.1, green: 0.4, blue: 0.8))
                                        .foregroundStyle(.white)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    
                    // Calculate buttons
                    VStack {
                        ForEach(calculateButtons, id: \.self) { item in
                            Button {
                                self.didTapCalculates(button: item)
                            } label: {
                                Image(systemName: item.rawValue)
                                    .font(.largeTitle)
                                    .frame(width: deviceWidth/5.5, height: deviceWidth/5.5)
                                    .background(item.rawValue == returnCurrentOperation() ? .white : .orange)
                                    .foregroundStyle(item.rawValue == returnCurrentOperation() ? .orange : .white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
    
    func didTapOthers(button: OtherButtons) {
        switch button {
        case .allclear:
            displayValue = "0"
            value1 = ""
            value2 = ""
            inputValue = ""
            computedValue = 0.0
            unitOfNumber = .none
            unitOfFormula = .none
            currentOperation = .none
            isFraction = false
            isSquare = false
            isInputValue2 = false
        case .delete:
            if unitOfFormula == .error {
                break
            } else if unitOfNumber == .none {
                if !isInputValue2 {
                    if displayValue.contains("/") {
                        displayValue = value1
                    } else if value1.count == 1 {
                        value1 = "0"
                        displayValue = value1
                    } else {
                        value1 = String(value1.dropLast())
                        displayValue = value1
                    }
                }
            } else if unitOfNumber == .feet {
                if value2.isEmpty {
                    unitOfNumber = .none
                    displayValue = value1
                    isInputValue2 = false
                } else if displayValue.contains("/") {
                    displayValue = "\(value1) ft \(value2)"
                } else if value2.count == 1 {
                    value2 = ""
                    displayValue = "\(value1) ft"
                } else {
                    value2 = String(value2.dropLast())
                    displayValue = "\(value1) ft \(value2)"
                }
            } else if unitOfNumber == .ftin {
                unitOfNumber = .feet
                displayValue = "\(value1) ft \(value2)"
            } else {
                unitOfNumber = .none
                displayValue = value1
            }
        }
    }
    
    func didTapNumbers(button: NumberButtons) {
        let number = button.rawValue
        switch button {
        case .decimal:
            if unitOfFormula == .error {
                break
            } else if !isInputValue2 {
                if value1.contains(".") {
                    break
                } else if value1.isEmpty {
                    value1 = "0."
                    displayValue = value1
                } else {
                    value1 = "\(value1)."
                    displayValue = value1
                }
            } else {
                if value2.contains(".") {
                    break
                } else if value2.isEmpty {
                    value2 = "0."
                    displayValue = "\(value1) ft \(value2)"
                } else {
                    value2 = "\(value2)."
                    displayValue = "\(value1) ft \(value2)"
                }
            }
        case .fraction:
            if unitOfFormula == .error {
                break
            } else {
                isFraction.toggle()
            }
        default:
            if unitOfFormula == .error || (unitOfNumber != .none && unitOfNumber != .feet) {
                break
            } else if currentOperation == .equal {
                value1 = number
                value2 = ""
                displayValue = value1
                computedValue = 0.0
                unitOfNumber = .none
                unitOfFormula = .none
                currentOperation = .none
                isSquare = false
                isInputValue2 = false
                isFraction = false
            } else if isInputValue2 && (value2 == "" || value2 == "0") {
                value2 = number
                displayValue = "\(displayValue) \(value2)"
            } else if isInputValue2 {
                value2 = "\(value2)\(number)"
                displayValue = "\(displayValue)\(number)"
            } else if !isInputValue2 && (value1 == "" || value1 == "0") {
                value1 = number
                displayValue = value1
            } else {
                value1 = "\(value1)\(number)"
                displayValue = "\(displayValue)\(number)"
            }
        }
    }
    
    func didTapFractions(button: NumberFractionButtons) {
        switch button {
        case .zero:
            if unitOfFormula == .error || (unitOfNumber != .none && unitOfNumber != .feet) {
                break
            } else if currentOperation == .equal {
                value1 = "0"
                value2 = ""
                displayValue = value1
                computedValue = 0.0
                unitOfNumber = .none
                unitOfFormula = .none
                currentOperation = .none
                isSquare = false
                isInputValue2 = false
                isFraction = false
            } else if isInputValue2 && (value2 == "" || value2 == "0") {
                value2 = "0"
                displayValue = "\(displayValue) \(value2)"
            } else if isInputValue2 {
                value2 = "\(value2)0"
                displayValue = "\(displayValue)0"
            } else if !isInputValue2 && (value1 == "" || value1 == "0") {
                value1 = "0"
                displayValue = value1
            } else {
                value1 = "\(value1)0"
                displayValue = "\(displayValue)0"
            }
        case .decimal:
            if unitOfFormula == .error {
                break
            } else if !isInputValue2 {
                if value1.contains(".") {
                    break
                } else if value1.isEmpty {
                    value1 = "0."
                    displayValue = value1
                } else {
                    value1 = "\(value1)."
                    displayValue = value1
                }
            } else {
                if value2.contains(".") {
                    break
                } else if value2.isEmpty {
                    value2 = "0."
                    displayValue = "\(value1) ft \(value2)"
                } else {
                    value2 = "\(value2)."
                    displayValue = "\(value1) ft \(value2)"
                }
            }
        case .oneeighth:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 1/8"
                } else {
                    displayValue = "\(value1) 1/8"
                }
            }
        case .quarter:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 1/4"
                } else {
                    displayValue = "\(value1) 1/4"
                }
            }
        case .threeeighth:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 3/8"
                } else {
                    displayValue = "\(value1) 3/8"
                }
            }
        case .half:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 1/2"
                } else {
                    displayValue = "\(value1) 1/2"
                }
            }
        case .fiveeighth:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 5/8"
                } else {
                    displayValue = "\(value1) 5/8"
                }
            }
        case .threequarter:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 3/4"
                } else {
                    displayValue = "\(value1) 3/4"
                }
            }
        case .seveneighth:
            if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) {
                break
            } else {
                if isInputValue2 {
                    displayValue = "\(value1) ft \(value2) 7/8"
                } else {
                    displayValue = "\(value1) 7/8"
                }
            }
        case .fraction:
            if unitOfFormula == .error {
                break
            } else {
                isFraction.toggle()
            }
        default:
            break
        }
    }
    
    func didTapSixteenth(numeratorOf: Int) {
        if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) { } else {
            if isInputValue2 {
                displayValue = "\(value1) ft \(value2) \(String(numeratorOf))/16"
            } else {
                displayValue = "\(value1) \(String(numeratorOf))/16"
            }
        }
    }
    
    func didTapThirtysecond(numeratorOf: Int) {
        if unitOfFormula == .error || (unitOfNumber != .feet && unitOfNumber != .none) || (unitOfNumber == .none && value1.contains(".")) || (unitOfNumber == .feet && value2.contains(".")) { } else {
            if isInputValue2 {
                displayValue = "\(value1) ft \(value2) \(String(numeratorOf))/32"
            } else {
                displayValue = "\(value1) \(String(numeratorOf))/32"
            }
        }
    }
    
    func didTapUnits(button: UnitButtons) {
        switch button {
        case .mile:
            if unitOfFormula == .error || unitOfNumber == .mile || (value1 == "" || value1 == "0") || (unitOfNumber == .none && displayValue.contains("/")) {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .mile
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .mile
                displayValue = "\(value1) mi"
                value2 = ""
            }
            isInputValue2 = false
        case .yard:
            if unitOfFormula == .error || unitOfNumber == .yard || (value1 == "" || value1 == "0")  || (unitOfNumber == .none && displayValue.contains("/")) {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .yard
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .yard
                displayValue = "\(value1) yd"
                value2 = ""
            }
            isInputValue2 = false
        case .ftin:
            if currentOperation == .equal {
                unitOfNumber = .ftin
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .feet
                displayValue = "\(value1) ft"
                value2 = ""
            }
        case .feet:
            if unitOfFormula == .error || unitOfNumber == .feet || (unitOfNumber != .ftin && (value1 == "" || value1 == "0")) || (unitOfNumber == .none && displayValue.contains("/")) {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .feet
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .feet
                displayValue = "\(value1) ft"
                value2 = ""
            }
            isInputValue2 = true
        case .inch:
            if unitOfFormula == .error || unitOfNumber == .inch || (value1 == "" || value1 == "0") {
                break
            } else if unitOfNumber == .feet  && !value2.isEmpty {
                if displayValue.contains("/") {
                    unitOfNumber = .ftin
                    displayValue = "\(displayValue) in"
                    value2 = String((Double(value2) ?? 0) + getValueFromFraction())
                } else {
                    unitOfNumber = .ftin
                    displayValue = "\(value1) ft \(value2) in"
                }
            } else if currentOperation == .equal {
                unitOfNumber = .inch
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                if displayValue.contains("/") {
                    unitOfNumber = .inch
                    displayValue = "\(displayValue) in"
                    value1 = String((Double(value1) ?? 0) + getValueFromFraction())
                } else {
                    unitOfNumber = .inch
                    displayValue = "\(value1) in"
                    value2 = ""
                }
            }
            isInputValue2 = false
        }
    }
    
    func didTapSquares(button: UnitSquareButtons) {
        switch button {
        case .mile2:
            if unitOfFormula == .error || unitOfNumber == .mile2 || (value1 == "" || value1 == "0") || displayValue.contains("/") {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .mile2
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .mile2
                displayValue = "\(value1) mi²"
                value2 = ""
            }
            isInputValue2 = false
        case .acre:
            if unitOfFormula == .error || unitOfNumber == .acre || (value1 == "" || value1 == "0") || displayValue.contains("/") {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .acre
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .acre
                displayValue = "\(value1) acre"
                value2 = ""
            }
            isInputValue2 = false
        case .yard2:
            if unitOfFormula == .error || unitOfNumber == .yard2 || (value1 == "" || value1 == "0") || displayValue.contains("/") {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .yard2
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .yard2
                displayValue = "\(value1) yd²"
                value2 = ""
            }
            isInputValue2 = false
        case .feet2:
            if unitOfFormula == .error || unitOfNumber == .feet2 || (value1 == "" || value1 == "0") || displayValue.contains("/") {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .feet2
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .feet2
                displayValue = "\(value1) ft²"
                value2 = ""
            }
            isInputValue2 = false
        case .inch2:
            if unitOfFormula == .error || unitOfNumber == .inch || (value1 == "" || value1 == "0") || displayValue.contains("/") {
                break
            } else if currentOperation == .equal {
                unitOfNumber = .inch2
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
            } else {
                unitOfNumber = .inch2
                displayValue = "\(value1) in²"
                value2 = ""
            }
            isInputValue2 = false
        }
    }
    
    func didTapCalculates(button: CalculateButtons) {
        switch button {
        case .add:
            if unitOfFormula == .error {
                break
            } else {
                switch currentOperation {
                case .add:
                    break
                default:
                    inputValue = "\(displayValue) +"
                    didAfterTapCalculate()
                    currentOperation = .add
                }
            }
        case .minus:
            if unitOfFormula == .error {
                break
            } else {
                switch currentOperation {
                case .minus:
                    break
                default:
                    inputValue = "\(displayValue) -"
                    didAfterTapCalculate()
                    currentOperation = .minus
                }
            }
        case .multiply:
            if unitOfFormula == .error {
                break
            } else {
                switch currentOperation {
                case .multiply:
                    break
                default:
                    inputValue = "\(displayValue) ×"
                    didAfterTapCalculate()
                    currentOperation = .multiply
                }
            }
        case .divide:
            if unitOfFormula == .error {
                break
            } else {
                switch currentOperation {
                case .divide:
                    break
                default:
                    inputValue = "\(displayValue) ÷"
                    didAfterTapCalculate()
                    currentOperation = .divide
                }
            }
        case .equal:
            if unitOfFormula == .error || currentOperation == .equal || currentOperation == .none {
                break
            } else {
                switch currentOperation {
                case .add:
                    computedValue += getProcessValue()
                    unitOfFormula = unitOfFormulaFromPlusMinus()
                case .minus:
                    computedValue -= getProcessValue()
                    unitOfFormula = unitOfFormulaFromPlusMinus()
                case .multiply:
                    computedValue *= getProcessValue()
                    unitOfFormula = unitOfFormulaFromMultiplyDivide()
                case .divide:
                    computedValue /= getProcessValue()
                    unitOfFormula = unitOfFormulaFromMultiplyDivide()
                default:
                    break
                }
                
                inputValue = "\(inputValue) \(displayValue)"
                currentOperation = .equal
                unitOfNumber = unitOfFormula
                (displayValue, value1, value2) = getConvertedValue(value: computedValue)
                
                if unitOfNumber == .mile2 || unitOfNumber == .acre || unitOfNumber == .yard2 || unitOfNumber == .feet2 || unitOfNumber == .inch2 {
                    isSquare = true
                }
                
                inputValue = "\(inputValue) = \(displayValue)"
                pastFormulas.append(inputValue)
                inputValue = ""
            }
        }
    }
    
    func getProcessValue() -> Double {
        var processValue = 0.0
        
        switch unitOfNumber {
        case .mile:
            processValue = (Double(value1) ?? 0) * 63_360
        case .yard:
            processValue = (Double(value1) ?? 0) * 36
        case .ftin:
            processValue = (Double(value1) ?? 0) * 12 + (Double(value2) ?? 0)
        case .feet:
            processValue = (Double(value1) ?? 0) * 12
        case .inch:
            processValue = Double(value1) ?? 0
        case .mile2:
            processValue = (Double(value1) ?? 0) * 4_014_489_600
        case .acre:
            processValue = (Double(value1) ?? 0) * 6_272_640
        case .yard2:
            processValue = (Double(value1) ?? 0) * 1_296
        case .feet2:
            processValue = (Double(value1) ?? 0) * 144
        case .inch2:
            processValue = Double(value1) ?? 0
        case .none:
            processValue = Double(value1) ?? 0
        case .error:
            break
        }
        
        return processValue
    }
    
    func getConvertedValue(value: Double) -> (String, String, String) {
        var convertedValue = ""
        var v1 = ""
        var v2 = ""
        
        var _mi = 0.0
        var _yd = 0.0
        var _ft = 0.0
        var _in = 0.0
        var _inFractionValue = 0.0
        var _inFraction = ""
        var _mi2 = 0.0
        var _acre = 0.0
        var _yd2 = 0.0
        var _ft2 = 0.0
        var _in2 = 0.0
        
        switch unitOfNumber {
        case .none:
            convertedValue = value.formatted()
        case .mile:
            _mi = (value / 63360)
            convertedValue = "\(_mi.formatted()) mi"
            v1 = String(_mi.formatted())
        case .yard:
            _yd = (value / 36)
            convertedValue = "\(_yd.formatted()) yd"
            v1 = String(_yd.formatted())
        case .ftin:
            _ft = floor(value / 12)
            _in = floor(value.truncatingRemainder(dividingBy: 12))
            _inFractionValue = value.truncatingRemainder(dividingBy: 1)
            if _inFractionValue < 0.0625 {
                _inFraction = ""
            } else if _inFractionValue < 0.1875 {
                _inFraction = " 1/8"
            } else if _inFractionValue < 0.3125 {
                _inFraction = " 1/4"
            } else if _inFractionValue < 0.4375 {
                _inFraction = " 3/8"
            } else if _inFractionValue < 0.5625 {
                _inFraction = " 1/4"
            } else if _inFractionValue < 0.6875 {
                _inFraction = " 5/8"
            } else if _inFractionValue < 0.8125 {
                _inFraction = " 3/4"
            } else if _inFractionValue < 0.9375 {
                _inFraction = " 7/8"
            } else {
                _inFraction = ""
            }
            convertedValue = "\(_ft.formatted()) ft \(_in.formatted())\(_inFraction) in"
            v1 = String(_ft.formatted())
            v2 = String(_in.formatted())
        case .feet:
            _ft = (value / 12)
            convertedValue = "\(_ft.formatted()) ft"
            v1 = String(_ft.formatted())
        case .inch:
            _in = value
            convertedValue = "\(_in.formatted()) in"
            v1 = String(_in.formatted())
        case .mile2:
            _mi2 = (value / 4_014_489_600)
            convertedValue = "\(_mi2.formatted()) mi²"
            v1 = String(_mi2.formatted())
        case .acre:
            _acre = (value / 6_272_640)
            convertedValue = "\(_acre.formatted()) Acre"
            v1 = String(_acre.formatted())
        case .yard2:
            _yd2 = (value / 1_296)
            convertedValue = "\(_yd2.formatted()) yd²"
            v1 = String(_yd2.formatted())
        case .feet2:
            _ft2 = (value / 144)
            convertedValue = "\(_ft2.formatted()) ft²"
            v1 = String(_ft2.formatted())
        case .inch2:
            _in2 = value
            convertedValue = "\(_in2.formatted()) in²"
            v1 = String(_in2.formatted())
        case .error:
            convertedValue = "Error"
        }
        
        return (convertedValue, v1, v2)
    }
    
    func unitOfFormulaFromPlusMinus() -> UnitOfNumber {
        if (unitOfFormula == .none && unitOfNumber != .none) || (unitOfFormula != .none && unitOfNumber == .none) {
            unitOfFormula = .error
        } else if ((unitOfFormula == .inch2 || unitOfFormula == .feet2 || unitOfFormula == .yard2 || unitOfFormula == .acre || unitOfFormula == .mile2) && (unitOfNumber == .inch || unitOfNumber == .feet || unitOfNumber == .ftin || unitOfNumber == .yard || unitOfNumber == .mile)) || ((unitOfFormula == .inch || unitOfFormula == .feet || unitOfFormula == .ftin || unitOfFormula == .yard || unitOfFormula == .mile) && (unitOfNumber == .inch2 || unitOfNumber == .feet2 || unitOfNumber == .yard2 || unitOfNumber == .acre || unitOfNumber == .mile2)) {
            unitOfFormula = .error
        } else if unitOfFormula == .none && unitOfNumber == .none {
            unitOfFormula = .none
        } else if unitOfFormula == .inch && unitOfNumber == .inch {
            unitOfFormula = .inch
        } else if unitOfFormula == .inch || unitOfNumber == .inch || unitOfFormula == .ftin || unitOfNumber == .ftin {
            unitOfFormula = .ftin
        } else if unitOfFormula == .feet || unitOfNumber == .feet {
            unitOfFormula = .feet
        } else if unitOfFormula == .yard || unitOfNumber == .yard {
            unitOfFormula = .yard
        } else if unitOfFormula == .mile && unitOfNumber == .mile {
            unitOfFormula = .mile
        } else if unitOfFormula == .inch2 || unitOfNumber == .inch2 {
            unitOfFormula = .inch2
        } else if unitOfFormula == .feet2 || unitOfNumber == .feet2 {
            unitOfFormula = .feet2
        } else if unitOfFormula == .yard2 || unitOfNumber == .yard2 {
            unitOfFormula = .feet2
        } else if unitOfFormula == .acre || unitOfNumber == .acre {
            unitOfFormula = .acre
        } else if unitOfFormula == .mile2 && unitOfNumber == .mile2 {
            unitOfFormula = .mile2
        }
        
        return unitOfFormula
    }
    
    func unitOfFormulaFromMultiplyDivide() -> UnitOfNumber {
        if ((unitOfFormula == .inch2 || unitOfFormula == .feet2 || unitOfFormula == .yard2 || unitOfFormula == .acre || unitOfFormula == .mile2) && (unitOfNumber == .inch || unitOfNumber == .feet || unitOfNumber == .ftin || unitOfNumber == .yard || unitOfNumber == .mile || unitOfNumber == .inch2 || unitOfNumber == .feet2 || unitOfNumber == .yard2 || unitOfNumber == .acre || unitOfNumber == .mile2)) || ((unitOfFormula == .inch || unitOfFormula == .feet || unitOfFormula == .ftin || unitOfFormula == .yard || unitOfFormula == .mile) && (unitOfNumber == .inch2 || unitOfNumber == .feet2 || unitOfNumber == .yard2 || unitOfNumber == .acre || unitOfNumber == .mile2)) {
            unitOfFormula = .error
        } else if unitOfFormula == .none && unitOfNumber == .none {
            unitOfFormula = .none
        } else if unitOfFormula == .none {
            unitOfFormula = unitOfNumber
        } else if unitOfNumber == .none {
            unitOfFormula = unitOfFormula
        } else if unitOfFormula == .inch || unitOfNumber == .inch {
            unitOfFormula = .inch2
        } else if unitOfFormula == .feet || unitOfFormula == .ftin || unitOfNumber == .feet || unitOfNumber == .ftin {
            unitOfFormula = .feet2
        } else if unitOfFormula == .yard || unitOfNumber == .yard {
            unitOfFormula = .yard
        } else if unitOfFormula == .mile && unitOfNumber == .mile {
            unitOfFormula = .mile
        }
        
        return unitOfFormula
    }
    
    func getValueFromFraction() -> Double {
        if displayValue.contains("1/2") {
            return 0.5
        } else if displayValue.contains("1/4") {
            return 0.25
        } else if displayValue.contains("3/4") {
            return 0.75
        } else if displayValue.contains("1/8") {
            return 0.125
        } else if displayValue.contains("3/8") {
            return 0.375
        } else if displayValue.contains("5/8") {
            return 0.675
        } else if displayValue.contains("7/8") {
            return 0.875
        } else if displayValue.contains("1/16") {
            return 0.0625
        } else if displayValue.contains("3/16") {
            return 0.1875
        } else if displayValue.contains("5/16") {
            return 0.3125
        } else if displayValue.contains("7/16") {
            return 0.4375
        } else if displayValue.contains("9/16") {
            return 0.5625
        } else if displayValue.contains("11/16") {
            return 0.6875
        } else if displayValue.contains("13/16") {
            return 0.8125
        } else if displayValue.contains("15/16") {
            return 0.9375
        } else if displayValue.contains("1/32") {
            return 0.03125
        } else if displayValue.contains("3/32") {
            return 0.09375
        } else if displayValue.contains("5/32") {
            return 0.15625
        } else if displayValue.contains("7/32") {
            return 0.21875
        } else if displayValue.contains("9/32") {
            return 0.28125
        } else if displayValue.contains("11/32") {
            return 0.34375
        } else if displayValue.contains("13/32") {
            return 0.40625
        } else if displayValue.contains("15/32") {
            return 0.46875
        } else if displayValue.contains("17/32") {
            return 0.53125
        } else if displayValue.contains("19/32") {
            return 0.59375
        } else if displayValue.contains("21/32") {
            return 0.65625
        } else if displayValue.contains("23/32") {
            return 0.71875
        } else if displayValue.contains("25/32") {
            return 0.78125
        } else if displayValue.contains("27/32") {
            return 0.84375
        } else if displayValue.contains("29/32") {
            return 0.90625
        } else if displayValue.contains("31/32") {
            return 0.09375
        } else {
            return 0
        }
    }
    
    func returnCurrentOperation() -> String {
        if currentOperation == .add {
            return "plus"
        } else if currentOperation == .minus {
            return "minus"
        } else if currentOperation == .multiply {
            return "multiply"
        } else if currentOperation == .divide {
            return "divide"
        } else if currentOperation == .equal {
            return "equal"
        } else {
            return ""
        }
    }
    
    func didAfterTapCalculate() {
        if currentOperation != .equal {
            computedValue = getProcessValue()
        }
        value1 = ""
        value2 = ""
        unitOfFormula = unitOfNumber
        unitOfNumber = .none
        isFraction = false
        isSquare = false
        isInputValue2 = false
    }
}

#Preview {
    ContentView()
}
