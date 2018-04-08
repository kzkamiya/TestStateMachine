//
//  main.swift
//  TestStateMachine
//
//  Created by me on 2018/04/08.
//  Copyright © 2018年 me. All rights reserved.
//

import Foundation

print("Hello, StateMachine World!")

var editViewController = EditViewController()

// 現在のステータスをデバッグ表示
editViewController.showDebugCurrentState()

// セーブボタンを押す。
editViewController.tapSaveButton()
// 確認ダイアログのキャンセルを押す。
editViewController.tapConfirmCancelButton()

// セーブボタンを押す。
editViewController.tapSaveButton()
// 確認ダイアログのOKを押す。
editViewController.tapConfirmOKButton()
// 保存成功
editViewController.callBackSucessFromSavedAction()

// セーブボタンを押す。
editViewController.tapSaveButton()
// 確認ダイアログのOKを押す。
editViewController.tapConfirmOKButton()
// 保存失敗
editViewController.callBackErrorFromSavedAction()


// セーブボタンを押す。
editViewController.tapSaveButton()
// 確認ダイアログを押していないので、保存失敗処理は無効
// 保存失敗
editViewController.callBackErrorFromSavedAction()
// 確認ダイアログのOKを押す。
editViewController.tapConfirmOKButton()
// 保存成功
editViewController.callBackSucessFromSavedAction()

// 現在のステータスをデバッグ表示
editViewController.showDebugCurrentState()





