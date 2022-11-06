//
//  HomeViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts
import Foundation
import CoreBluetooth

// Initialize global variables
var curPeripheral: CBPeripheral?
var txCharacteristic: CBCharacteristic?
var rxCharacteristic: CBCharacteristic?
var DataString = [1,2]

class HomeViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

        
    // Variable Initializations
    var centralManager: CBCentralManager!
    var rssiList = [NSNumber]()
    var peripheralList: [CBPeripheral] = []
    var characteristicList = [String: CBCharacteristic]()
    var characteristicValue = [CBUUID: NSData]()
    var labelname = UILabel()
    var timer: Timer?
    
    let BLE_Service_UUID = CBUUID.init(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    let BLE_Characteristic_uuid_Rx = CBUUID.init(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    let BLE_Characteristic_uuid_Tx  = CBUUID.init(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    
    //Initialize label variables
    @IBOutlet weak var heartratelabel: UILabel!
    @IBOutlet weak var emglabel: UILabel!
    @IBOutlet weak var edalabel: UILabel!
    @IBOutlet weak var respirationlabel: UILabel!
    
    //Initialize variabes for data being received
    var receivedData = [Int]()
    
    var receivedDataHR = [Float]()
    var receivedDataECG = [Float]()
    
    var receivedDataBPM = [Float]()
    var receivedDataResp = [Float]()
    
    var receivedDataTemp = [Float]()
    
    var receivedDataVRMS = [Float]()
    var receivedDataEMG = [Float]()
    
    var receivedDataEDA = [Float]()
    
    var receivedDataAX = [Float]()
    var receivedDataAY = [Float]()
    var receivedDataAZ = [Float]()
    var receivedDataGX = [Float]()
    var receivedDataGY = [Float]()
    var receivedDataGZ = [Float]()
    var receivedDataMX = [Float]()
    var receivedDataMY = [Float]()
    var receivedDataMZ = [Float]()
    
    var receivedDataDBA = [Float]()
    var receivedDataSPL = [Float]()
    var receivedDataAudio = [Float]()
    
    //Initialize variable buttons
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var audioButton: UISwitch!
    @IBOutlet weak var videoButton: UISwitch!
    
    @IBAction func audioSwitch(_ sender: UISwitch) { //Switch for connecting Audio
        if sender.isOn{
            print("Audio Home Switch On")
        }
        else{
            print("Audio Home Switch Off")
            stopTimerTest()
        }
    }
    
    //Switch for connecting Video
    @IBAction func videoSwitch(_ sender: UISwitch) {
        if sender.isOn{
            print("Video Home Switch On")
        }
        else{
            print("Video Home Switch Off")
        }
    }
    
    // Refresh button to be pressed every time you leave Home and come back to have data keep constantly updating on labels
    @IBAction func refreshBtn(_ sender: Any) {
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR,labelname: heartratelabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS,labelname: emglabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA,labelname: edalabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataResp,labelname: respirationlabel)
        startTimer()
    }
    
    //Timer functions which allow for data to be constantly updated
    func startTimer () {
      guard timer == nil else { return }

      timer =  Timer.scheduledTimer(
          timeInterval: TimeInterval(0.3),
          target      : self,
          selector    : #selector(TimeKeeper),
          userInfo    : nil,
          repeats     : true)
    }
    
    func stopTimerTest() {
      timer?.invalidate()
      timer = nil
    }
    
    @objc func TimeKeeper(){
        print("every 30 seconds")
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR,labelname: heartratelabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS,labelname: emglabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA,labelname: edalabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataResp,labelname: respirationlabel)
    }
    
    //View did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Done so side menu button allows you to go to side menu and access other VC
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        // Initialize CoreBluetooth Central Manager object which will be necessary
        // to use CoreBlutooth functions
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //call function so data received is displayed on labels
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR,labelname: heartratelabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS,labelname: emglabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA,labelname: edalabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataResp,labelname: respirationlabel)
    }
    
    //function to display data on corresponding labels
    func HeartRate(dataDisplaying: [Float],labelname:UILabel){
        
        //average value of array received is displayed
        let sumArray = dataDisplaying.reduce(0, +)
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        //updates label text
        labelname.text = String(format:"%.2f", avgArrayValue)
    }
    
    
    // This function is called right after the view is loaded onto the screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reset the peripheral connection with the app
        if curPeripheral != nil {
            centralManager?.cancelPeripheralConnection(curPeripheral!)
        }
        print("View Cleared")
    }
    
    // This function is called right before view disappears from screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Stop Scanning")
        
        // Central Manager object stops the scanning for peripherals
        centralManager?.stopScan()
    }

    // Called when manager's state is changed
    // Required method for setting up centralManager object
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        // If manager's state is "poweredOn", that means Bluetooth has been enabled
        // in the app. We can begin scanning for peripherals
        if central.state == CBManagerState.poweredOn {
            print("Bluetooth Enabled")
            startScan()
        }
        
        // Else, Bluetooth has NOT been enabled, so we display an alert message to the screen
        // saying that Bluetooth needs to be enabled to use the app
        else {
            print("Bluetooth Disabled- Make sure your Bluetooth is turned on")

            let alertVC = UIAlertController(title: "Bluetooth is not enabled",
                                            message: "Make sure that your bluetooth is turned on",
                                            preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "ok",
                                       style: UIAlertAction.Style.default,
                                       handler: { (action: UIAlertAction) -> Void in
                                                self.dismiss(animated: true, completion: nil)
                                                })
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // Start scanning for peripherals
        func startScan() {
        print("Now Scanning...")
        print("Service ID Search: \(BLE_Service_UUID)")
        
        // Make an empty list of peripherals that were found
        peripheralList = []
        
        // Stop the timer
            self.timer?.invalidate()
        
        // Call method in centralManager class that actually begins the scanning.
        // We are targeting services that have the same UUID value as the BLE_Service_UUID variable.
        // Use a timer to wait 10 seconds before calling cancelScan().
        centralManager?.scanForPeripherals(withServices: [BLE_Service_UUID],
                                           options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {_ in
            self.cancelScan()
        }
    }
    
    // Cancel scanning for peripheral
        func cancelScan() {
        self.centralManager?.stopScan()
        print("Scan Stopped")
        print("Number of Peripherals Found: \(peripheralList.count)")
    }

    // Called when a peripheral is found.
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        // The peripheral that was just found is stored in a variable and
        // is added to a list of peripherals. Its rssi value is also added to a list
        curPeripheral = peripheral
        self.peripheralList.append(peripheral)
        self.rssiList.append(RSSI)
        peripheral.delegate = self

        // Connect to the peripheral if it exists / has services
        if curPeripheral != nil {
            centralManager?.connect(curPeripheral!, options: nil)
        }
    }
    
    // Restore the Central Manager delegate if something goes wrong
    func restoreCentralManager() {
        centralManager?.delegate = self
    }

    // Called when app successfully connects with the peripheral
    // Use this method to set up the peripheral's delegate and discover its services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("-------------------------------------------------------")
        print("Connection complete")
        print("Peripheral info: \(String(describing: curPeripheral))")
        
        // Stop scanning because we found the peripheral we want
        cancelScan()
        
        // Set up peripheral's delegate
        peripheral.delegate = self
        
        // Only look for services that match our specified UUID
        peripheral.discoverServices([BLE_Service_UUID])
    }
    
    // Called when the central manager fails to connect to a peripheral
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        // Print error message to console for debugging purposes
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    // Called when the central manager disconnects from the peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
        //connectStatusLbl.text = "Disconnected"
        //connectStatusLbl.textColor = UIColor.red
    }
    
    // Called when the correct peripheral's services are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("-------------------------------------------------------")
        
        // Check for any errors in discovery
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }

        // Store the discovered services in a variable. If no services are there, return
        guard let services = peripheral.services else {
            return
        }
        
        // Print to console for debugging purposes
        print("Discovered Services: \(services)")

        // For every service found...
        for service in services {
            
            // If service's UUID matches with our specified one...
            if service.uuid == BLE_Service_UUID {
                print("Service found")
                //connectStatusLbl.text = "Connected!"
                //connectStatusLbl.textColor = UIColor.blue
                
                // Search for the characteristics of the service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Called when the characteristics we specified are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("-------------------------------------------------------")
        
        // Check if there was an error
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        // Store the discovered characteristics in a variable. If no characteristics, then return
        guard let characteristics = service.characteristics else {
            return
        }
        
        // Print to console for debugging purposes
        print("Found \(characteristics.count) characteristics!")
        
        // For every characteristic found...
        for characteristic in characteristics {
            print("^^^^^^^")
            print(characteristic)
            print(BLE_Characteristic_uuid_Rx)
            // If characteritstic's UUID matches with our specified one for Rx...
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
                print("inside")
                rxCharacteristic = characteristic
                
                // Subscribe to the this particular characteristic
                // This will also call didUpdateNotificationStateForCharacteristic
                // method automatically
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                print("Rx Characteristic: \(characteristic.uuid)")
            }
            
            // If characteritstic's UUID matches with our specified one for Tx...
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
                txCharacteristic = characteristic
                print("Tx Characteristic: \(characteristic.uuid)")
            }
    
            
            // Find descriptors for each characteristic
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    // Sets up notifications to the app from the Feather
    // Calls didUpdateValueForCharacteristic() whenever characteristic's value changes
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")

        // Check if subscription was successful
        if (error != nil) {
            print("Error changing notification state:\(String(describing: error?.localizedDescription))")

        } else {
            print("Characteristic's value subscribed")
        }

        // Print message for debugging purposes
        if (characteristic.isNotifying) {
            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
    
    // Called when peripheral.readValue(for: characteristic) is called
    // Also called when characteristic value is updated in
    // didUpdateNotificationStateFor() method
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        
        // If characteristic is correct, read its value and save it to a string.
        // Else, return
       // print("NOW HERE ----->")
        //print(characteristic == rxCharacteristic)
        guard characteristic == rxCharacteristic,
        let characteristicValue = characteristic.value, let receivedString = NSString(data: characteristicValue,
                                      encoding: String.Encoding.utf8.rawValue)
            else { return }
        
        // To read data received from Serial Monitor in Arduino:
        //var characteristicASCIIValue = NSString()
      //  characteristicASCIIValue = receivedString
        //let myString: String = characteristicASCIIValue as String
        
       // print("received value from Serial Monitor: \((characteristicASCIIValue))")
        //print("received value from Serial Monitor as string: \((myString))")
        
    
        
//length of string received is number written after buf in blueart.write function in Arduino
       // print("length of Serial Monitor string received:",receivedString.length)
        
        
        for i in 0..<receivedString.length {
            // Print for debugging purposes
            //print(receivedString.character(at: i))
            
            let number:Int = Int(receivedString.character(at: i))
            //split array into subarays
            //var subArrays: [[String]] = number.split(",").map{Array($0)}
            receivedData.append(number)
           // print("Received data\(receivedData)")
        }
        
        //Separate received string into components using comma as a delimiter
        let components = receivedString.components(separatedBy: ",")
        //print("Components: \(components)")
        
        //Each element of new array corresponds to data of new view controller
        let HR = [components[0]]
        let ECGPlot = [components[1]]
        
        let BPM = [components[2]]
        let RespPlot = [components[3]]
        
        let TempPlot = [components[4]]
        
        let VRMS = [components[5]]
        let EMGPlot = [components[6]]
        
        let EDAPlot = [components[7]]
        
        let AccelXPlot = [components[8]]
        let AccelYPlot = [components[9]]
        let AccelZPlot = [components[10]]
        let GyroXPlot = [components[11]]
        let GyroYPlot = [components[12]]
        let GyroZPlot = [components[13]]
        let MagXPlot = [components[14]]
        let MagYPlot = [components[15]]
        let MagZPlot = [components[16]]
        
        let dBA = [components[17]]
        let SPL = [components[18]]
        let AudioPlot = [components[19]]
        
        //For ECG Data change String vector to Float vector. Same is done for other vectors received
        for i in 0..<HR.count {
            let number:Float = Float(HR[i]) ?? 0
            receivedDataHR.append(Float(number))
        }
        for i in 0..<ECGPlot.count {
            let number:Float = Float(ECGPlot[i]) ?? 0
            receivedDataECG.append(Float(number))
        }
        
        //For Respiration Data
        for i in 0..<BPM.count {
            let number:Float = Float(BPM[i]) ?? 0
            receivedDataBPM.append(Float(number))
        }
        for i in 0..<RespPlot.count {
            let number:Float = Float(RespPlot[i]) ?? 0
            receivedDataResp.append(Float(number))
        }
        
        //For Temp Data
        for i in 0..<TempPlot.count {
            let number:Float = Float(TempPlot[i]) ?? 0
            receivedDataTemp.append(Float(number))
        }
        
        //For EMG Data
        for i in 0..<VRMS.count {
            let number:Float = Float(VRMS[i]) ?? 0
            receivedDataVRMS.append(Float(number))
            HeartRate(dataDisplaying: receivedDataVRMS,labelname: emglabel)
        }
        for i in 0..<EMGPlot.count {
            let number:Float = Float(EMGPlot[i]) ?? 0
            receivedDataEMG.append(Float(number))
        }
        
        //For EDA Data
        for i in 0..<EDAPlot.count {
            let number:Float = Float(EDAPlot[i]) ?? 0
            receivedDataEDA.append(Float(number))
        }
        
        //For Locomotion Data
        for i in 0..<AccelXPlot.count {
            let number:Float = Float(AccelXPlot[i]) ?? 0
            receivedDataAX.append(Float(number))
        }
        for i in 0..<AccelYPlot.count {
            let number:Float = Float(AccelYPlot[i]) ?? 0
            receivedDataAY.append(Float(number))
        }
        for i in 0..<AccelZPlot.count {
            let number:Float = Float(AccelZPlot[i]) ?? 0
            receivedDataAZ.append(Float(number))
        }
        for i in 0..<GyroXPlot.count {
            let number:Float = Float(GyroXPlot[i]) ?? 0
            receivedDataGX.append(Float(number))
        }
        for i in 0..<GyroYPlot.count {
            let number:Float = Float(GyroYPlot[i]) ?? 0
            receivedDataGY.append(Float(number))
        }
        for i in 0..<GyroZPlot.count {
            let number:Float = Float(GyroZPlot[i]) ?? 0
            receivedDataGZ.append(Float(number))
        }
        for i in 0..<MagXPlot.count {
            let number:Float = Float(MagXPlot[i]) ?? 0
            receivedDataMX.append(Float(number))
        }
        for i in 0..<MagYPlot.count {
            let number:Float = Float(MagYPlot[i]) ?? 0
            receivedDataMY.append(Float(number))
        }
        for i in 0..<MagZPlot.count {
            let number:Float = Float(MagZPlot[i]) ?? 0
            receivedDataMZ.append(Float(number))
        }
        
        //For Audio Data
        for i in 0..<dBA.count {
            let number:Float = Float(dBA[i]) ?? 0
            receivedDataDBA.append(Float(number))
        }
        for i in 0..<SPL.count {
            let number:Float = Float(SPL[i]) ?? 0
            receivedDataSPL.append(Float(number))
        }
        for i in 0..<AudioPlot.count {
            let number:Float = Float(AudioPlot[i]) ?? 0
            receivedDataAudio.append(Float(number))
        }
        
        //Print just to verify correct data is being received
        //print("ECG DATA: \(receivedDataECG)")
        //print("HR DATA: \(receivedDataHR)")
        //print("Respiration DATA: \(receivedDataResp)")
        //print("Respiration DATA: \(receivedDataTemp)")
        //print("EMG DATA: \(receivedDataEMG)")
        //print("EDA DATA: \(receivedDataEDA)")
        //print("Locomotion DATA: \(receivedDataAX)")
        //print("Audio DATA: \(receivedDataAudio)")
        
       
    //Remove values so only first 100 values are sent
        if (receivedDataECG.count > 100) {
            receivedDataECG.removeFirst(receivedDataECG.count-100)
        }
        if (receivedDataHR.count > 100) {
            receivedDataHR.removeFirst(receivedDataHR.count-100)
        }
        if (receivedDataEMG.count > 100) {
            receivedDataEMG.removeFirst(receivedDataEMG.count-100)
        }
        if (receivedDataEDA.count > 100) {
            receivedDataEDA.removeFirst(receivedDataEDA.count-100)
        }
        if (receivedDataResp.count > 100) {
            receivedDataResp.removeFirst(receivedDataResp.count-100)
        }
        if (receivedDataAudio.count > 100) {
            receivedDataAudio.removeFirst(receivedDataAudio.count-100)
        }
        if (receivedDataAX.count > 100) {
            receivedDataAX.removeFirst(receivedDataAX.count-100)
        }
    
        //assign received data to Singleton so it can then be transferred to the other view controllers
        SingletonClass.shared.GeneralDataHR = receivedDataHR
        
        SingletonClass.shared.GeneralDataECG = receivedDataECG
        
        SingletonClass.shared.GeneralDataBPM = receivedDataBPM
        SingletonClass.shared.GeneralDataResp = receivedDataResp
        
        SingletonClass.shared.GeneralDataTemp = receivedDataTemp
        
        SingletonClass.shared.GeneralDataVRMS = receivedDataVRMS
        SingletonClass.shared.GeneralDataEMG = receivedDataEMG
        
        SingletonClass.shared.GeneralDataEDA = receivedDataEDA
        
        //Locomotion data (Acceleration, Gyroscope, Magnometer)
        SingletonClass.shared.GeneralDataAX = receivedDataAX
        SingletonClass.shared.GeneralDataAY = receivedDataAY
        SingletonClass.shared.GeneralDataAZ = receivedDataAZ
        SingletonClass.shared.GeneralDataGX = receivedDataGX
        SingletonClass.shared.GeneralDataGY = receivedDataGY
        SingletonClass.shared.GeneralDataGZ = receivedDataGZ
        SingletonClass.shared.GeneralDataMX = receivedDataMX
        SingletonClass.shared.GeneralDataMY = receivedDataMY
        SingletonClass.shared.GeneralDataMZ = receivedDataMZ
        
        //Sound data
        SingletonClass.shared.GeneralDataDBA = receivedDataDBA
        SingletonClass.shared.GeneralDataSPL = receivedDataSPL
        SingletonClass.shared.GeneralDataAudio = receivedDataAudio
        
        //call HeartRate function so labels will be updated
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR,labelname: heartratelabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS,labelname: emglabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA,labelname: edalabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataResp,labelname: respirationlabel)
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: self)
        
    }
    
    // Called when app wants to send a message to peripheral
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Message sent")
    }

    // Called when descriptors for a characteristic are found
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        // Print for debugging purposes
        print("*******************************************************")
        if error != nil {
            print("\(error.debugDescription)")
            return
        }
        
        // Store descriptors in a variable. Return if nonexistent.
        guard let descriptors = characteristic.descriptors else { return }
        print("descriptors")
        
        // For every descriptor, print its description for debugging purposes
        descriptors.forEach { descript in
            print("function name: DidDiscoverDescriptorForChar \(String(describing: descript.description))")
            print("Rx Value \(String(describing: rxCharacteristic?.value))")
            print("Tx Value \(String(describing: txCharacteristic?.value))")
        }
    }

}
    
    
