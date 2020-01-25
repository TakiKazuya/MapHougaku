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
    @IBOutlet weak var rouletteView: UIView! //ルーレット画面
    @IBOutlet weak var titleLabel: UILabel! //ルーレット画面のタイトル
    @IBOutlet weak var hougakuImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var hougakuButton: UIButton!
    @IBOutlet weak var kyoriButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectHougakuButton: UIButton!
    @IBOutlet weak var selectKyoriButton: UIButton!
    @IBOutlet weak var selectCloseButton: UIButton!
    
    var kyoriCount = 0
    var kyoriCountArray = [Int]()
    
    var hougakuCount = 0
    var hougakuArray = [String]()
    var hougakuImageArray = [UIImage]()
    
    //タイマー
    var kyoriTimer:Timer!
    var hougakuTimer:Timer!
    
    //すでにボタンが押されているか判別
    var kyoriIsStop = false
    var hougakuIsStop = false
    
    //文字列型を用意する
    var hougakuString = String()
    var kyoriString = String()
    
    var select = 0
    
    //マップキット
    @IBOutlet weak var mapView: MKMapView!
    
    //LocationManagerの生成
    var locManager: CLLocationManager!
    
    //Xibファイルで作ったViewを呼び出す
    @IBOutlet weak var hougakuRouletteView: HougakuRouletteView!
    @IBOutlet weak var kyoriRouletteView: KyoriRouletteView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hougakuRouletteView.isHidden = true
        kyoriRouletteView.isHidden = true
        
      
        selectButton.isHidden = true
        
       
        //変数の準備
        
        for i in 0...3{
            let image = UIImage(named: "\(i)")
            hougakuImageArray.append(image!)
        }
        
        for i in 0...99{
            kyoriCountArray.append(i)
        }
        
        //アプリ起動時、ルーレット画面は消す
        rouletteView.isHidden = true
        closeButton.isHidden = true
        
        mapView.mapType = .mutedStandard
        
        //角丸
        rouletteView.layer.cornerRadius = 20
        
        hougakuButton.layer.cornerRadius = 20
        kyoriButton.layer.cornerRadius = 20
        closeButton.layer.cornerRadius = 20
        hougakuImageView.layer.cornerRadius = 20
        
        label.layer.cornerRadius = 50
        
        selectView.layer.cornerRadius = 20
        selectHougakuButton.layer.cornerRadius = 20
        selectKyoriButton.layer.cornerRadius = 20
        selectCloseButton.layer.cornerRadius = 20
        
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
    
    @IBAction func openSelectView(_ sender: Any) {
        selectView.isHidden = false
        selectButton.isHidden = true
    }
    
    //selectViewのボタンを押された時の処理
    //方角を決めるボタンが押された時
    @IBAction func tapHougakuButton(_ sender: Any) {
        closeButton.isHidden = true
        selectView.isHidden = true //選択画面を消す
        rouletteView.isHidden = false //ルーレット画面を現す
        countLabel.isHidden = true //カウントルーレットを消す
        hougakuImageView.isHidden = false //方角ルーレットを現す
        
        //方角ボタンを表示して、距離ボタンを消す
        hougakuButton.isHidden = false
        kyoriButton.isHidden = true
        
        titleLabel.text = "方角を決めよう！"
        label.text = "ストップを押してね！"
        hougakuStartTimer()
    }
    
    //距離を決めるボタンが押された時
    @IBAction func tapKyoriButton(_ sender: Any) {
        closeButton.isHidden = true
        selectView.isHidden = true //選択画面を消す
        rouletteView.isHidden = false //ルーレット画面を現す
        hougakuImageView.isHidden = true //方角ルーレットを消す
        countLabel.isHidden = false
        
        //距離ボタンを表示して、方角ボタンを消す
        kyoriButton.isHidden = false
        hougakuButton.isHidden = true
        
        
        titleLabel.text = "距離を決めよう！"
        label.text = "ストップを押してね！"
        kyoriStartTimer()
    }
    
    //閉じるボタンが押された時
    @IBAction func closeSelectView(_ sender: Any) {
        selectView.isHidden = true
        selectButton.isHidden = false
    }
    
    //rouletteViewのボタンが押された時の処理
    //距離スタートストップボタンが押された時
    @IBAction func kyoriStartAndStop(_ sender: Any) {
        //止める　方角、距離のどちらも止まっておらず、なおかつ距離タイマーが回っている時
        if kyoriIsStop == false && hougakuIsStop == false && kyoriTimer != nil{
            kyoriTimer.invalidate()
            kyoriTimer = nil
            kyoriIsStop = true
            kyoriString = "\(kyoriCount)歩"
            label.text = kyoriString
            
            //距離ボタンを消して、方角ボタンを出す
            kyoriButton.isHidden = true
            hougakuButton.isHidden = false
            
            //表示した方角ボタンのテキストを変える
            hougakuButton.setTitle("方角を決める", for: [])

        }else if hougakuIsStop == true && kyoriTimer == nil{
            titleLabel.text = "距離を決めよう！"
            hougakuImageView.isHidden = true
            countLabel.isHidden = false
            kyoriStartTimer()
            kyoriButton.setTitle("ストップ", for: [])
        }else{
            kyoriTimer.invalidate()
            kyoriTimer = nil
            kyoriString = "\(kyoriCount)歩"
            label.text = "\(hougakuString)\(kyoriString)進む"
            kyoriButton.isHidden = true
            closeButton.isHidden = false
            
        }
    }
    
    //方角スタートストップボタンが押された時
    @IBAction func hougakuStartAndStop(_ sender: Any) {
        if kyoriIsStop == false && hougakuIsStop == false && hougakuTimer != nil{
            hougakuTimer.invalidate()
            hougakuTimer = nil
            hougakuIsStop = true
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
                hougakuString = "エラー"
            }
            label.text = hougakuString
            
            //方角ボタンを消して、距離ボタンを出す
            hougakuButton.isHidden = true
            kyoriButton.isHidden = false
            
            //表示した距離ボタンのテキストを変える
            kyoriButton.setTitle("距離を決める", for: [])
            
        }else if kyoriIsStop == true && hougakuTimer == nil{
            titleLabel.text = "方角を決めよう！"
            hougakuImageView.isHidden = false
            countLabel.isHidden = true
            hougakuStartTimer()
            hougakuButton.setTitle("ストップ", for: [])
        }else{
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
                hougakuString = "エラー"
            }
            label.text = "\(hougakuString)\(kyoriString)進む"
            hougakuButton.isHidden = true
            closeButton.isHidden = false
        }
        
    }
    
    //閉じるボタンが押された時
    @IBAction func close(_ sender: Any) {
        rouletteView.isHidden = true
        selectButton.isHidden = false
        kyoriIsStop = false
        hougakuIsStop = false
    }
    
    //タイマー系のメソッド
    //距離
    func kyoriStartTimer(){
        kyoriTimer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(kyoriTimerUpdate), userInfo: nil, repeats: true)
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
        hougakuImageView.image = hougakuImageArray[hougakuCount]
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

