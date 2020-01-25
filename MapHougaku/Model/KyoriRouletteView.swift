//
//  KyoriRouletteView.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/25.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit

class KyoriRouletteView: UIView {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    
    func loadNib(){
        let view = UINib(nibName: "KyoriRouletteView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

}
