package model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Agencia {
	
	private int codigo;
	private String nome;
	private String cep;
	private String cidade;
	
}
