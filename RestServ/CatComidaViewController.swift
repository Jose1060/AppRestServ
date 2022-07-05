//
//  CatComidaViewController.swift
//  RestServ
//
//  Created by Mac 01 on 25/06/22.
//

import UIKit
import FirebaseDatabase

class CatComidaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - variables
    var comidas:[Comida] = []
    
    
    @IBOutlet weak var listaComidas: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaComidas.dataSource = self
        listaComidas.delegate = self
 
        let a = Database.database().reference().child("comidas").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            print("resultados")
            let comida = Comida()
            comida.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            comida.Precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            comida.Tiempo = (snapshot.value as! NSDictionary)["tiempo"] as! Double
            comida.Imagen = (snapshot.value as! NSDictionary)["imagen"] as! String
            self.comidas.append(comida)
            self.listaComidas.reloadData()
        })
        print(a)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comidas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let celda = tableView.dequeueReusableCell(withIdentifier: "comidaCelda", for: indexPath)
            let comida = comidas[indexPath.row]
            celda.textLabel?.text = comida.Nombre
            celda.detailTextLabel?.text = "S/. " + String(comida.Precio)
            
            celda.imageView?.sd_setImage(with: URL(string: comida.Imagen), placeholderImage: UIImage(named: "pastel"), completed : nil)

            return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comida = comidas[indexPath.row]
        performSegue(withIdentifier: "seguePedidoComida", sender: comida)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePedidoComida" {
            let siguienteVC = segue.destination as! RealizarPedidoViewController
            siguienteVC.comida = sender as! Comida
            siguienteVC.pedido = "comida"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
