package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Cliente;
import model.Conta;

public class ClienteDao {

	private GenericDao gDao;

	public ClienteDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	public Cliente buscar(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, dataPrimeiraConta, senha FROM cliente WHERE cpf = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,cliente.getCpf());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			cliente.setCpf(rs.getString("CPF"));
			cliente.setNome(rs.getString("Nome"));
			cliente.setDataPrimeiraConta(LocalDate.parse(rs.getString("dataPrimeiraConta")));
			cliente.setSenha(rs.getString("senha"));
		}
		rs.close();
		ps.close();
		return cliente;
	}
	
	
//	private String cpf;
//	private String nome;
//	private LocalDate dataPrimeiraConta;
//	private String senha;
//	cpf						VARCHAR(11)		NOT NULL,
//	nome					VARCHAR(100)	NOT NULL,
//	dataPrimeiraConta		DATE			        ,
//	senha					VARCHAR(8)		NOT NULL

	public List<Cliente> listar() throws SQLException, ClassNotFoundException {
		List<Cliente> clientes = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, dataPrimeiraConta, senha FROM cliente";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Cliente cliente = new Cliente();
			cliente.setCpf(rs.getString("CPF"));
			cliente.setNome(rs.getString("Nome"));
			cliente.setDataPrimeiraConta(LocalDate.parse(rs.getString("dataPrimeiraConta")));
			cliente.setSenha(rs.getString("senha"));
			
			clientes.add(cliente);
		}
		rs.close();
		ps.close();
		return clientes;
	}

	public String inserir(Cliente cliente, Conta conta, String tipoConta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_inserir_cliente(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.setString(2, cliente.getNome());
		cs.setString(3, cliente.getSenha());
		cs.setString(4, tipoConta);
		cs.setLong(5, conta.getCodigoAgencia());
		System.out.println(conta.getCodigoAgencia());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}
	
	public String atualizar(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_atualizar_cliente(?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.setString(2, cliente.getSenha());
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(3);
		cs.close();
		
		return saida;
	}
	
	public String excluir(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_excluir_cliente(?,?)}";
		System.out.println("DAO Excluir Cliente: " + cliente.getCpf());
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.registerOutParameter(2, Types.VARCHAR);
		cs.execute();
		
		System.out.println("Fim DAO");
		String saida = cs.getString(2);
		cs.close();
		
		return saida;
	}
	
	public String validarLogin(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_login_usuario(?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.setString(2, cliente.getSenha());
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(3);
		cs.close();
		
		return saida;
	}

}
