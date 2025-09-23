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
import model.ContaPoupanca;

public class ContaPoupancaDao implements ICrud<ContaPoupanca> {

	private GenericDao gDao;

	public ContaPoupancaDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	@Override
	public ContaPoupanca buscar(ContaPoupanca conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT contaCodigo, dataAbertura, saldo, agenciaCodigo, percentualRendimento, diaAniversario FROM ContaPoupanca WHERE contaCodigo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setLong(1,conta.getCodigo());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			conta.setCodigo(rs.getLong("contaCodigo"));
			conta.setDataAbertura(LocalDate.parse(rs.getString("dataAbertura")));
			conta.setSaldo(Double.parseDouble(rs.getString("saldo")));
			conta.setCodigoAgencia(rs.getLong("agenciaCodigo"));
			conta.setPercentualRendimento(rs.getDouble("percentualRendimento"));
			conta.setDiaAniversario(LocalDate.parse(rs.getString("diaAniversario")));
		}
		rs.close();
		ps.close();
		return conta;
	}

	
//	@tipoConta VARCHAR(14), @codConta BIGINT, @saldo DECIMAL(7,2), 
//    @atributoEspecifico DECIMAL(7,2), @saida VARCHAR(100) OUTPUT
    
	@Override
	public List<ContaPoupanca> listar() throws SQLException, ClassNotFoundException {
		List<ContaPoupanca> contas = new ArrayList<ContaPoupanca>();
		Connection c = gDao.getConnection();
		String sql = "SELECT contaCodigo, dataAbertura, saldo, agenciaCodigo, percentualRendimento, diaAniversario FROM ContaPoupanca";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			ContaPoupanca conta = new ContaPoupanca();
			conta.setCodigo(rs.getLong("contaCodigo"));
			conta.setDataAbertura(LocalDate.parse(rs.getString("dataAbertura")));
			conta.setSaldo(Double.parseDouble(rs.getString("saldo")));
			conta.setCodigoAgencia(rs.getLong("agenciaCodigo"));
			conta.setPercentualRendimento(rs.getDouble("percentualRendimento"));
			conta.setDiaAniversario(LocalDate.parse(rs.getString("diaAniversario")));
			contas.add(conta);
		}
		rs.close();
		ps.close();
		return contas;
	}

	@Override
	public String inserir(ContaPoupanca conta) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	
	public String inserir(ContaPoupanca conta, Cliente cliente, String cpfConjunto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_inserir_conta(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cliente.getCpf());
		cs.setString(2, cliente.getNome());
		cs.setString(3, cliente.getSenha());
		cs.setString(4, cpfConjunto);
		cs.setString(5, "Conta Poupanca");
		cs.setLong(6, conta.getCodigoAgencia());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;
	}

	public String atualizar(ContaPoupanca conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_atualizar_conta(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "Conta Poupanca");
		cs.setLong(2, conta.getCodigo());
		cs.setDouble(3, conta.getSaldo());
		cs.setDouble(4, conta.getPercentualRendimento());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(5);
		cs.close();
		
		return saida;

	}

	
	public String excluir(ContaPoupanca conta) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_excluir_conta(?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setLong(1, conta.getCodigo());
		cs.setString(2, "Conta Poupanca");
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(3);
		cs.close();
		
		return saida;
	}
}
