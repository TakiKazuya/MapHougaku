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
    
    //マップキット
    @IBOutlet weak var mapView: MKMapView!
    
    //LocationManagerの生成
    var locManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hougakuView.isHidden = true
        
        mapView.mapType = .mutedStandard
        
        //角丸
        hougakuView.layer.cornerRadius = 20
        button.layer.cornerRadius = 20
        label.layer.cornerRadius = 20
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
    
    @IBAction func selectHougaku(_ sender: Any) {
        selectView.isHidden = true
        hougakuView.isHidden = false
        countLabel.isHidden = true
        titleLabel.text = "方角を決めよう！"
        label.text = "ストップを押してね！"
    }
    
    @IBAction func selectKyori(_ sender: Any) {
        selectView.isHidden = true
        hougakuView.isHidden = false
        imageView.isHidden = true
        titleLabel.text = "距離を決めよう！"
        label.text = "ストップを押してね！"
    }
    
    @IBAction func startAndStopButton(_ sender: Any) {
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

