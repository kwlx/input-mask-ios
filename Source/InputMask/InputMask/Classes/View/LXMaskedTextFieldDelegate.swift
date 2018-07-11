//
//  LXMaskedTextFieldDelegate.swift
//  InputMask
//
//  Created by Kamila Witecka on 10.07.2018.
//  Copyright © 2018 Egor Taflanidi. All rights reserved.
//

import Foundation

open class LXMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    private var _extractedValue: String = ""

    override open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let extractedValue: String
        let complete:       Bool

        if isDeletion(
            inField: textField,
            string: string
            ) {
            let newRange = self.mask.changeRange(range)
            (extractedValue, complete) = self.deleteText(inRange: newRange, inField: textField)
        } else {
            if let text = textField.text, !self.mask.shouldModifyText(text, inRange: range, withText: string) {
                setCaretPosition(range.location, inField: textField)
                extractedValue = _extractedValue
                complete = true
            } else {
                (extractedValue, complete) = self.modifyText(inRange: range, inField: textField, withText: string)
            }
        }

        self._extractedValue = extractedValue
        self.listener?.textField?(
            textField,
            didFillMandatoryCharacters: complete,
            didExtractValue: extractedValue
        )
        let _ = self.listener?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
}

internal extension LXMaskedTextFieldDelegate {
    func isDeletion(inField field: UITextField, string: String) -> Bool {
        if let selectedTextRange = field.selectedTextRange {
            let length = field.offset(from: selectedTextRange.start, to: selectedTextRange.end)
            if length > 0 {
                return false
            }
        }
        return 0 == string.count
    }
}
