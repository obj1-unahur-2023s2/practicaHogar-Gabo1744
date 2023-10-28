class Habitacion {
	const property ocupantes = #{}
	
	method quitarOcupante(unaPersona){
		ocupantes.remove(unaPersona)
	}
	
	method estaVacia() = ocupantes.isEmpty()
	
	method entrar(unaPersona){
		if (not self.estaVacia() and not self.puedeEntrar(unaPersona)){
			self.error("No puede ingresar a la habitacion")
		}
		if(unaPersona.habitacion() != null){
			unaPersona.habitacion().quitarOcupante(unaPersona)
		}
		unaPersona.habitacion(self)
		ocupantes.add(unaPersona)
	}
	
	method puedeEntrar(unaPersona)
	
	method nivelDeConfort(unaPersona) = 10
	
	method ocupanteMasViejos() = ocupantes.max({p => p.edad()})
	
	method nivelDeConfortDeCadaOcupante() = ocupantes.sum({p => self.nivelDeConfort(p)})

	method cantidadEnHabitacion() = ocupantes.size()

}

class UsoGeneral inherits Habitacion{
	
	override method puedeEntrar(unaPersona) = true
	
}

class Banio inherits Habitacion{
	
	override method nivelDeConfort(unaPersona) = super(unaPersona) + if(unaPersona.edad() <= 4){2}else{4}
	
	method hayPersonaMenorA(anio) = ocupantes.any({p => p.edad() < anio})
	
	override method puedeEntrar(unaPersona) = self.hayPersonaMenorA(5)
	
}

class Dormitorio inherits Habitacion{
	const duermen = #{}
	
	method agregarEnDormitorio(unaPersona){
		duermen.add(unaPersona)
	}
	
	method estanTodosEnElDormitorio() = duermen.all({d => ocupantes.contains(d)})
	
	method duermeEnDormitorio(unaPersona) = duermen.contains(unaPersona)
	
	override method puedeEntrar(unaPersona) = self.duermeEnDormitorio(unaPersona) or self.estanTodosEnElDormitorio()
	
	method cantQueDuermen() = duermen.size()
	
	override method nivelDeConfort(unaPersona) = super(unaPersona) + if(self.duermeEnDormitorio(unaPersona)){10/self.cantQueDuermen()}else{0}
	
}

class Cocina inherits Habitacion{
	const metrosCuadrados
	
	method porcentaje() = metrosCuadrados * porcentaje.porcentaje()
	
	override method nivelDeConfort(unaPersona) = super(unaPersona) + if(unaPersona.sabeCocinar()){self.porcentaje()}else{0}
	
	method esCocineroYNoHayCocinero(unaPersona) = unaPersona.sabeCocinar() and not ocupantes.any({p => p.sabeCocinar()})
	
	override method puedeEntrar(unaPersona) = not unaPersona.sabeCocinar() or self.esCocineroYNoHayCocinero(unaPersona)
		
}

object porcentaje{
	var property porcentaje = 0.1
}

class Persona{
	var property habitacion = null
	const property edad
	var property sabeCocinar
	
	method puedeEntrarEnUnaHabitacion(casa){
		return casa.habitaciones().any({h => h.puedeEntrar(self)})
	}
	
	method estaAGutsoEn(casa,familia) = self.puedeEntrarEnUnaHabitacion(casa)
}

class Obsesive inherits Persona{
	
	override method estaAGutsoEn(casa,familia){
		return super(casa,familia) and casa.cantidadEnHabitacion() <= 2
	}
}

class Golose inherits Persona{
	
	override method estaAGutsoEn(casa,familia){
		return super(casa,familia) and familia.alMenosUnoSabeCocinar()
	}
}

class Sencille inherits Persona{
	
	override method estaAGutsoEn(casa,familia){
		return super(casa,familia) and casa.cantidadHabitaciones() > familia.cantidadDeMiembros()
	}
}

class Familia{
	const property integrantes = #{}
	const property casaDondeViven
	
	method quitarIntegrante(unIntegrante){
		integrantes.remove(unIntegrante)
	}
	
	method agregarIntegrante(unIntegrante){
		integrantes.add(unIntegrante)
	}
	
	method alMenosUnoSabeCocinar() = integrantes.any({i => i.sabecocinar()})
	
	method cantidadDeMiembros() = integrantes.size()
	
	method nivelDeConfort() = casaDondeViven.habitaciones().sum({h => h.nivelDeConfortDeCadaOcupante()})
	
	method nivelDeConfortPromedio(){
		return self.nivelDeConfort() /self.cantidadDeMiembros()
	}
	
	method cadaMiembroEstaAGusto() = integrantes.all({i => i.estaAGutsoEn(casaDondeViven,self)})
	
	method estaAGusto(){
		return self.nivelDeConfortPromedio() > 4 and self.cadaMiembroEstaAGusto()
	}
	
}

class Casa{
	const property habitaciones = #{}
	
	
	method cantidadHabitaciones() = habitaciones.size()
	
	method agregarHabitacion(unaHabitacion){
		habitaciones.add(unaHabitacion)
	}
	
	method quitarHabitacion(unaHabitacion){
		habitaciones.remove(unaHabitacion)
	}
	
	method cantHabitacionesConOcupantes() = habitaciones.count({h => not h.ocupantes().isEmty()})
	
	method HabitacionesOcupadas(){
		if (self.cantHabitacionesConOcupantes() == 0){
			self.error("Debe haber al menos una habitacion con ocupante")
		}
		return habitaciones.filter({h => not h.ocupantes().isEmty()})
	}
	
	method responsables() = habitaciones.max({h => h.ocupanteMasViejos().edad()})
}
