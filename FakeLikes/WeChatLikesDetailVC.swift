//
//  WeChatLikesDetailVC.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/3/27.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class WeChatLikesDetailVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate {
    var avatar:UIImage!
    var name = "微信名称"
    var bio = ""
    var images = [UIImage]()
    var avatars = ["597940087",
                   "597940081",
                   "597940378",
                   "597940348",
                   "597940201",
                   "597940323",
                   "597940248",
                   "597940139",
                   "597940331",
                   "597940283",
                   "597940157",
                   "597939952"]
    var likesNumber = 0

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var bioLb: UILabel!
    @IBOutlet var bioLbConstraints: NSLayoutConstraint!
    @IBOutlet var collectionAndNameConstraints: NSLayoutConstraint!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var likesCollectionView: UICollectionView!
    @IBOutlet var createTimeLb: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var moreBtn: UIButton!
    
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var likesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    //scrollView与底部键盘View的约束
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var keyboardBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentInputField: UITextField!
    
    var blackMaskView = UIView()
    var blackMaskImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.image = avatar
        nameLb.text = name
        bioLb.text = bio
        if bio == ""{
            collectionAndNameConstraints.constant = -15
        }
        //发表时间需要做些处理
        let calendar:Calendar = Calendar(identifier: .gregorian)
        let currentTimes = calendar.dateComponents([.hour, .minute], from: Date())
        createTimeLb.text = "\(currentTimes.hour! < 10 ? "0" : "")\(currentTimes.hour!):\(currentTimes.minute! < 10 ? "0" : "")\(currentTimes.minute!)"
        
        //设置图片
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        switch images.count {
        case 0:
            collectionViewWidthConstraint.constant = 0
            collectionViewHeightConstraint.constant = 0
        case 1:
            let image = images.first
            if (image?.size.width)! > (image?.size.height)!{
                collectionViewWidthConstraint.constant = 230
                collectionViewHeightConstraint.constant = (image?.size.height)!/(image?.size.width)!*230
                layout.itemSize = CGSize(width: collectionViewWidthConstraint.constant, height: collectionViewHeightConstraint.constant)
            }else{
                collectionViewHeightConstraint.constant = 150
                collectionViewWidthConstraint.constant = (image?.size.width)!/(image?.size.height)!*150
                layout.itemSize = CGSize(width: collectionViewWidthConstraint.constant, height: collectionViewHeightConstraint.constant)
            }
        case 2:
            collectionViewWidthConstraint.constant = 152
            collectionViewHeightConstraint.constant = 74
            layout.itemSize = CGSize(width: 74, height: 74)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 4:
            collectionViewWidthConstraint.constant = 152
            collectionViewHeightConstraint.constant = 152
            layout.itemSize = CGSize(width: 74, height: 74)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 3:
            collectionViewWidthConstraint.constant = 230
            collectionViewHeightConstraint.constant = 74
            layout.itemSize = CGSize(width: 74, height: 74)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 5,6:
            collectionViewWidthConstraint.constant = 230
            collectionViewHeightConstraint.constant = 152
            layout.itemSize = CGSize(width: 74, height: 74)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        case 7,8,9:
            collectionViewWidthConstraint.constant = 230
            collectionViewHeightConstraint.constant = 230
            layout.itemSize = CGSize(width: 74, height: 74)
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
        default:
            break
        }
        imagesCollectionView.collectionViewLayout = layout
        
        //设置点赞
        likesCollectionView.delegate = self
        likesCollectionView.dataSource = self
        
        if likesNumber > 6 {
            let lines = likesNumber/6 + (likesNumber%6 == 0 ? 0 : 1)
            let constant = 35*lines+17+(lines-1) * 5
            likesCollectionViewHeightConstraint.constant = CGFloat(constant)
        }else if likesNumber == 0{
            likesCollectionViewHeightConstraint.constant = 0
        }
        
        //点击图片预览界面
        blackMaskView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        blackMaskView.backgroundColor = UIColor.black
        blackMaskView.alpha = 0.0
        
        blackMaskImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        blackMaskImageView.center = blackMaskView.center
        blackMaskView.addSubview(blackMaskImageView)
        UIApplication.shared.keyWindow?.addSubview(blackMaskView)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeImagePreview))
        tapGesture.numberOfTapsRequired = 1
        blackMaskView.addGestureRecognizer(tapGesture)
        
        //设置导航栏
        let finish = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(leftNarBtnAction))
        self.navigationItem.leftBarButtonItem = finish
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
        
        //设置头像与昵称点击错误
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(networkError))
        avatarTap.numberOfTapsRequired = 1
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(networkError))
        nameTap.numberOfTapsRequired = 1
        avatarImageView.addGestureRecognizer(avatarTap)
        nameLb.addGestureRecognizer(nameTap)
        
        //监听键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        //设置评论输入框
        commentInputField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            self.view.endEditing(true)
            textField.text = ""
            networkError()
        }
        return true
    }
    @objc func showKeyboard(notification:Notification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        scrollViewBottomConstraint.constant = rect.cgRectValue.height
        keyboardBottomConstraint.constant = rect.cgRectValue.height
    }
    @objc func hideKeyboard(notification:Notification){
        //print(notification)
        scrollViewBottomConstraint.constant = 0
        keyboardBottomConstraint.constant = 0
    }
    @objc func leftNarBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return images.count
        }else{
            return likesNumber
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeChatLikesDetailImagesCell
            cell.image.image = images[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! WeChatLikesDetailImagesCell
            let QQNumber = 597939931+Int(arc4random()%500)+1
            let imageUrl = "http://q1.qlogo.cn/g?b=qq&nk=\(QQNumber)&s=40"
            print(QQNumber)
            cell.image.imageFromURL(imageUrl, placeholder: UIImage(named: "默认点赞头像")!)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            blackMaskImageView.image = images[indexPath.row]
            UIView.animate(withDuration: 0.2, animations: {
                self.blackMaskImageView.alpha = 1.0
                self.blackMaskView.alpha = 1.0
                self.blackMaskImageView.frame.size.width = UIScreen.main.bounds.size.width
                self.blackMaskImageView.frame.size.height = UIScreen.main.bounds.size.width
                self.blackMaskImageView.center = self.blackMaskView.center
            })
        }
    }
    @objc func closeImagePreview(){
        UIView.animate(withDuration: 0.2) {
            self.blackMaskView.alpha = 0.0
            self.blackMaskImageView.frame.size.width = UIScreen.main.bounds.size.width/10
            self.blackMaskImageView.frame.size.height = UIScreen.main.bounds.size.width/10
            self.blackMaskImageView.center = self.blackMaskView.center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func networkError(){
        self.noticeInfo("网络错误", autoClear: true, autoClearTime: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
