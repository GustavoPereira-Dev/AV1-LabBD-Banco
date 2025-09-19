package model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public abstract class Conta {
	
	private int codigo;
	private LocalDate dataAbertura;
	private double saldo;

}
