//
//  PLCViewController.swift
//  HomeControl
//
//  Created by Joachim Kittelberger on 16.06.17.
//  Copyright © 2017 Joachim Kittelberger. All rights reserved.
//

import UIKit

class PLCViewController: UIViewController {

    var homeConnection = Jet32.sharedInstance
 
    enum PLCViewControllerTag: UInt32 {
        case readSecond
        case readMinute
        case readHour
        case readHourShutterUp
        case readMinuteShutterUp
        case readHourShutterDown
        case readMinuteShutterDown
        case readHourShutterUpWeekend
        case readMinuteShutterUpWeekend
        
        case readIsAutomaticBlind
        case readIsAutomaticShutter
        case readIsAutomaticSummerMode
    }
    
    
    var hour: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var timer: Timer!       // Timer for reading the PLC Time
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func setTimeButton(_ sender: Any) {
        writeCurrtenTimeToPLC()
    }
    
    @IBOutlet weak var hourShutterUp: UITextField!
    @IBOutlet weak var minuteShutterUp: UITextField!
    @IBOutlet weak var hourShutterDown: UITextField!
    @IBOutlet weak var minuteShutterDown: UITextField!
    @IBOutlet weak var hourShutterUpWeekend: UITextField!
    @IBOutlet weak var minuteShutterUpWeekend: UITextField!
    
    @IBOutlet weak var isBlindAutomaticSwitch: UISwitch!
    @IBOutlet weak var isShutterAutomaticSwitch: UISwitch!
    @IBOutlet weak var isShutterSommerPos: UISwitch!
    
    @IBAction func allShuttersUp(_ sender: Any) {
        homeConnection.setFlag(JetGlobalVariables.flagCmdAllAutomaticShuttersUp)
    }

    @IBAction func allShuttersDown(_ sender: Any) {
        homeConnection.setFlag(JetGlobalVariables.flagCmdAllAutomaticShuttersDown)
    }
    
    @IBAction func allShuttersSommerPosUp(_ sender: Any) {
        homeConnection.setFlag(JetGlobalVariables.flagCmdAllAutomaticShuttersUpSummerPos)
    }
    
    @IBAction func allShuttersSommerPosDown(_ sender: Any) {
        homeConnection.setFlag(JetGlobalVariables.flagCmdAllAutomaticShuttersDownSummerPos)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set the IDs of the controls TODO sollte eigentlich nur eimal gemacht werden.
        hourShutterUp.tag = Int(PLCViewControllerTag.readHourShutterUp.rawValue)
        minuteShutterUp.tag = Int(PLCViewControllerTag.readMinuteShutterUp.rawValue)
        hourShutterDown.tag = Int(PLCViewControllerTag.readHourShutterDown.rawValue)
        minuteShutterDown.tag = Int(PLCViewControllerTag.readMinuteShutterDown.rawValue)
        hourShutterUpWeekend.tag = Int(PLCViewControllerTag.readHourShutterUpWeekend.rawValue)
        minuteShutterUpWeekend.tag = Int(PLCViewControllerTag.readMinuteShutterUpWeekend.rawValue)
        
        isBlindAutomaticSwitch.tag = Int(PLCViewControllerTag.readIsAutomaticBlind.rawValue)
        isShutterAutomaticSwitch.tag = Int(PLCViewControllerTag.readIsAutomaticShutter.rawValue)
        isShutterSommerPos.tag = Int(PLCViewControllerTag.readIsAutomaticSummerMode.rawValue)
        
        isBlindAutomaticSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        isShutterAutomaticSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        isShutterSommerPos.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)

