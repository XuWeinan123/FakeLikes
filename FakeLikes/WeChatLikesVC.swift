//
//  WeChatLikesVC.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/3/27.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class WeChatLikesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet var avatarView: UIView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var likesView: UIView!
    @IBOutlet var likesNumberLb: UILabel!
    @IBOutlet var bioTextView: UITextView!
    var placeHolderLabel = UILabel()
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var generateBtn: UIButton!
    
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //手势设置
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapAction))
        avatarTapGesture.numberOfTapsRequired = 1
        avatarView.addGestureRecognizer(avatarTapGesture)
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(nameTapAction))
        nameTapGesture.numberOfTapsRequired = 1
        nameView.addGestureRecognizer(nameTapGesture)
        let likesTapGesture = UITapGestureRecognizer(target: self, action: #selector(likesTapAction))
        likesTapGesture.numberOfTapsRequired = 1
        likesView.addGestureRecognizer(likesTapGesture)
        
        //网格列表设置
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //textView的placeHold设置
        bioTextView.delegate = self
        placeHolderLabel.frame = CGRect(x: 4, y: 8, width: 112, height: 16)
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16)
        placeHolderLabel.numberOfLines = 1
        placeHolderLabel.text = "这一刻的想法…"
        placeHolderLabel.textColor = UIColor(hexString: "#A9A9A9")
        bioTextView.addSubview(placeHolderLabel)
        
        generateBtn.layer.cornerRadius = 4
        generateBtn.layer.borderColor = UIColor(red: 21/255.0, green: 157/255.0, blue: 21/255.0, alpha: 1.0).cgColor
        generateBtn.layer.borderWidth = 1
        generateBtn.layer.masksToBounds = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"导航栏背景"), for: UIBarMetrics.default)
        // Do any additional setup after loading the view.
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            self.placeHolderLabel.text = "这一刻的想法…"
        }else{
            self.placeHolderLabel.text = ""
        }
    }
    func setUI(){
        avatarImageView.layer.cornerRadius = 3
    }
    @objc func avatarTapAction(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    @objc func nameTapAction(){
        let nameAlertInput = UIAlertController(title: "更换名称", message: nil, preferredStyle: .alert)
        nameAlertInput.addTextField { (textField) in
            textField.placeholder = "展示用的微信名称"
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
    @objc func likesTapAction(){
        let likesAlertInput = UIAlertController(title: "点赞数量", message: nil, preferredStyle: .alert)
        likesAlertInput.addTextField { (textField) in
            textField.delegate = self
            textField.text = self.likesNumberLb.text
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.view.endEditing(true)
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            self.likesNumberLb.text = likesAlertInput.textFields?.first?.text
        }
        likesAlertInput.addAction(cancel)
        likesAlertInput.addAction(ok)
        self.present(likesAlertInput, animated: true, completion: nil)
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
    @IBAction func generateBtnAction(_ sender: UIButton) {
        let weChatLikesDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WeChatLikesDetail") as! WeChatLikesDetailVC
        weChatLikesDetailVC.avatar = avatarImageView.image
        weChatLikesDetailVC.name = nameLb.text!
        weChatLikesDetailVC.bio = bioTextView.text!
        weChatLikesDetailVC.images = images
        weChatLikesDetailVC.likesNumber = Int(likesNumberLb.text!)!
        self.navigationController?.pushViewController(weChatLikesDetailVC, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if collectionView.tag != 1{
            avatarImageView.image = (info[UIImagePickerControllerEditedImage] as? UIImage)?.cropToSquare()
            self.dismiss(animated: true, completion: nil)
        }else{
            images.append(((info[UIImagePickerControllerEditedImage] as? UIImage)?.cropToSquare())!)
            collectionView.reloadData()
            self.dismiss(animated: true, completion: {
                self.collectionView.tag = 0
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
