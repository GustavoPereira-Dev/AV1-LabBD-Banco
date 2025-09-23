package model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public abstract class Conta {
	
	private long codigo;
	private long codigoAgencia;
	private LocalDate dataAbertura;
	private double saldo;

}