        // TODO jk: Müsste eigentlich in viewDidAppear gemacht werden. Ist das erste mal dort aber zu früh
        readTimeFromPLC()
        readTimeSettingsFromPLC()
        readShutterSettingsFromPLC()
    }

 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        homeConnection.setDelegate(delegate: self)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        readTimeFromPLC()
        readTimeSettingsFromPLC()
        readShutterSettingsFromPLC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
        homeConnection.setDelegate(delegate: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onTimer() {
        readTimeFromPLC()
    }
    
    func readTimeFromPLC() {
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regSecond, tag: UInt32(PLCViewControllerTag.readSecond.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regMinute, tag: UInt32(PLCViewControllerTag.readMinute.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regHour, tag: UInt32(PLCViewControllerTag.readHour.rawValue))
    }

    func readTimeSettingsFromPLC() {
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regUpTimeHour, tag: UInt32(PLCViewControllerTag.readHourShutterUp.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regUpTimeMinute, tag: UInt32(PLCViewControllerTag.readMinuteShutterUp.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regDownTimeHour, tag: UInt32(PLCViewControllerTag.readHourShutterDown.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regDownTimeMinute, tag: UInt32(PLCViewControllerTag.readMinuteShutterDown.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regUpTimeHourWeekend, tag: UInt32(PLCViewControllerTag.readHourShutterUpWeekend.rawValue))
        let _ = homeConnection.readIntRegister(JetGlobalVariables.regUpTimeMinuteWeekend, tag: UInt32(PLCViewControllerTag.readMinuteShutterUpWeekend.rawValue))
    }
    
    func readShutterSettingsFromPLC() {
        let _ = homeConnection.readFlag(JetGlobalVariables.flagIsAutomaticBlind, tag: UInt32(PLCViewControllerTag.readIsAutomaticBlind.rawValue))
        let _ = homeConnection.readFlag(JetGlobalVariables.flagIsAutomaticShutter, tag: UInt32(PLCViewControllerTag.readIsAutomaticShutter.rawValue))
        let _ = homeConnection.readFlag(JetGlobalVariables.flagIsAutomaticSummerMode, tag: UInt32(PLCViewControllerTag.readIsAutomaticSummerMode.rawValue))
    }
    
    
    func writeCurrtenTimeToPLC() {
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
    
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date) - 2000

        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regYear, to: year)
        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regMonth, to: month)
        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regDay, to: day)
        
        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regHour, to: hour)
        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regMinute, to: minutes)
        let _ = homeConnection.writeIntRegister(JetGlobalVariables.regSecond, to: seconds)
    }
    
    
    func setTimeLabelText() {
        let strSeconds = String.init(format: "%02d", seconds)
        let strMinutes = String.init(format: "%02d", minutes)
        let strHour = String.init(format: "%02d", hour)
        
        timeLabel.text = "\(strHour):\(strMinutes):\(strSeconds)"
    }
    
    
    func switchChanged(mySwitch: UISwitch) {
        
        let isOn = mySwitch.isOn
        
        if let plcTag = PLCViewControllerTag(rawValue: UInt32(mySwitch.tag)) {
            
            switch (plcTag) {
            case .readIsAutomaticBlind:
                isOn ? homeConnection.setFlag(JetGlobalVariables.flagIsAutomaticBlind) : homeConnection.resetFlag(JetGlobalVariables.flagIsAutomaticBlind)
                
            case .readIsAutomaticShutter:
                isShutterSommerPos.isEnabled = isOn
                isOn ? homeConnection.setFlag(JetGlobalVariables.flagIsAutomaticShutter) : homeConnection.resetFlag(JetGlobalVariables.flagIsAutomaticShutter)
                
            case .readIsAutomaticSummerMode:
                isOn ? homeConnection.setFlag(JetGlobalVariables.flagIsAutomaticSummerMode) : homeConnection.resetFlag(JetGlobalVariables.flagIsAutomaticSummerMode)
                
            default:
                print("Error: switchChanged no case for tag \(mySwitch.tag)")
            }
        }
        
        print("switchChanged tag: \(mySwitch.tag)")
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



extension PLCViewController: Jet32Delegate {
    
    func didReceiveReadRegister(value: UInt, tag: UInt) {
        if let plcTag = PLCViewControllerTag(rawValue: UInt32(tag)) {
            switch (plcTag) {
            case .readSecond:
                seconds = Int(value)
                setTimeLabelText()
            case .readMinute:
                minutes = Int(value)
                setTimeLabelText()
            case .readHour:
                hour = Int(value)
                setTimeLabelText()
            
            
            case .readHourShutterUp:
                hourShutterUp.text = String.init(format: "%02d", value)

            case .readMinuteShutterUp:
                minuteShutterUp.text = String.init(format: "%02d", value)

            case .readHourShutterDown:
                hourShutterDown.text = String.init(format: "%02d", value)

            case .readMinuteShutterDown:
                minuteShutterDown.text = String.init(format: "%02d", value)

            case .readHourShutterUpWeekend:
                hourShutterUpWeekend.text = String.init(format: "%02d", value)

            case .readMinuteShutterUpWeekend:
                minuteShutterUpWeekend.text = String.init(format: "%02d", value)
            
            default:
                print("Error: didReceiveReadRegister no case for tag \(tag)")
                
            }
//            print("didReceiveReadRegister \(value) \(tag)")
        }
    }

    
    func didReceiveReadFlag(value: Bool, tag: UInt) {
        
        if let plcTag = PLCViewControllerTag(rawValue: UInt32(tag)) {
            
            switch (plcTag) {
                
            case .readIsAutomaticBlind:
                isBlindAutomaticSwitch.setOn(value, animated: false)
                
            case .readIsAutomaticShutter:
                isShutterAutomaticSwitch.setOn(value, animated: false)
                isShutterSommerPos.isEnabled = value
                
            case .readIsAutomaticSummerMode:
                isShutterSommerPos.setOn(value, animated: false)
               
            default:
                print("Error: didReceiveReadFlag no case for tag \(tag)")
                
            }
//            print("didReceiveReadFlag \(value) \(tag)")
        }
        
    }
    
}


extension PLCViewController: UITextFieldDelegate {
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO schreiben geht noch nicht. Evtl. wegen der hohen Registernummern. Mal in Jet32-Code nachschauen

        if let plcTag = PLCViewControllerTag(rawValue: UInt32(textField.tag)) {
            switch (plcTag) {
            case .readHourShutterUp:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regUpTimeHour, to: Int(textField.text!)!)
            case .readMinuteShutterUp:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regUpTimeMinute, to: Int(textField.text!)!)
            case .readHourShutterDown:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regDownTimeHour, to: Int(textField.text!)!)
            case .readMinuteShutterDown:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regDownTimeMinute, to: Int(textField.text!)!)
            case .readHourShutterUpWeekend:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regUpTimeHourWeekend, to: Int(textField.text!)!)
            case .readMinuteShutterUpWeekend:
                let _ = homeConnection.writeIntRegister(JetGlobalVariables.regUpTimeMinuteWeekend, to: Int(textField.text!)!)
            default:
                print("Error: textFieldDidEndEditing no case for tag \(textField.tag)")
                
            }
        }

        print("textFieldDieEndEditing tag: \(textField.tag)")
    }
    
    
}
