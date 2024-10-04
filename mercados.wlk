import wollok.game.*

class Mercado {
    var property position = null
    const inventario = []
    var property dinero = 1000
  
    method image() {
        return "market.png"
    }

    method comprar(objetos, precio) {
        inventario.addAll(objetos)
        dinero -= precio
    }

    method puedeComprar(precio) {
      return dinero >= precio
    }
}