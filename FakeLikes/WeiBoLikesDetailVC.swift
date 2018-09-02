//
//  WeiBoLikesDetailVC.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/3/29.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Alamofire
import Ji
import SwiftyJSON

class WeiBoLikesDetailVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate {
    var avatarImage:UIImage?
    var name = ""
    var time = ""
    var source = ""
    var content = ""
    var repostsNumber = 0
    var commentsNumber = 0
    var likesNumber = 0
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var timeLb: UILabel!
    @IBOutlet var sourceLb: UILabel!
    @IBOutlet var contentLb: UILabel!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var likesTableView: UITableView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var repostsNumberLb: UILabel!
    @IBOutlet var commentsNumberLb: UILabel!
    @IBOutlet var likesNumberLb: UILabel!
    
    var images = [UIImage]()
    var likePersons = [LikePerson]()
    
    var avatarUrls = ["597939932","597939934","597939935","597939936","597939937","597939938","597939940","597939941","597939942","597939943","597939945","597939946","597939947","597939948","597939950","597939949","597939951","597939953","597939952","597939954","597939956","597939957","597939958","597939959","597939960","597939961","597939963","597939964","597939962","597939965","597939967","597939968","597939969","597939970","597939971","597939972","597939973","597939974","597939975","597939976","597939978","597939979","597939980","597939981","597939983","597939982","597939984","597939985","597939986","597939987","597939989","597939990","597939991","597939992","597939993","597939994","597939995","597939996","597939997","597939998","597939999","597940000","597940001","597940002","597940003","597940004","597940005","597940006","597940007","597940008","597940009","597940010","597940012","597940013","597940014","597940015","597940016","597940017","597940018","597940019","597940020","597940021","597940023","597940024","597940025","597940026","597940027","597940028","597940029","597940031","597940032","597940034","597940035","597940036","597940037","597940038","597940039","597940040","597940041","597940042","597940043","597940045","597940046","597940050","597940047","597940048","597940049","597940053","597940051","597940052","597940054","597940057","597940056","597940058","597940060","597940061","597940062","597940059","597940063","597940064","597940067","597940068","597940070","597940065","597940069","597940071","597940072","597940074","597940075","597940073","597940076","597940078","597940079","597940080","597940081","597940082","597940085","597940084","597940083","597940087","597940090","597940086","597940091","597940093","597940092","597940089","597940095","597940094","597940097","597940098","597940100","597940101","597940102","597940103","597940104","597940105","597940106","597940107","597940108","597940109","597940110","597940111","597940112","597940113","597940114","597940116","597940117","597940118","597940119","597940120","597940121","597940122","597940123","597940124","597940125","597940126","597940127","597940128","597940129","597940131","597940130","597940133","597940134","597940132","597940135","597940138","597940137","597940136","597940139","597940140","597940141","597940142","597940145","597940144","597940147","597940149","597940143","597940146","597940148","597940151","597940153","597940150","597940154","597940156","597940158","597940155","597940157","597940160","597940161","597940164","597940163","597940159","597940162","597940167","597940166","597940165","597940168","597940169","597940171","597940170","597940174","597940176","597940177","597940175","597940172","597940173","597940178","597940180","597940181","597940183","597940182","597940179","597940184","597940186","597940185","597940187","597940188","597940191","597940189","597940195","597940194","597940192","597940193","597940197","597940198","597940201","597940196","597940199","597940202","597940204","597940203","597940205","597940207","597940200","597940206","597940208","597940209","597940210","597940212","597940211","597940215","597940213","597940216","597940218","597940217","597940220","597940214","597940223","597940222","597940221","597940219","597940224","597940229","597940227","597940225","597940226","597940232","597940230","597940228","597940231","597940235","597940234","597940233","597940237","597940236","597940239","597940242","597940238","597940243","597940241","597940244","597940246","597940240","597940245","597940250","597940248","597940249","597940251","597940253","597940247","597940252","597940254","597940256","597940255","597940257","597940259","597940261","597940258","597940262","597940260","597940264","597940265","597940263","597940266","597940267","597940268","597940274","597940273","597940271","597940270","597940269","597940272","597940276","597940275","597940277","597940278","597940280","597940279","597940282","597940284","597940281","597940286","597940283","597940288","597940287","597940289","597940285","597940292","597940290","597940293","597940294","597940295","597940291","597940296","597940298","597940299","597940300","597940297","597940304","597940302","597940303","597940301","597940307","597940305","597940306","597940312","597940309","597940311","597940310","597940308","597940315","597940314","597940313","597940316","597940317","597940318","597940319","597940320","597940321","597940324","597940323","597940322","597940325","597940326","597940330","597940328","597940332","597940331","597940333","597940329","597940336","597940335","597940334","597940337","597940339","597940338","597940342","597940344","597940340","597940341","597940345","597940343","597940346","597940347","597940350","597940348","597940349","597940352","597940353","597940355","597940354","597940359","597940360","597940357","597940356","597940362","597940351","597940358","597940365","597940361","597940364","597940363","597940370","597940366","597940368","597940373","597940367","597940369","597940371","597940372","597940374","597940377","597940375","597940379","597940376","597940381","597940380","597940382","597940378","597940384","597940383","597940387","597940386","597940389","597940391","597940393","597940385","597940390","597940394","597940395","597940396","597940392","597940388","597940397","597940401","597940398","597940400","597940406","597940399","597940403","597940407","597940404","597940410","597940412","597940402","597940411","597940413","597940405","597940408","597940414","597940417","597940416","597940409","597940421","597940415","597940422","597940424","597940423","597940430","597940425","597940418","597940431","597940426","597940420","597940432","597940429","597940428","597940433","597940427","597940434","597940440","597940435","597940436","597940439","597940438","597940441","597940442","597940437","597940445","597940446","597940444","597940448","597940451","597940450","597940453","597940443","597940447","597940449","597940454","597940456","597940457"]
    var names = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "微博正文"
        
