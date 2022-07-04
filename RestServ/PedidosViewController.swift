//
//  PedidosViewController.swift
//  RestServ
//
//  Created by Mac 01 on 25/06/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PedidosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //var pedidos:[AnyObject] = []
    
    var pedidos:[Pedido] = []
    
    @IBOutlet weak var listaPedidos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listaPedidos.dataSource = self
        listaPedidos.delegate = self
        
        let correo = Auth.auth().currentUser?.email
        let usuario_correo = correo!.replacingOccurrences(of: ".", with: ",")
        
        Database.database().reference().child("clientes").child(usuario_correo).child("pedidos").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            print("resultados")
            let pedido = Pedido()
            pedido.ID = snapshot.key
            pedido.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            self.pedidos.append(pedido)
            self.listaPedidos.reloadData()
            })
        
        Database.database().reference().child("clientes").child(usuario_correo).child("pedidos").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.pedidos{
                if snap.ID == snapshot.key{
                    self.pedidos.remove(at: iterator)
                }
                iterator += 1
            }
            self.listaPedidos.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pedidos.count == 0 {
            return 1
        }
        else {
            return pedidos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell()
        if pedidos.count == 0 {
            celda.textLabel?.text = "No se tiene ningun pedido"
        }
        else {
            let pedido = pedidos[indexPath.row].Nombre
            celda.textLabel?.text = "\(pedido)"
        }
        return celda
    }

    @IBAction func btnCerrarSesion(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            dismiss(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
