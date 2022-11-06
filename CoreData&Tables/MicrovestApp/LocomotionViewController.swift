//
//  LocomotionViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 1/27/22.
//

import UIKit
import Charts

class LocomotionViewController: UIViewController {

    //Variable initialization
    var timer: Timer?
    var showGraphIsOn = true
    var labelname = UILabel()
    
    //received data from Singleton
    var receivedAXData = SingletonClass.shared.GeneralDataAX
    var receivedAYData = SingletonClass.shared.GeneralDataAY
    var receivedAZData = SingletonClass.shared.GeneralDataAZ
    
    var receivedGXData = SingletonClass.shared.GeneralDataGX
    var receivedGYData = SingletonClass.shared.GeneralDataGY
    var receivedGZData = SingletonClass.shared.GeneralDataGZ
    
    var receivedMXData = SingletonClass.shared.GeneralDataMX
    var receivedMYData = SingletonClass.shared.GeneralDataMY
    var receivedMZData = SingletonClass.shared.GeneralDataMZ
    
    //initialize array which will contain magnitude of x, y, and z received data
    var magnitudearr = [Float]()
    
    //labels for x,y, and z data
    @IBOutlet weak var accXLabel: UILabel!
    @IBOutlet weak var accYLabel: UILabel!
    @IBOutlet weak var accZLabel: UILabel!
    @IBOutlet weak var accVLabel: UILabel!
    @IBOutlet weak var gyrXLabel: UILabel!
    @IBOutlet weak var gyrYLabel: UILabel!
    @IBOutlet weak var gyrZLabel: UILabel!
    @IBOutlet weak var gyrVLabel: UILabel!
    @IBOutlet weak var magXLabel: UILabel!
    @IBOutlet weak var magYLabel: UILabel!
    @IBOutlet weak var magZLabel: UILabel!
    @IBOutlet weak var magVLabel: UILabel!
    
    //Initialize charts
    @IBOutlet weak var AccBox: LineChartView!
    @IBOutlet weak var MagBox: LineChartView!
    @IBOutlet weak var GyroBox: LineChartView!
    
