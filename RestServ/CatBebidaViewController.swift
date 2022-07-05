//
//  CatBebidaViewController.swift
//  RestServ
//
//  Created by Mac 01 on 25/06/22.
//

import UIKit
import FirebaseDatabase

class CatBebidaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listaBebidas: UITableView!
    
    var bebidas:[Bebida] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaBebidas.dataSource = self
        listaBebidas.delegate = self
        let a = Database.database().reference().child("bebidas").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            print("resultados")
            let bebida = Bebida()
            bebida.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            bebida.Precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            bebida.Tiempo = (snapshot.value as! NSDictionary)["tiempo"] as! Double
            bebida.Imagen = (snapshot.value as! NSDictionary)["imagen"] as! String
            self.bebidas.append(bebida)
            self.listaBebidas.reloadData()
        })
        print(a)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bebidas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "bebidaCelda", for: indexPath)
        let bebida = bebidas[indexPath.row]
        celda.textLabel?.text = bebida.Nombre
        celda.detailTextLabel?.text = "S/. " + String(bebida.Precio)
        
        celda.imageView?.sd_setImage(with: URL(string: bebida.Imagen), placeholderImage: UIImage(named: "pastel"), completed : nil)

        return celda
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bebida = bebidas[indexPath.row]
        performSegue(withIdentifier: "seguePedidoBebida", sender: bebida)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePedidoBebida" {
            let siguienteVC = segue.destination as! RealizarPedidoViewController
            siguienteVC.bebida = sender as! Bebida
            siguienteVC.pedido = "bebida"
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
