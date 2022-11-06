//
//  ECGViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts
import Foundation
import CoreBluetooth

class ECGViewController: UIViewController{
    
    //Variable initialization
    var timer: Timer? //to make data update constantly on graph
    
    var receivedData = SingletonClass.shared.GeneralDataECG //received data displayed on graph
    var HRLabelData = SingletonClass.shared.GeneralDataHR //received data that will be displayed on label
    
    var showGraphIsOn = true
    
    //Initialize chart, label, and side menu button variables
    @IBOutlet weak var HRBox: LineChartView!
    @IBOutlet weak var HeartLabel: UILabel!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var connectStatusLbl: UILabel!
    
    //Show graph when switch is on
    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("ECG Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataECG)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR)
            startTimer()
    }
        else{
            HRBox.clear()
            showGraphIsOn = false
            print("ECG Switch Off")
            connectStatusLbl.text = "Disconnected"
            connectStatusLbl.textColor = UIColor.red
            stopTimerTest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Side menu
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        //call functions to display data on chart and label
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataECG)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR)
        
        //allows for data to begin constantly updating when you enter VC
        if(connectStatusLbl.text == "Connected") {
            startTimer()
        }
        if(connectStatusLbl.text == "Disconnected"){
            stopTimerTest()
        }
    }

//Timer functions to constantly update data
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
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataECG)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataHR)
    }
    
    // Graph the dataset to storyboard
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
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Voltage (mV) vs. Time")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        HRBox.setScaleEnabled(true)
        HRBox.pinchZoomEnabled = true
        
        HRBox.data = lineData

        // Settings for the chartBox
        HRBox.chartDescription!.text = "Retrieving Data..."
    }
    
    func clearGraph() {
        let nullGraph = [Float]()
        displayGraph(dataDisplaying: nullGraph)
    }
    
    func HeartRate(dataDisplaying: [Float]){
        let sumArray = dataDisplaying.reduce(0, +)
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        HeartLabel.text = String(format:"%.2f", avgArrayValue)
    }
}
