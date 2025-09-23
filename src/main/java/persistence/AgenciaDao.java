package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Agencia;

public class AgenciaDao implements ICrud<Agencia> {

	private GenericDao gDao;

	public AgenciaDao(GenericDao gDao) {
		this.gDao = gDao;
	}
	
	@Override
	public Agencia buscar(Agencia agencia) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, cep, cidade FROM Agencia WHERE codigo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setLong(1,agencia.getCodigo());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			agencia.setCodigo(rs.getLong("codigo"));
			agencia.setNome(rs.getString("nome"));
			agencia.setCep(rs.getString("cep"));
			agencia.setCidade(rs.getString("cidade"));
		}
		rs.close();
		ps.close();
		return agencia;
	}
	
	@Override
	public List<Agencia> listar() throws SQLException, ClassNotFoundException {
		List<Agencia> agencias = new ArrayList<Agencia>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, cep, cidade FROM Agencia";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			Agencia agencia = new Agencia();
			agencia.setCodigo(rs.getLong("codigo"));
			agencia.setNome(rs.getString("nome"));
			agencia.setCep(rs.getString("cep"));
			agencia.setCidade(rs.getString("cidade"));
			agencias.add(agencia);
		}
		rs.close();
		ps.close();
		return agencias;
	}

	@Override
	public String inserir(Agencia agencia) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_inserir_agencia(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setLong(1, agencia.getCodigo());
		cs.setString(2, agencia.getNome());
		cs.setString(3, agencia.getCep());
		cs.setString(4, agencia.getCidade());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(5);
		cs.close();
		
		return saida;
	}

	@Override
	public String atualizar(Agencia agencia) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_atualizar_agencia(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setLong(1, agencia.getCodigo());
		cs.setString(2, agencia.getNome());
		cs.setString(3, agencia.getCep());
		cs.setString(4, agencia.getCidade());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(5);
		cs.close();
		
		return saida;
	}

	@Override	
	public String excluir(Agencia agencia) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_excluir_agencia(?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setLong(1, agencia.getCodigo());
		cs.registerOutParameter(2, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(2);
		cs.close();
		
		return saida;
	}
	

}
