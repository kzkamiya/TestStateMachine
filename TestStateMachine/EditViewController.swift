//
//  EditViewController.swift
//  TestStateMachine
//
//  Created by me on 2018/04/08.
//  Copyright © 2018年 me. All rights reserved.
//

import Foundation

class EditViewController: StateMachineDelegate {
    
    enum EditState {
        /// 入力中
        case editing
        /// 確認中
        case confirming
        /// 保存中
        case saving
        /// 保存後
        case saved(SaveResult)
    }
    
    enum EditEvent {
        /// 保存
        case save
        /// 確認(OK/NG)
        case confirm(Bool)
        /// 保存終了
        case finishSave(SaveResult)
        /// 結果表示
        case shownResult
    }
    
    enum SaveResult {
        case success
        case fail(Error)
    }
    
    enum SaveError: Error {
        case invalidSelection
        case outOfStock
    }
    
    init() {
        // 状態遷移を定義
        self.state = StateMachine<EditState, EditEvent>(.editing) { (state, event) in
            switch (state, event) {
            // 入力中 --> 確認中 : 保存
            case (.editing, .save):
                return .confirming
            // 確認中 --> 保存中 : 確認OK
            case (.confirming, .confirm(true)):
                return .saving
            // 確認中 --> 入力中 : 確認NG
            case (.confirming, .confirm(false)):
                return .editing
            // 保存中 --> 保存後 : 保存終了
            case (.saving, .finishSave(let result)):
                return .saved(result)
            // 保存終了 --> 入力中 : 結果表示
            case (.saved, .shownResult):
                return .editing
            default:
                return nil
            }
        }
        state.delegate = self
    }
    
    var state: StateMachine<EditState, EditEvent>
    
    //MARK:-状態変化のアクション
    func stateMachine<State, Event>(_ stateMachine: StateMachine<State, Event>, notified change: StateChange<State>) {
        let c = change as! StateChange<EditState>
        switch c {
        case .didEnter(.confirming):
            self.didEnterConfirming()
        case .didEnter(.saving):
            self.didEnterSaving()
        case .didEnter(.saved(let result)):
            self.didEnterSaved(result: result)
        default:
            break
        }
    }
    
    //MARK:-入力イベント
    // 保存ボタンのタップイベント
    func tapSaveButton() {
        Logger.debug("保存ボタンを押す")
        state.transition(.save)
    }
    
    // 確認ダイアログのOKを押すイベント
    func tapConfirmOKButton() {
        Logger.debug("確認ダイアログでOKボタンを押す")
        state.transition(.confirm(true))
    }
    
    // 確認ダイアログのCancelを押すイベント
    func tapConfirmCancelButton() {
        Logger.debug("確認ダイアログでCancelボタンを押す")
        state.transition(.confirm(false))
    }

    // 保存成功コールバック受信
    func callBackSucessFromSavedAction() {
        Logger.debug("保存成功コールバック受信")
        state.transition(.finishSave(SaveResult.success))
    }

    // 保存失敗コールバック受信
    func callBackErrorFromSavedAction() {
        Logger.debug("保存失敗コールバック受信")
        state.transition(.finishSave(SaveResult.fail(SaveError.outOfStock)))
    }
    
    // 現在のステータスをデバッグ表示
    func showDebugCurrentState() {
        state.showDebugCurrentState()
    }
    
    //MARK:-内部処理
    private func didEnterConfirming() {
        Logger.debug("確認ダイアログを表示する")
    }
    
    private func didEnterSaving() {
        Logger.debug("保存処理を開始する")
    }
    
    private func didEnterSaved(result: SaveResult) {
        switch result {
        case .success:
            Logger.debug("保存に成功したことを表示する")
            break
        case .fail(let error):
            Logger.warn("Errored. \(error)")
            break
        }
        
        state.transition(.shownResult)
    }
}
