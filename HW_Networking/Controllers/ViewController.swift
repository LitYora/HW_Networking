//
//  ViewController.swift
//  HW_Networking
//
//  Created by Matvei  on 23.11.2020.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var swPeople = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureTableView()

        
    }
    
    private func loadData(){
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://swapi.dev/api/people/")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            
            }
            
            let response = response as! HTTPURLResponse
            guard let data = data else {
                print("Data Error occured. Responce status code: \(response.statusCode)")
                return
            }
            
            do{
                
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?]
                
                if let results = jsonArray?["results"] as? [ [String: Any?] ] {
                    for object in results{
                    if let name = object["name"] as? String,
                       let hair_color = object["hair_color"] as? String{
                        self.swPeople.append(People(name: name, hair_color: hair_color))
                    }
                }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
            }
        }
            catch (let jsonError){
                
                print(jsonError)
            }
        }
        task.resume()
    }
   
func configureTableView(){
    tableView.delegate = self
    tableView.dataSource = self
    
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as! CustomCell
        let person = swPeople[indexPath.row]
        
        cell.imageSpace.image = UIImage(named: "space")
        
//        cell.textLabel?.text = person.name
//        cell.detailTextLabel?.text = person.hair_color
        cell.firstLabel.text = person.name
        cell.secondLabel.text = "Hair: \(person.hair_color)"
        
        
        return cell
    }
    
    

}
