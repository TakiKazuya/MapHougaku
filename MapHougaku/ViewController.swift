//
//  ViewController.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/23.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var hougakuView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectHougakuButton: UIButton!
    @IBOutlet weak var selectKyoriButton: UIButton!
    
    var kyoriCount = 0
    var kyoriCountArray = [Int]()
    
    var hougakuCount = 0
    var hougakuArray = [String]()
    var hougakuImageArray = [UIImage]()
    
    //タイマー
    var kyoriTimer:Timer!
    var hougakuTimer:Timer!
    
    //どちらが押されたか判別する
    var selectKyori = false
    var selectHougaku = false
    
    //文字列型を用意する
    var hougakuString = String()
    var kyoriString = String()
    
    //マップキット
    @IBOutlet weak var mapView: MKMapView!
    
    //LocationManagerの生成
    var locManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //変数の準備
        
        for i in 0...3{
            let image = UIImage(named: "\(i)")
            hougakuImageArray.append(image!)
        }
        
        for i in 0...99{
            kyoriCountArray.append(i)
        }
        
        hougakuView.isHidden = true
        
        mapView.mapType = .mutedStandard
        
        //角丸
        hougakuView.layer.cornerRadius = 20
        button.layer.cornerRadius = 20
        label.layer.cornerRadius = 50
        imageView.layer.cornerRadius = 20
        selectView.layer.cornerRadius = 20
        selectHougakuButton.layer.cornerRadius = 20
        selectKyoriButton.layer.cornerRadius = 20
        
        button.setTitle("ストップ", for: [])
        
        //ここからが現在地取得の処理
        locManager = CLLocationManager()
        locManager.delegate = self
        initMap()
        // 位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
    }
    
    @IBAction func tapHougakuButton(_ sender: Any) {
        selectView.isHidden = true
        hougakuView.isHidden = false
        countLabel.isHidden = true
        
        //どちらのボタンが押されたか判別する
        selectKyori = false
        selectHougaku = true
        
        titleLabel.text = "方角を決めよう！"
        label.text = "ストップを押してね！"
        hougakuStartTimer()
    }
    
    @IBAction func tapKyoriButton(_ sender: Any) {
        selectView.isHidden = true
        hougakuView.isHidden = false
        imageView.isHidden = true
        
        //どちらのボタンが押されたか判別する
        selectKyori = true
        selectHougaku = false
        
        titleLabel.text = "距離を決めよう！"
        label.text = "ストップを押してね！"
        kyoriStartTimer()
    }
    
    @IBAction func startAndStopButton(_ sender: Any) {
        //距離タイマーが回っている時にストップボタンが押されたら
        if selectKyori == true {
            kyoriTimer.invalidate()
            kyoriTimer = nil
            kyoriString = "\(kyoriCount)歩"
        
        //方角タイマーが回っている時にストップボタンが押されたら
        }else if selectHougaku == true{
            hougakuTimer.invalidate()
            hougakuTimer = nil
            switch hougakuCount {
            case 0:
                hougakuString = "前に"
            case 1:
                hougakuString = "右に"
            case 2:
                hougakuString = "後ろに"
            case 3:
                hougakuString = "左に"
            default:
                print("エラー")
                label.text = "エラー"
            }
        }
        
    }
    
    
    //タイマー系のメソッド
    //距離
    func kyoriStartTimer(){
        kyoriTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(kyoriTimerUpdate), userInfo: nil, repeats: true)
    }
    @objc func kyoriTimerUpdate(){
        kyoriCount += 1
        if kyoriCount >= kyoriCountArray.count{
            kyoriCount = 0
        }
        countLabel.text = "\(kyoriCountArray[kyoriCount])"
    }
    
    //方角
    func hougakuStartTimer(){
        hougakuTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(hougakuTimerUpdate), userInfo: nil, repeats: true)
    }
    @objc func hougakuTimerUpdate(){
        hougakuCount += 1
        if hougakuCount >= hougakuImageArray.count{
            hougakuCount = 0
        }
        imageView.image = hougakuImageArray[hougakuCount]
    }
    
    
    
    func initMap() {
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)
        
        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        mapView.userTrackingMode = .follow
    }
    
    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D) {
        var region:MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region,animated:true)
    }
    
    // CLLocationManagerのdelegate：現在位置取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        mapView.userTrackingMode = .follow
    }
    
    
}

