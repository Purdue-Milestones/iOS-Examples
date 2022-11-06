//
//  EDAViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts

class EDAViewController: UIViewController {

    var timer: Timer?
    
    //received data from Singleton
    var receivedData = SingletonClass.shared.GeneralDataEDA

    var showGraphIsOn = true
    
    //Initialize labels, chart, and side menu button
    
    @IBOutlet weak var EDALabel: UILabel!
    @IBOutlet weak var MicroSiemensBox: LineChartView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var connectStatusLbl: UILabel!

    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("HR Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
            //Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(TimeKeeper), userInfo: nil, repeats: true)
            startTimer()
        }
        
        else{
            MicroSiemensBox.clear()
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
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
        
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
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataEDA)
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
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "EDA")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        MicroSiemensBox.setScaleEnabled(true)
        MicroSiemensBox.pinchZoomEnabled = true
        
        MicroSiemensBox.data = lineData

        // Settings for the chartBox
        MicroSiemensBox.chartDescription!.text = "Retrieving Data..."
    }
    
    
    func clearGraph() {
        let nullGraph = [Float]()
        displayGraph(dataDisplaying: nullGraph)
    }
    
    func HeartRate(dataDisplaying: [Float]){
        let sumArray = dataDisplaying.reduce(0, +)
        
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        EDALabel.text = String(format:"%.2f", avgArrayValue)

    }
}
