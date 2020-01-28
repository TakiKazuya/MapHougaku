//
//  SelectView.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/25.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit

class SelectView: UIView {

    @IBOutlet weak var selectHougakuButton: UIButton!
    @IBOutlet weak var selectKyoriButton: UIButton!
    @IBOutlet weak var selectCloseButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    func loadNib(){
        let view = UINib(nibName: "SelectView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func selectHougaku(_ sender: Any) {
        self.isHidden = true
        
        
    }
    @IBAction func selectKyori(_ sender: Any) {
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
    

 
}
