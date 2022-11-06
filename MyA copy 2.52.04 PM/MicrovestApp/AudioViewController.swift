//
//  AudioViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts

class AudioViewController: UIViewController {

    //Variable initialization
    var timer: Timer? //to make data update constantly on graph
    
    var showGraphIsOn = true
    var labelname = UILabel()
    
    var receivedData = SingletonClass.shared.GeneralDataAudio //received data displayed on graph
    var receivedDBData = SingletonClass.shared.GeneralDataDBA //received data displayed on DBA Label
    var receivedSPLData = SingletonClass.shared.GeneralDataSPL //received data displayed on SPL Label
    
    //Initialize chart, labels, and side menu button variables
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var dbaLabel: UILabel!
    @IBOutlet weak var splLabel: UILabel!
    @IBOutlet weak var VoltageAudioBox: LineChartView!
    @IBOutlet weak var connectStatusLbl: UILabel!
    
    //Show graph when switch is on
    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("HR Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataAudio)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataDBA,labelname: dbaLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataSPL,labelname: splLabel)
            //Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(TimeKeeper), userInfo: nil, repeats: true)
            startTimer()
        }
        else{ //clear graph
            VoltageAudioBox.clear()
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
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataAudio)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataDBA,labelname: dbaLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataSPL,labelname: splLabel)
        
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataAudio)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataDBA,labelname: dbaLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataSPL,labelname: dbaLabel)
        
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
        displayGraph(dataDisplaying: SingletonClass.shared.GeneralDataAudio)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataDBA,labelname: dbaLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataSPL,labelname: splLabel)
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
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Audio")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        VoltageAudioBox.setScaleEnabled(true)
        VoltageAudioBox.pinchZoomEnabled = true
        
        VoltageAudioBox.data = lineData

        // Settings for the chartBox
        VoltageAudioBox.chartDescription!.text = "Retrieving Data..."
    }
    
    
    func clearGraph() {
        let nullGraph = [Float]()
        displayGraph(dataDisplaying: nullGraph)
    }
    
    func HeartRate(dataDisplaying: [Float],labelname:UILabel){
        let sumArray = dataDisplaying.reduce(0, +)
        
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        labelname.text = String(format:"%.2f", avgArrayValue)
    }
}
