//
//  RespirationViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts

class RespirationViewController: UIViewController {
    
    var timer: Timer?
    //to make data update constantly on graph
    
    var receivedData = SingletonClass.shared.GeneralDataResp //received data displayed on graph
    var respLabelData = SingletonClass.shared.GeneralDataBPM  //received data that will be displayed on label
    
    var showGraphIsOn = true
    
    //Initialize chart, label, and side menu button variables
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var RespiratoryLabel: UILabel!
    @IBOutlet weak var AmpBox: LineChartView!
    @IBOutlet weak var connectStatusLbl: UILabel!
    
    //Show graph when switch is on
    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("HR Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataResp)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataBPM)
            startTimer()
        }
        else{
            AmpBox.clear()
            showGraphIsOn = false
            print("HR Switch Off")
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
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataResp)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataBPM)
        
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
        print("every 30 seconds")
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataResp)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataBPM)
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
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Ohms vs. Time")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        AmpBox.setScaleEnabled(true)
        AmpBox.pinchZoomEnabled = true
        
        AmpBox.data = lineData

        // Settings for the chartBox
        AmpBox.chartDescription!.text = "Retrieving Data..."
    }
    
    
    func clearGraph() {
        let nullGraph = [Float]()
        displayGraph(dataDisplaying: nullGraph)
    }
    
    func HeartRate(dataDisplaying: [Float]){
        let sumArray = dataDisplaying.reduce(0, +)
        
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        RespiratoryLabel.text = String(format:"%.2f", avgArrayValue)

    }
}
