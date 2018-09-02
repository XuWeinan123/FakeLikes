//
//  WeiBoLikesVC.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/3/28.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeiBoLikesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var avatarOutsideBorders: UIView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var sourceView: UIView!
    @IBOutlet var sourceLb: UILabel!
    @IBOutlet var repostView: UIView!
    @IBOutlet var repostNumberLb: UILabel!
    @IBOutlet var commentView: UIView!
    @IBOutlet var commentNumberLb: UILabel!
    @IBOutlet var likeView: UIView!
    @IBOutlet var likeNumberLb: UILabel!
    @IBOutlet var generateView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bioTextView: UITextView!
    var placeHolderLabel = UILabel()
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
        avatarOutsideBorders.layer.cornerRadius = avatarOutsideBorders.frame.width/2
        avatar.layer.cornerRadius = avatar.frame.width/2
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //textView的placeHold设置
        bioTextView.delegate = self
        placeHolderLabel.frame = CGRect(x: 4, y: 8, width: 112, height: 16)
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16)
        placeHolderLabel.numberOfLines = 1
        placeHolderLabel.text = "这一刻的想法…"
        placeHolderLabel.textColor = UIColor(hexString: "#A9A9A9")
        bioTextView.addSubview(placeHolderLabel)
        
        //手势设置
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapAction))
        avatarTapGesture.numberOfTapsRequired = 1
        avatar.addGestureRecognizer(avatarTapGesture)
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(nameTapAction))
        nameTapGesture.numberOfTapsRequired = 1
        nameView.addGestureRecognizer(nameTapGesture)
        let sourceTapGesture = UITapGestureRecognizer(target: self, action: #selector(sourceTapAction))
        sourceTapGesture.numberOfTapsRequired = 1
        sourceView.addGestureRecognizer(sourceTapGesture)
        let repostTapGesture = UITapGestureRecognizer(target: self, action: #selector(repostTapAction))
        repostTapGesture.numberOfTapsRequired = 1
        repostView.addGestureRecognizer(repostTapGesture)
        let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(commentTapAction))
        commentTapGesture.numberOfTapsRequired = 1
        commentView.addGestureRecognizer(commentTapGesture)
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapAction))
        likeTapGesture.numberOfTapsRequired = 1
        likeView.addGestureRecognizer(likeTapGesture)
        let generateTapGesture = UITapGestureRecognizer(target: self, action: #selector(generateTapAction))
        generateTapGesture.numberOfTapsRequired = 1
        generateView.addGestureRecognizer(generateTapGesture)
        
        //监听键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            self.placeHolderLabel.text = "分享新鲜事…"
        }else{
            self.placeHolderLabel.text = ""
        }
    }
    @objc func showKeyboard(notification:Notification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        scrollViewBottomConstraint.constant = rect.cgRectValue.height
    }
    @objc func hideKeyboard(notification:Notification){
        //print(notification)
        scrollViewBottomConstraint.constant = 0
    }
    @objc func nameTapAction(){
        let nameAlertInput = UIAlertController(title: "更换名称", message: nil, preferredStyle: .alert)
        nameAlertInput.addTextField { (textField) in
            textField.placeholder = "展示用的微博名称"
            textField.text = self.nameLb.text
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.nameLb.text = nameAlertInput.textFields?.first?.text
        }
        nameAlertInput.addAction(cancel)
        nameAlertInput.addAction(ok)
        self.present(nameAlertInput, animated: true, completion: nil)
    }
    @objc func sourceTapAction(){
        let sourceAlertInput = UIAlertController(title: "更换来源", message: nil, preferredStyle: .alert)
        sourceAlertInput.addTextField { (textField) in
            textField.placeholder = "微博来源"
            textField.text = self.sourceLb.text
        }
        let cancel = UIAlertAction(title: "取消", style: .default) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.sourceLb.text = sourceAlertInput.textFields?.first?.text
        }
        sourceAlertInput.addAction(cancel)
        sourceAlertInput.addAction(ok)
        self.present(sourceAlertInput, animated: true, completion: nil)
    }
    @objc func repostTapAction(){
        let repostAlertInput = UIAlertController(title: "转发数量", message: nil, preferredStyle: .alert)
        repostAlertInput.addTextField { (textField) in
            textField.delegate = self
            textField.text = self.repostNumberLb.text
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.repostNumberLb.text = repostAlertInput.textFields?.first?.text
        }
        repostAlertInput.addAction(cancel)
        repostAlertInput.addAction(ok)
        self.present(repostAlertInput, animated: true, completion: nil)
    }
    @objc func commentTapAction(){
        let commentAlertInput = UIAlertController(title: "评论数量", message: nil, preferredStyle: .alert)
        commentAlertInput.addTextField { (textField) in
            textField.delegate = self
            textField.text = self.commentNumberLb.text
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.commentNumberLb.text = commentAlertInput.textFields?.first?.text
        }
        commentAlertInput.addAction(cancel)
        commentAlertInput.addAction(ok)
        self.present(commentAlertInput, animated: true, completion: nil)
    }
    @objc func likeTapAction(){
        let likeAlertInput = UIAlertController(title: "点赞数量", message: nil, preferredStyle: .alert)
        likeAlertInput.addTextField { (textField) in
            textField.delegate = self
            textField.text = self.likeNumberLb.text
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.likeNumberLb.text = likeAlertInput.textFields?.first?.text
        }
        likeAlertInput.addAction(cancel)
        likeAlertInput.addAction(ok)
        self.present(likeAlertInput, animated: true, completion: nil)
    }
    @objc func generateTapAction(){
        self.pleaseWait()
        let weiBoLikesDetail = self.storyboard?.instantiateViewController(withIdentifier: "WeiBoLikesDetail") as! WeiBoLikesDetailVC
        weiBoLikesDetail.avatarImage = avatar.image
        weiBoLikesDetail.name = nameLb.text!
        let calendar:Calendar = Calendar(identifier: .gregorian)
        let currentTimes = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
        weiBoLikesDetail.time = "\(currentTimes.month!)-\(currentTimes.day!) \(currentTimes.hour! < 10 ? "0" : "")\(currentTimes.hour!):\(currentTimes.minute! < 10 ? "0" : "")\(currentTimes.minute!)"
        weiBoLikesDetail.source = sourceLb.text!
        weiBoLikesDetail.content = bioTextView.text
        weiBoLikesDetail.images = images
        weiBoLikesDetail.repostsNumber = Int(repostNumberLb.text!)!
        weiBoLikesDetail.commentsNumber = Int(commentNumberLb.text!)!
        weiBoLikesDetail.likesNumber = Int(likeNumberLb.text!)!
        
        print("点击了生成按钮")
        guard weiBoLikesDetail.likesNumber > 0 else{
            self.clearAllNotice()
            self.navigationController?.pushViewController(weiBoLikesDetail, animated: true)
            return
        }
        //从网络获取昵称
        var names = [String]()
        for i in 0..<weiBoLikesDetail.likesNumber{
            Alamofire.request("http://api.sinchang.me/random/user").response { (response) in
                if let data = response.data{
                    let json = JSON(data)
                    names.append(json["items"]["name"].description)
                    print(json["items"]["name"])
                    print(i)
                    if i == weiBoLikesDetail.likesNumber-1{
                        weiBoLikesDetail.names = names
                        self.clearAllNotice()
                        self.navigationController?.pushViewController(weiBoLikesDetail, animated: true)
                    }
                }
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制只能输入数字，不能输入特殊字符
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char < 48 { return false }
            if char > 57 { return false }
        }
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > 3 { return false }
        return true
    }
    @objc func avatarTapAction(){
        avatar.tag = 1
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if avatar.tag == 1{
            avatar.image = (info[UIImagePickerControllerEditedImage] as? UIImage)?.cropToSquare()
            self.dismiss(animated: true, completion: {
                self.avatar.tag = 0
            })
        }else{
            images.append(((info[UIImagePickerControllerEditedImage] as? UIImage)?.cropToSquare())!)
            collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true, completion: {
                self.collectionView.tag = 1
            })
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 0{
            return 1
        }else{
            return images.count+1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeChatImagePickerCell
        if indexPath.row == images.count{
            cell.imagePickerView.image = UIImage(named: "添加图片logo")
        }else{
            cell.imagePickerView.image = images[indexPath.row]
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
