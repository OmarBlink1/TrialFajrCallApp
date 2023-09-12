//
//  ViewController.swift
//  TrialFajrCallApp
//
//  Created by Blinnk22 User on 12/09/2023.
//

//import UIKit
//
//class ViewController: UIViewController {
//        @IBOutlet var myView: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        start_system()
//        // Do any additional setup after loading the view.
//    }
//    func start_system() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//            let callManager = CallManager()
//            callManager.VC = self
//            let id = UUID()
//            callManager.reportIncomingCalls(id: id, handle: "Fajr alarm")
//        })
//    }
//
//}

// // //Incoming Call
import UIKit
import CallKit

class ViewController: UIViewController, CXProviderDelegate {

    @IBOutlet var myView: UIView!
    override func viewDidLoad() {
        // 1: Create an incoming call update object. This object stores different types of information about the caller. You can use it in setting whether the call has a video.
        let update = CXCallUpdate()

        // Specify the type of information to display about the caller during an incoming call. The different types of information available include `.generic`. For example, you could use the caller&#039;s name for the generic type. During an incoming call, the name displays to the other user. Other available information types are emails and phone numbers.
        update.remoteHandle = CXHandle(type: .generic, value: "Amos Gyamfi")
       //update.remoteHandle = CXHandle(type: .emailAddress, value: "amosgyamfi@gmail.com")
        //update.remoteHandle = CXHandle(type: .phoneNumber, value: "a+35846599990")

        // 2: Create and set configurations about how the calling application should behave
        let config = CallKit.CXProviderConfiguration()

        // Provide a custom ringtone
//        config.ringtoneSound = "ES_CellRingtone23.mp3";

        // 3: Create a CXProvider instance and set its delegate
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)

       // 4. Post local notification to the user that there is an incoming call. When using CallKit, you do not need to rely on only displaying incoming calls using the local notification API because it helps to show incoming calls to users using the native full-screen incoming call UI on iOS. Add the helper method below `reportIncomingCall` to show the full-screen UI. It must contain `UUID()` that helps to identify the caller using a random identifier. You should also provide the `CXCallUpdate` that comprises metadata information about the incoming call. You can also check for errors to see if everything works fine.
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in
            if let error = error {
                print("failed to report new incoming call")
            }
            else {
                print("reporting new incoming call")
            }
        })
    }

    func providerDidReset(_ provider: CXProvider) {
    }

    // What happens when the user accepts the call by pressing the incoming call button? You should implement the method below and call the fulfill method if the call is successful.
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("user accepts a call")
        self.present(FAJR_AlarmViewController(), animated: false)
        action.fulfill()
        return
    }

    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("user declines a call")

        self.present(FAJR_AlarmViewController(), animated: false)
        action.fail()
        return
    }

}
