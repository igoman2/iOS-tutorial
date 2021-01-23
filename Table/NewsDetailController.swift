//
//  NewsDetailController.swift
//  Table
//
//  Created by 한준호 on 2021/01/23.
//

import UIKit

class NewsDetailController : UIViewController {
 
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    
    //1. image URL
    //2. Description
    
    
    //?를 한 이유는 아래 값들이 있을수도 있고 없을수도 있으니까
    var imageUrl: String?
    var desc: String?
    
    
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = imageUrl{
            //이미지 가져와서 뿌린다!
            //Data(이미지를 가져오는 방법 중 하나)
            
            //URL로 가져온 이미지를 data라는 변수아 삽입
           if let data = try? Data(contentsOf: URL(string: img)!)
           {
            //Main에서 작동하도록
            DispatchQueue.main.async{
                //data 변수에 저장된 이미지를 보여줌
                self.imageMain.image = UIImage(data: data)
            }
           }
        }
        
        if let d = desc {
            //본문을 보여준다!
            self.LabelMain.text = d
        }
    }
}
