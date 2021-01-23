//
//  ViewController.swift
//  Table
//
//  Created by 한준호 on 2020/12/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    //초기화 단계이므로 값이 비어있을 수 있기 때문에 ?(optional)
    var newsData : Array<Dictionary<String,Any>>?
    
    //1. http 통신 방법 - URLsession
    //2. JSON 데이터 형태 ex1 = {"돈" : "1000"}
    /* ex2 =
     {
     [
     {"돈":"1000"},
     {"돈":"2000"},
     {"돈":"3000"}
     ]
     }
     //3. 테이블뷰의 데이터 매칭! <- 통보
     //네트워크 통신(Thread)는 background에서 작동. UI 작업: main
     */
    
    func getNews(){ //백그라운드에서 작동
        let task = URLSession.shared.dataTask(with: URL(string: "http://newsapi.org/v2/top-headlines?country=kr&category=technology&apiKey=fc48d972cebf400abad179cbe69d0620")!) { (data, response, error) in
            //옵셔널 바인딩
            if let dataJson = data{
                //json parsing
                do{
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    
                    //Dictionary
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsData = articles
                    
                    DispatchQueue.main.async { //Main에서 일을 하라는 코드(async: 비동기)   WHY? 네트워크 통신은 백그라운드에서 진행되기 때문에
                        self.TableViewMain.reloadData()
                    }
                    
                    //배열에서 뽑아오는 법
                    //                    for(idx, value) in articles.enumerated(){
                    //                        if let v = value as? Dictionary<String, Any>{
                    //                            print("\(v["title"])")
                    //                        }
                    //                    }
                }
                catch{
                    print("error")
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //데이터 개수
        
        if let news = newsData{
            return news.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //데이터 종류, 셀 개수만큼 반복
        //방법1 : 임의의 셀 만들기(연습)
        //        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Type1")
        //        cell.textLabel?.text = "\(indexPath.row)"
        //
        //        return cell
        
        //방법2 : 스토리보드 + id(실무)
        //as? as! - 부모 자식 친자 확인 ?는 불확실할 때, !는 확실할 때
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        //인덱스를 가져옴
        let idx = indexPath.row
        
        if let news = newsData{ // newsData가 비어있지 않으면
            let row = news[idx] // 숫자에 해당하는 번지 수의 news를 가져와서
            if let r = row as? Dictionary<String, Any>{ //row가 Dictionary 형태이면
                
                if let title = r["title"] as? String{
                    cell.LabelText.text = title
                }
            }
        }
        return cell
    }
    
    // *1 클릭 이벤트
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Click!! \(indexPath.row)")
//        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
//        
//        if let news = newsData  {
//        let row = news[indexPath.row]
//            if let r = row as? Dictionary<String, Any> {
//                if let imageUrl = r["urlToImage"] as? String{
//                    controller.imageUrl = imageUrl
//                }
//                if let desc = r["description"] as? String{
//                    controller .desc = desc
//                }
//            }
//        }
//        
//        
//        //이동하는 방법 - 수동
//        showDetailViewController(controller, sender: nil)
//    }
    
    
    // *2 세그웨이
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {

            //만약 컨트롤러라는 변수의 목적지가 NewsDetailController
            if let controller = segue.destination as? NewsDetailController {

                if let news = newsData  {
                    if let indexPath = TableViewMain.indexPathForSelectedRow{
                        let row = news[indexPath.row]

                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["urlToImage"] as? String{
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String{
                                controller .desc = desc
                            }
                        }
                    }
                }


        }

        //이동하는 방법 - 자동 (이미 세그웨이 만들 때 자동으로 설정됨)
        }
    }
    
    
    //디테일 화면 만들기
    
    //값을 보내는 방법
    //#1 *1. tableView delegate / *2.storyboard (segue)
    //#2. 화면 이동(이동하기 전에 값을 미리 세팅해야 한다)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        getNews()
    }
    
    
    //tableView - 여러 개의 행이 모여있는 목록 뷰
    //일부 화면은 table view, 전체 화면은 tablev iew Controller 사용
    //1. 데이터 무엇?
    //2. 데이터 몇개?
    //3. 데이터 클릭 이벤트
}
