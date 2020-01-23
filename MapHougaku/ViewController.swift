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
    
    //マップキット
    @IBOutlet weak var mapView: MKMapView!
    
    //LocationManagerの生成
    var locManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        mapView.mapType = .mutedStandard
        
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

