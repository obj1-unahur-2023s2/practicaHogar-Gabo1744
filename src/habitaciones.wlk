import casas.*
import familias.*

class Habitacion {
	const property ocupantes = #{}
	method nivelDeConfort(persona) = 10 
	
	method quitarOcupante(ocupante){
		ocupantes.remove(ocupante)
	}
	
	method edadDeOcupantes() = ocupantes.map({o => o.edad()})
	
	method estaVacia() = ocupantes.isEmpty()
	
	method entrar(unaPersona){
		if(self.estaVacia() or self.puedeEntrar(unaPersona)){ 
			unaPersona.habitacion().quitarOcupante(unaPersona)
			ocupantes.add(unaPersona)
			unaPersona.habitacion(self)
			
		}
	}
	
	method puedeEntrar(unaPersona)
	
}

class UsoGeneral inherits Habitacion{
	
	override method puedeEntrar(unaPersona) = true
	
}

class Dormitorio inherits Habitacion{	
	const duermen = []
	
	method duermeEnLaHabitacion(persona) = duermen.contains(persona)
	
	override method nivelDeConfort(persona) = super(persona) +  if(self.duermeEnLaHabitacion(persona)){(10 / duermen.size())}else{0}

	override method puedeEntrar(unaPersona){
		return self.duermeEnLaHabitacion(unaPersona) or ocupantes.all({o => self.duermeEnLaHabitacion(o)})
	}

}

class Banio inherits Habitacion{
	
	override method nivelDeConfort(persona) =  super(persona) + if (persona.edad()<=4){2}else{4}
	
	override method puedeEntrar(unaPersona) = ocupantes.any({o => o.edad() <= 4})
}


class Cocina inherits Habitacion{
	const porcentajeUnidades = unidades
	var metrosCuadrados
	
	method unidadesDeConfort() = metrosCuadrados * porcentajeUnidades.unidades()
	
	override method nivelDeConfort(persona) = super(persona) + if(persona.tieneHablidadEnCocina()){self.unidadesDeConfort()}else{0}

	override method puedeEntrar(unaPersona) = (unaPersona.tieneHablidadEnCocina() and not ocupantes.any({o => o.tieneHablidadEnCocina()})) or not unaPersona.tieneHablidadEnCocina()

}

object unidades{
	
	var property unidades = 0.1
}