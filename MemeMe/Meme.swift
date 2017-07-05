//
//  Meme.swift
//  MemeMe
//
//  Created by Zhehui Zhou on 7/5/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let textTop: String
    let textBottom: String
    let imageOriginal: UIImage
    let imageMemed: UIImage
    
    init(textTop: String, textBottom: String, imageOriginal: UIImage, imageMemed: UIImage) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.imageOriginal = imageOriginal
        self.imageMemed = imageMemed
    }
}
