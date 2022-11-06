//
//  EMGViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts

class EMGViewController: UIViewController {
    
    var timer: Timer? //to make data update constantly on graph
    
    var receivedData = SingletonClass.shared.GeneralDataEMG //received data displayed on graph
    var VRMSLabel = SingletonClass.shared.GeneralDataVRMS //received data that will be displayed on label
    
    var showGraphIsOn = true
    
    @IBOutlet weak var VoltageEMG: LineChartView!
    @IBOutlet weak var VRMS: UILabel!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var connectStatusLbl: UILabel!
    
    @IBAction func refreshBtn(_ sender: Any) {
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEMG)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS)
    }

    //Show graph when switch is on
    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("HR Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEMG)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS)
            //Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(TimeKeeper), userInfo: nil, repeats: true)
            startTimer()
        }
        else{
            VoltageEMG.clear()
            showGraphIsOn = false
            print("HR Switch Off")
            connectStatusLbl.text = "Disconnected"
            connectStatusLbl.textColor = UIColor.red
            stopTimerTest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEMG)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS)
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEMG)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS)
        
        if(connectStatusLbl.text == "Connected") {
            startTimer()
        }
        if(connectStatusLbl.text == "Disconnected"){
            stopTimerTest()
        }
    }
    
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
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEMG)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataVRMS)
    }
    
    func displayGraph(dataDisplaying: [Float]) {
        
        // Array that will eventually be displayed on the graph.
        var lineChartEntry  = [ChartDataEntry]()
        

        // For every element in given dataset
        // Set the X and Y status in a data chart entry
        // and add to the entry object
        for i in 0..<dataDisplaying.count {
            let value = ChartDataEntry(x: Double(i), y: Double(dataDisplaying[i]))
            lineChartEntry.append(value)
        }

        // Convert lineChartEntry to a LineChartDataSet
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "VRMS")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        VoltageEMG.setScaleEnabled(true)
        VoltageEMG.pinchZoomEnabled = true
        
        VoltageEMG.data = lineData

        // Settings for the chartBox
        VoltageEMG.chartDescription!.text = "Retrieving Data..."
    }
    
    
    func clearGraph() {
        let nullGraph = [Float]()
        displayGraph(dataDisplaying: nullGraph)
    }
    
    func HeartRate(dataDisplaying: [Float]){
        let sumArray = dataDisplaying.reduce(0, +)
        
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        VRMS.text = String(format:"%.2f", avgArrayValue)

    }
}

