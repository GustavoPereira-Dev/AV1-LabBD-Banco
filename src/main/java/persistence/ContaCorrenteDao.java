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
import model.ContaCorrente;
import model.ContaPoupanca;

public class ContaCorrenteDao {

	private GenericDao gDao;

	public ContaCorrenteDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	public ContaCorrente buscar(ContaCorrente conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, cc.limiteCredito FROM ContaCorrente cc INNER JOIN Conta c ON cc.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE clienteCpf = ?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,conta.getCodigo());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			conta.setCodigo(rs.getString("contaCodigo"));
			conta.setDataAbertura(LocalDate.parse(rs.getString("dataAbertura")));
			conta.setSaldo(rs.getDouble("saldo"));
			conta.setCodigoAgencia(rs.getLong("agenciaCodigo"));
			conta.setLimiteCredito(rs.getDouble("limiteCredito"));
		}
		rs.close();
		ps.close();
		return conta;
	}

	public List<ContaCorrente> listar(Cliente cliente) throws SQLException, ClassNotFoundException {
		List<ContaCorrente> contas = new ArrayList<ContaCorrente>();
		Connection c = gDao.getConnection();
		String sql = "SELECT c.codigo, c.dataAbertura, c.saldo, c.agenciaCodigo, cc.limiteCredito FROM ContaCorrente cc INNER JOIN Conta c ON cc.contaCodigo = c.codigo WHERE c.codigo IN (SELECT contaCodigo FROM ContaCliente WHERE clienteCpf = ?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,cliente.getCpf());
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			ContaCorrente conta = new ContaCorrente();
			conta.setCodigo(rs.getString("codigo"));
			conta.setDataAbertura(LocalDate.parse(rs.getString("dataAbertura")));
			conta.setCodigoAgencia(rs.getLong("agenciaCodigo"));
			conta.setSaldo(Double.parseDouble(rs.getString("saldo")));
			conta.setLimiteCredito(rs.getDouble("limiteCredito"));
			contas.add(conta);
		}
		rs.close();
		ps.close();
		return contas;
	}
	
	public List<ContaCorrente> listar() throws SQLException, ClassNotFoundException {
		List<ContaCorrente> contas = new ArrayList<ContaCorrente>();
		Connection c = gDao.getConnection();
		String sql = "SELECT contaCodigo, dataAbertura, saldo, agenciaCodigo, limiteCredito FROM ContaCorrente";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			ContaCorrente conta = new ContaCorrente();
			conta.setCodigo(rs.getString("contaCodigo"));
			conta.setDataAbertura(LocalDate.parse(rs.getString("dataAbertura")));
			conta.setSaldo(Double.parseDouble(rs.getString("saldo")));
			conta.setCodigoAgencia(rs.getLong("agenciaCodigo"));
			conta.setLimiteCredito(rs.getDouble("limiteCredito"));
			contas.add(conta);
		}
		rs.close();
		ps.close();
		return contas;
	}

	public String inserir(ContaCorrente conta, Cliente cliente, String cpfConjunto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_inserir_conta(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.setString(2, "Conta Corrente");
		cs.setLong(3, conta.getCodigoAgencia());
		cs.setString(4, cpfConjunto);
		cs.setString(5, LocalDate.now().toString());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}
	
	public String atualizar(ContaCorrente conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_atualizar_conta(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "Conta Corrente");
		cs.setString(2, conta.getCodigo());
		cs.setDouble(3, conta.getSaldo());
		cs.setDouble(4, conta.getLimiteCredito());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(5);
		cs.close();
		
		return saida;

	}
	
	public String excluir(ContaCorrente conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_excluir_conta(?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, conta.getCodigo());
		cs.setString(2, "Conta Corrente");
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(3);
		cs.close();
		
		return saida;
	}
	
	

}