        avatarImageView.image = avatarImage
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        nameLb.text = name
        timeLb.text = time
        sourceLb.text = source
        contentLb.text = content
        contentLb.sizeToFit()
        repostsNumberLb.text = repostsNumber.description
        commentsNumberLb.text = commentsNumber.description
        likesNumberLb.text = likesNumber.description
        
        tableViewHeightConstraint.constant = CGFloat(44+50*likesNumber)
        
        //设置图片
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        likesTableView.delegate = self
        likesTableView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        switch images.count {
        case 0:
            collectionViewHeightConstraint.constant = 0
            collectionViewBottomConstraint.constant = 0
        case 1:
            let image = images.first
            collectionViewHeightConstraint.constant = (UIScreen.main.bounds.width-24)*(image?.size.height)!/(image?.size.width)!
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-24), height: collectionViewHeightConstraint.constant)
        case 2:
            collectionViewHeightConstraint.constant = (UIScreen.main.bounds.width-28)/2
            layout.itemSize = CGSize(width: collectionViewHeightConstraint.constant, height: collectionViewHeightConstraint.constant)
            layout.minimumInteritemSpacing = 4
        case 3:
            collectionViewHeightConstraint.constant = (UIScreen.main.bounds.width-32)/3
            layout.itemSize = CGSize(width: collectionViewHeightConstraint.constant, height: collectionViewHeightConstraint.constant)
            layout.minimumInteritemSpacing = 4
        case 4:
            collectionViewHeightConstraint.constant = UIScreen.main.bounds.width-24
            layout.itemSize = CGSize(width: (collectionViewHeightConstraint.constant-4)/2, height: (collectionViewHeightConstraint.constant-4)/2)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 5,6:
            collectionViewHeightConstraint.constant = ((UIScreen.main.bounds.width-24)-8)*2/3+4
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-32)/3, height: (UIScreen.main.bounds.width-32)/3)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 7,8,9:
            collectionViewHeightConstraint.constant = UIScreen.main.bounds.width-24
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-32)/3, height: (UIScreen.main.bounds.width-32)/3)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        default:
            break
        }
        imagesCollectionView.collectionViewLayout = layout
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeiBoLikesDetailImageCell
        cell.image.image = images[indexPath.row]
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesNumber
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WeiBoLikesDetailLikesCell
        let avatarUrl = avatarUrls[indexPath.row%500]
        cell.avatarImageView.imageFromURL("http://qlogo2.store.qq.com/qzone/\(avatarUrl)/\(avatarUrl)/100", placeholder: UIImage(named: "默认点赞头像")!)
        //cell.nameLb.text = "\(names[indexPath.row]) \(avatarUrl)"
        DispatchQueue.global().async {
            self.downimage(urlStr: "http://q1.qlogo.cn/g?b=qq&nk=\(avatarUrl)&s=100", name: "\(avatarUrl).jpg")
        }
        return cell
    }
    func downimage(urlStr:String,name:String){
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 2.0)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { (response, data, error) in
            var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0]
            print(path)
            var cachepath = (path as NSString).appendingPathComponent(name)
            if let data = data{
                (data as NSData).write(toFile: cachepath, atomically:true);
            }else{
                print("出错:\(name)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    struct LikePerson {
        var avatar:UIImage?
        var name = ""
        init(avatar:UIImage?,name:String) {
            self.avatar = avatar
            self.name = name
        }
    }
}
