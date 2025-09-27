package model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContaPoupanca extends Conta {
	
	private double percentualRendimento;
	private int diaAniversario;
	
}
