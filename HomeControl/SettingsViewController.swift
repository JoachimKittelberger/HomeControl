//
//  SettingsViewController.swift
//  HomeControl
//
//  Created by Joachim Kittelberger on 15.06.17.
//  Copyright © 2017 Joachim Kittelberger. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ipAdress: UITextField!
    @IBOutlet weak var sendPort: UITextField!
    @IBOutlet weak var receivePort: UITextField!

    private var oldIpAdress: String!
    private var oldSendPort: UInt16!
    private var oldReceivePort: UInt16!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeControlConnection = Jet32.sharedInstance

        oldIpAdress = homeControlConnection.host
        oldSendPort = homeControlConnection.udpPortSend
        oldReceivePort = homeControlConnection.udpPortReceive

        ipAdress.text = oldIpAdress
        sendPort.text = String(oldSendPort)
        receivePort.text = String(oldReceivePort)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let homeControlConnection = Jet32.sharedInstance
        var hasSettingsChanged: Bool = false

        if let send = UInt16(sendPort.text!),
                let receive = UInt16(receivePort.text!),
                let ip = ipAdress.text {
            if (oldIpAdress != ip) {
                homeControlConnection.host = ip
                hasSettingsChanged = true
            }
            if (oldSendPort != send) {
                homeControlConnection.udpPortSend = send
                hasSettingsChanged = true
            }
            if (oldReceivePort != receive) {
                homeControlConnection.udpPortReceive = receive
                hasSettingsChanged = true
            }

            if hasSettingsChanged {
                // reconnect
                homeControlConnection.disconnect()
                homeControlConnection.connect()
                
            }
        }

        
    }
    
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
