package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Agencia;
import persistence.AgenciaDao;
import persistence.GenericDao;
// import persistence.GenericDao;
// import persistence.AgenciaDao;

@WebServlet("/agencia")
public class AgenciaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AgenciaServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String codigo = request.getParameter("codigo");
		List<Agencia> agencias = new ArrayList<>();
		System.out.println(acao + " get");
		Agencia a = new Agencia();
		String erro = "";
		
		try {
			
			GenericDao gDao = new GenericDao();
			AgenciaDao aDao = new AgenciaDao(gDao);
			agencias = aDao.listar();
			
			if (acao != null) {
				a.setCodigo(Integer.parseInt(codigo));
				

				
				if (acao.equalsIgnoreCase("excluir")) {
					aDao.excluir(a);
					agencias = aDao.listar();
					a = null;
				} else {
					a = aDao.buscar(a);
					agencias = null;
				}
			}
			
		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("agencia", a);
			request.setAttribute("agencias", agencias);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("agencia.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<Agencia> agencias = new ArrayList<Agencia>();
		Agencia a = new Agencia();
		String cmd = "";
		
		String acao = request.getParameter("acao");
		
		System.out.println(acao);
		try {
			String codigo = request.getParameter("codigo");
			String nome = request.getParameter("nome");
			String cep = request.getParameter("cep");
			String cidade = request.getParameter("cidade");
			cmd = request.getParameter("botao");
			
			System.out.println("cmd");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				a.setCodigo(Integer.parseInt(codigo));
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				a.setCodigo(Long.parseLong(codigo));
				a.setNome(nome);
				a.setCep(cep);
				a.setCidade(cidade);
			}
			
			GenericDao gDao = new GenericDao();
			AgenciaDao aDao = new AgenciaDao(gDao);
			
			if (cmd.equalsIgnoreCase("Inserir")) {
				aDao.inserir(a);
				saida = "Agencia "+a.getNome()+" inserida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				aDao.atualizar(a);
				saida = "Agencia "+a.getNome()+" modifcada com sucesso";
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				aDao.excluir(a);
				saida = "Agencia "+a.getCodigo()+" excluida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				a = aDao.buscar(a);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				agencias = aDao.listar();
			}

		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				a = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				agencias = null;
			}
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("agencia", a);
			request.setAttribute("agencias", agencias);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("agencia.jsp");
			dispatcher.forward(request, response);
		}
		
	}

}