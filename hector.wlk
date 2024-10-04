import aspersor.*
import wollok.game.*
import cultivos.*
import mercados.*

object hector { 
	var property position = game.center()
	const property image = "player.png"
	const inventario = []
	var property monedas = 0
	const casa = granja

	method mover(direccion) {
		self.validarPosicion(direccion.siguiente(position))
		position = direccion.siguiente(position)
	}

	method validarPosicion(direccion) {
		if(self.noEstaEnElTablero(direccion)) {
			self.error("")
		}
	}

	method noEstaEnElTablero(direccion) {
		return !direccion.x().between(0, game.width() -1) or
				!direccion.y().between(0, game.height() - 1)
	}

	method plantar(planta) {
		self.validarObjetoAqui(0, "No es una parcela vacía")
	  	casa.sembrarAqui(planta)
	}

	method validarObjetoAqui(cantidad, mensaje) {
		if(game.colliders(self).size() != cantidad) {
			self.error(mensaje)
		}
	}

	method regar() {
		self.validarPlantaAqui()
		self.plantaAqui().regarse()
	}

	method plantaAqui() {
	  	return casa.cultivoEn(self.position())
	}

	method validarPlantaAqui() {
		if(!casa.hayCultivoEn(self.position())) {
			self.error("No hay cultivos aquí")
		}
	}

	method cosechar() {
	  	self.validarCosecha()
		self.almacenarPlanta(self.plantaAqui())
		casa.cosechadaAqui(self.plantaAqui())
	}

	method validarCosecha() {
		self.validarPlantaAqui()
	  	if(!self.plantaAqui().puedeCosecharse()) {
			self.error("Todavía no está listo para cosechar")
	  	}
	}

	method almacenarPlanta(planta) {
	  	inventario.add(planta)
	}
	
	method validarMercadoAqui() {
		if(!casa.hayMercadoEn(self.position())) {
			self.error("No hay un mercado aquí")
		}
	}

	method validarVentaDeMercadoAqui() {
		if(!game.uniqueCollider(self).puedeComprar(self.valorInventario())) {
			self.error("No puedo vender Aquí")
	  	}
	}

	method valorInventario() {
	  return inventario.sum({planta => planta.valor()})
	}
	method venderleAMercado() {
		self.validarVentaDeMercadoAqui()
		self.venderA(game.uniqueCollider(self))
	}

	method venderA(mercado) {
		mercado.comprar(inventario, self.valorInventario())
	  	monedas += self.valorInventario()
		inventario.clear()
	}

	method plantasYOro() {
	  return "Tengo " + monedas.toString() + " monedas, y "
	  		+ self.plantasObtenidas().toString() + " plantas para vender."
	}
 
	method plantasObtenidas() {
	  	return inventario.size()
	}

	method colocarORemoverAspersor() {
		if(casa.esCeldaVacia(self.position())) {
			casa.aspersorEn(self.position())
		} else if(casa.hayAspersorEn(self.position())) {
			casa.removerAspersor(game.uniqueCollider(self))
		}
	}
}

object granja {
  	var property cultivosSembrados = #{}
	var property aspersores = #{}
	var property mercados = #{}


	method esCeldaVacia(posicion) {
		return !self.hayCultivoEn(posicion) and !self.hayAspersorEn(posicion) and
					!self.hayMercadoEn(posicion)
	}

	method hayCultivoEn(posicion) {
	  	return cultivosSembrados.any({planta => planta.position() == posicion})
	}

	method cultivoEn(posicion) {
		return cultivosSembrados.find({cultivo => cultivo.position() == posicion})
	}

	method hayAspersorEn(posicion) {
	  	return aspersores.any({aspersor => aspersor.position() == posicion})
	}

	method hayMercadoEn(posicion) {
	  	return mercados.any({mercado => mercado.position() == posicion})
	}

	method sembrarAqui(cultivo) {
		cultivosSembrados.add(cultivo)
		game.addVisual(cultivo)
	}

	method cosechadaAqui(cultivo) {
		cultivosSembrados.remove(cultivo)
		cultivo.cosecharse()
	}

	method aspersorEn(posicion) {
		const aspersor = new Aspersor(position = posicion)
		game.addVisual(aspersor)
		aspersores.add(aspersor)
		aspersor.comenzarARegar()
	}

	method removerAspersor(aspersor) {
		aspersor.dejarDeRegar()
		game.removeVisual(aspersor)
		aspersores.remove(aspersor)
	}

	method mercadoEn(posicion) {
		const mercado = new Mercado(position = posicion)
		game.addVisual(mercado)
		mercados.add(mercado)
	}
}

// movimiento
object arriba {
	method siguiente(position) {
		return position.up(1)
	}
}
object abajo {
	method siguiente(position) {
		return position.down(1)
	}	
}
object izquierda {
	method siguiente(position) {
		return position.left(1)
	}
}
object derecha {
	method siguiente(position) {
		return position.right(1)
	}
}