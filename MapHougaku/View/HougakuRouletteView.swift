//
//  HougakuRouletteView.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/25.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit

class HougakuRouletteView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var hougakuCount = 0
    var hougakuArray = [String]()
    var hougakuImageArray = [UIImage]()
    var hougakuString = String()
    
    @IBAction func startAndStop(_ sender: UIButton) {
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
