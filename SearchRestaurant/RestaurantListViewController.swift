//
//  RestaurantListViewController.swift
//  SearchRestaurant
//  レストラン一覧画面
//
//  Created by 田中勇輝 on 2021/04/19.
//

import UIKit

class RestaurantListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleView: UIView!
    
    /**
     検索項目表示関連
     */
    var searchList = [
        "distance": "",
        "genre": "",
        "keyword": ""
    ]
    @IBOutlet weak var distanceField: UILabel! // 半径距離
    @IBOutlet weak var genreField: UILabel! // ジャンル
    @IBOutlet weak var restaurantNameField: UILabel! // キーワード
    @IBOutlet weak var listNumberField: UILabel! // 検索結果数
    
    // MARK: - レストラン一覧表示関連
    @IBOutlet weak var tableView: UITableView! // レストラン一覧を表示するテーブル
    // レストラン全体情報を入れる配列
    var resutaurantList :[(
        id:String , // レストランID
        name:String , // レストラン名
        address:String , // 住所
        access:String , // 交通アクセス
        genre:[String: String] , // ジャンル
        middle_area:[String: String] , // 中エリアコード
        photo:[String: String] , // レストランの写真
        open:String , // 営業時間
        close:String , // 定休日
        catchs:String , // お店キャッチ
        budget:[String: String] , // 平均予算
        capacity:Int , // 総席数
        lat:Double , // 緯度
        lng:Double // 経度
    )] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 検索した指定距離表示
        distanceField.text! += searchList["distance"]!
        // 検索したジャンル表示
        if searchList["genre"] != "" {
            genreField.text! += searchList["genre"]!
        } else {
            genreField.text! += "指定なし" // 指定ジャンルがなければ指定なしと表示
        }
        // 検索したキーワード表示
        if searchList["keyword"] != "" {
            restaurantNameField.text! += searchList["keyword"]!
        } else {
            restaurantNameField.text! += "なし" // 指定したキーワードがなければなしと記述
        }
        // 検索結果数表示
        listNumberField.text = "見つかったレストラン数：" + String(resutaurantList.count) + "店舗"
        
        // 検索結果が０件の場合
        if resutaurantList.count == 0 {
            tableView.isHidden = true // テーブルを見えなくする
        }
        
        // デザイン
        let bottomBorder1 = CALayer()
        bottomBorder1.frame = CGRect(x: 0, y: titleView.frame.height, width: titleView.frame.width - 40, height:1.0)
        bottomBorder1.backgroundColor = UIColor(red: 255/255, green: 190/255, blue: 61/255, alpha: 0.66).cgColor
        titleView.layer.addSublayer(bottomBorder1)
    }
    
    // MARK: - レストラン一覧を作成するテーブル関連
    // 配列数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resutaurantList.count
    }

    // セル作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RestaurantListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantListTableViewCell
        // 一覧に表示する項目
        cell.GenreField?.text = resutaurantList[indexPath.row].genre["name"]! // ジャンル名
        let url = URL(string: resutaurantList[indexPath.row].photo["m"]!) // レストラン画像
        if let image_data = try? Data(contentsOf: url!){
            cell.ImageView?.image = UIImage(data: image_data)
        }
        cell.RestaurantNameField?.text = resutaurantList[indexPath.row].name // レストラン名
        cell.AddressField?.text = resutaurantList[indexPath.row].address // 住所
        cell.openField?.text = resutaurantList[indexPath.row].open // 営業日
        cell.AccessField?.text = resutaurantList[indexPath.row].access // 交通アクセス
        cell.AccessField?.adjustsFontSizeToFitWidth = true // 枠内に文字を収める
        
        // 選択された背景色を薄いグレーに設定
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        cell.selectedBackgroundView = cellSelectedBgView
        
        return cell
    }
    
    // セルの高さ変更
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 210
    }
    
    // レストラン選択後詳細画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 戻るボタンのタイトルを"一覧に戻る"に変更します。
        let backButton = UIBarButtonItem()
        backButton.title = "一覧に戻る"
        navigationItem.backBarButtonItem = backButton
        
        // 詳細画面に遷移
        let detailRestaurantViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailRestaurantViewController") as! DetailRestaurantViewController
        detailRestaurantViewController.resutaurantList = resutaurantList[indexPath.row]
        self.navigationController?.pushViewController(detailRestaurantViewController, animated: true)
    }
    
    // MARK: - 検索条件変更ボタンがタップされた時
    @IBAction func changeSearchContentButtonTapped(_ sender: Any) {
        // 検索画面に遷移
        self.navigationController?.popViewController(animated: true)
    }
}
