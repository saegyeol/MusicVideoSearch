//
//  BaseXibView.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit
import SnapKit

class BaseXibView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    initFromXib()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    initFromXib()
  }

  func initFromXib() {
    let view = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    self.addSubview(view)
    view.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self)
      make.left.equalTo(self)
      make.bottom.equalTo(self)
      make.right.equalTo(self)
    }
  }
}