    //Initialize connected status and side menu labels
    @IBOutlet weak var connectStatusLbl: UILabel!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBAction func showGraphBtn(_ sender: UISwitch) {
        if sender.isOn{
            showGraphIsOn = true
            print("HR Switch On")
            connectStatusLbl.text = "Connected!"
            connectStatusLbl.textColor = UIColor.blue
            displayGraph(x: SingletonClass.shared.GeneralDataAX, y: SingletonClass.shared.GeneralDataAY, z: SingletonClass.shared.GeneralDataAZ, chartview: AccBox)
            displayGraph(x: SingletonClass.shared.GeneralDataGX, y: SingletonClass.shared.GeneralDataGY, z: SingletonClass.shared.GeneralDataGZ, chartview: GyroBox)
            displayGraph(x: SingletonClass.shared.GeneralDataMX, y: SingletonClass.shared.GeneralDataMY, z: SingletonClass.shared.GeneralDataMZ, chartview: MagBox)
            
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAX,labelname: accXLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAY,labelname: accYLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAZ,labelname: accZLabel)
            
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGX,labelname: gyrXLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGY,labelname: gyrYLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGZ,labelname: gyrZLabel)
            
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMX,labelname: magXLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMY,labelname: magYLabel)
            HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMZ,labelname: magZLabel)
            
            startTimer()
        }
        else{
            AccBox.clear()
            GyroBox.clear()
            MagBox.clear()
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
        
        displayGraph(x: SingletonClass.shared.GeneralDataAX, y: SingletonClass.shared.GeneralDataAY, z: SingletonClass.shared.GeneralDataAZ, chartview: AccBox)
        displayGraph(x: SingletonClass.shared.GeneralDataGX, y: SingletonClass.shared.GeneralDataGY, z: SingletonClass.shared.GeneralDataGZ, chartview: GyroBox)
        displayGraph(x: SingletonClass.shared.GeneralDataMX, y: SingletonClass.shared.GeneralDataMY, z: SingletonClass.shared.GeneralDataMZ, chartview: MagBox)
        
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAX,labelname: accXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAY,labelname: accYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAZ,labelname: accZLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGX,labelname: gyrXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGY,labelname: gyrYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGZ,labelname: gyrZLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMX,labelname: magXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMY,labelname: magYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMZ,labelname: magZLabel)
        
        
        if(connectStatusLbl.text == "Connected") {
            startTimer()
        }
        if(connectStatusLbl.text == "Disconnected"){
            stopTimerTest()
        }
    }
    
    //timer functions to constantly update data
    func startTimer () {
      guard timer == nil else { return }

      timer =  Timer.scheduledTimer(
          timeInterval: TimeInterval(0.3),
          target      : self,
          selector    : #selector(TimeKeeper),
          userInfo    : nil,
          repeats     : true)
    }
    
    //stops updating data constantly
    func stopTimerTest() {
      timer?.invalidate()
      timer = nil
    }
    
    @objc func TimeKeeper(){
        print("every 30 seconds")
        displayGraph(x: SingletonClass.shared.GeneralDataAX, y: SingletonClass.shared.GeneralDataAY, z: SingletonClass.shared.GeneralDataAZ, chartview: AccBox)
        displayGraph(x: SingletonClass.shared.GeneralDataGX, y: SingletonClass.shared.GeneralDataGY, z: SingletonClass.shared.GeneralDataGZ, chartview: GyroBox)
        displayGraph(x: SingletonClass.shared.GeneralDataMX, y: SingletonClass.shared.GeneralDataMY, z: SingletonClass.shared.GeneralDataMZ, chartview: MagBox)
        
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAX,labelname: accXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAY,labelname: accYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAZ,labelname: accZLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataAZ,labelname: accZLabel)
        
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGX,labelname: gyrXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGY,labelname: gyrYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataGZ,labelname: gyrZLabel)
        
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMX,labelname: magXLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMY,labelname: magYLabel)
        HeartRate(dataDisplaying: SingletonClass.shared.GeneralDataMZ,labelname: magZLabel)
    }
    
    //to display data on graphs
    func displayGraph(x: [Float],y: [Float],z: [Float],chartview:LineChartView) {
        
        var magnitudearray = [Float]()
        
        for i in 0..<x.count {
            let sumval = pow(x[i],2) + pow(y[i],2) + pow(z[i],2)
            let squaresumval = Float(sqrt(sumval))
            magnitudearray.append(squaresumval)
        }
        
        //displays magnitude on chart view
        let dataDisplaying = magnitudearray
        
        //displays magnitude data on labels
        HeartRate(dataDisplaying: dataDisplaying,labelname: accVLabel)
        HeartRate(dataDisplaying: dataDisplaying,labelname: gyrVLabel)
        HeartRate(dataDisplaying: dataDisplaying,labelname: magVLabel)
        
        var lineChartEntry  = [ChartDataEntry]()

        // For every element in given dataset
        // Set the X and Y status in a data chart entry
        // and add to the entry object
        for i in 0..<dataDisplaying.count {
            let value = ChartDataEntry(x: Double(i), y: Double(dataDisplaying[i]))
            lineChartEntry.append(value)
        }

        // Convert lineChartEntry to a LineChartDataSet
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Locomotion")
        
        // Customize graph settings to your liking
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue]

        // Make object that will be added to the chart
        // and set it to the variable in the Storyboard
        let lineData = LineChartData(dataSet: line1)
        
        //chartBox.dragEnabled = true
        chartview.setScaleEnabled(true)
        chartview.pinchZoomEnabled = true
        
        chartview.data = lineData

        // Settings for the chartBox
        chartview.chartDescription!.text = "Retrieving Data..."
    }
    
    //do clear graph
    func clearGraph(chartview:LineChartView) {
        let nullGraph = [Float]()
        displayGraph(x: nullGraph, y: nullGraph, z: nullGraph, chartview: AccBox)
        displayGraph(x: nullGraph, y: nullGraph, z: nullGraph, chartview: GyroBox)
        displayGraph(x: nullGraph, y: nullGraph, z: nullGraph, chartview: MagBox)
    }
    
    //to display data on labels
    func HeartRate(dataDisplaying: [Float],labelname:UILabel){
        let sumArray = dataDisplaying.reduce(0, +)
        
        let avgArrayValue = Double(sumArray) / Double(dataDisplaying.count)
        
        labelname.text = String(format:"%.2f", avgArrayValue)
    }
}
