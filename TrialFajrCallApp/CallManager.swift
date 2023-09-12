//
//  CallManager.swift
//  TrialFajrCallApp
//
//  Created by Blinnk22 User on 12/09/2023.
//

import Foundation
import CallKit
import UIKit

final class CallManager : NSObject, CXProviderDelegate {
    
    var VC : UIViewController!
    let provider = CXProvider(configuration:  CXProviderConfiguration())
    let callController = CXCallController()
    override init() {
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    func providerDidReset(_ provider: CXProvider) {
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("user accepts a call")
        VC.present(FAJR_AlarmViewController(), animated: false)
        action.fulfill()
        return
    }

    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("user declines a call")

        VC.present(FAJR_AlarmViewController(), animated: false)
        action.fail()
        return
    }
    public func reportIncomingCalls(id : UUID , handle : String)
    {
        print("Incoming call func starteed")

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        
        provider.reportNewIncomingCall(with: id, update: update) { Error in
            if let Error = Error {
                dump(Error)
            }
            else {
                print("New Incoming Call is not blocked by system")
            }
        }
    }
    
    public func startCall(id : UUID , handle : String){
        print("Start call func started")
        let action = CXStartCallAction(call: id, handle: CXHandle(type: .generic, value: handle))
        let transaction = CXTransaction(action: action)
        callController.request(transaction) { Error in
            if let Error = Error {
            dump(Error)
        }
        else {
            print("Call started")
        }
        }
    }
}
