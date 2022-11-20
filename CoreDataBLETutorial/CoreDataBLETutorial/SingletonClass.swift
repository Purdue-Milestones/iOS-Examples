//
//  SingletonClass.swift
//  CoreDataBLETutorial
//
//  Created by Carolina Solís on 11/7/22.
//

import UIKit

//create singleton class
class SingletonClass {
    static let shared = SingletonClass()
    
    //initialize variables for all vectors of data that will be received (float vectors)
    
    //For ECG VC
    var GeneralDataHR = [Float]()
    var GeneralDataECG = [Float]()
    
    //For Respiration VC
    var GeneralDataBPM = [Float]()
    var GeneralDataResp = [Float]()
    
    //For Temperature VC
    var GeneralDataTemp = [Float]()
    
    //For EMG VC
    var GeneralDataVRMS = [Float]()
    var GeneralDataEMG = [Float]()
    
    //For EDA VC
    var GeneralDataEDA = [Float]()
    
    //For Locomotion VC
    var GeneralDataAX = [Float]()
    var GeneralDataAY = [Float]()
    var GeneralDataAZ = [Float]()
    var GeneralDataGX = [Float]()
    var GeneralDataGY = [Float]()
    var GeneralDataGZ = [Float]()
    var GeneralDataMX = [Float]()
    var GeneralDataMY = [Float]()
    var GeneralDataMZ = [Float]()
    
    //For Audio VC
    var GeneralDataDBA = [Float]()
    var GeneralDataSPL = [Float]()
    var GeneralDataAudio = [Float]()
    
    //creates Singleton
    var locationGranted: Bool?
    private init(){}
}



