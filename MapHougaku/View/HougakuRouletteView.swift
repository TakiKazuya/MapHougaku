//
//  HougakuRouletteView.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/25.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit

class HougakuRouletteView: UIView {
    
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
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("HougakuRouletteView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
