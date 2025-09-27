package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cliente;
// import persistence.GenericDao;
// import persistence.ClienteDao;
import model.Conta;
import model.ContaCorrente;
import persistence.ClienteDao;
import persistence.GenericDao;

@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ClienteServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String editar = request.getParameter("editar");
		String usuario = request.getParameter("usuario");
		
		Cliente cli = new Cliente();
		cli.setCpf(usuario);
		GenericDao gDao = new GenericDao();
		ClienteDao cDao = new ClienteDao(gDao);
		
		String erro = "";
		
		System.out.println(usuario + " get usuario");
		
		
		try {
			
			cli = cDao.buscar(cli);
			// GenericDao gDao = new GenericDao();
			// ClienteDao cliDao = new ClienteDao(gDao);
			// clientes = cliDao.listar();
//			if (acao != null) {
//
//				if (acao.equalsIgnoreCase("excluir")) {
//					// cliDao.excluir(a);
//					// clientes = cliDao.listar();
//					cli = null;
//				} else {
//					// cli = aDao.buscar(cli);
//					clientes = null;
//				}
//			}
			
			
		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("cliente", cli);
			request.setAttribute("editar", editar);
			request.setAttribute("usuario", usuario);
			
			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("cliente.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<Cliente> clientes = new ArrayList<Cliente>();
		Cliente cli = new Cliente();
		String cmd = "";
		String usuario = request.getParameter("usuario");
		String formaAuth = request.getParameter("forma_auth");
		
		System.out.println(usuario + " post usuario");
		
		RequestDispatcher dispatcher;
		
		if(usuario != null) {
			
			try {
				
				if(formaAuth == null) {
					String senha = request.getParameter("senha");
					GenericDao gDao = new GenericDao();
					ClienteDao cliDao = new ClienteDao(gDao);
					
					cli.setCpf(usuario);
					cli.setSenha(senha);
					
					
					cmd = request.getParameter("botao");
						
											

					if (cmd.equalsIgnoreCase("Atualizar")) {
						System.out.println("Inicio atualizar");
						cliDao.atualizar(cli);
						System.out.println("Fim atualizar");
						saida = "Cliente "+cli.getCpf()+" modifcado com sucesso";
					}
					
					if (cmd.equalsIgnoreCase("Excluir")) {
						cliDao.excluir(cli);
						saida = "Cliente "+cli.getCpf()+" excluida com sucesso";
					}
						

					
				} else {
					
					
				}
				
	
				dispatcher = request.getRequestDispatcher("cliente.jsp");
				
			} catch (Exception e) {
				saida = "";
				erro = e.getMessage();
				if (erro.contains("input string")) {
					erro = "Preencha os campos corretamente";
				}
				
				
				
			} finally {
				if (!cmd.equalsIgnoreCase("Buscar")) {
					cli = null;
				}
				if (!cmd.equalsIgnoreCase("Listar")) {
					clientes = null;
				}
				request.setAttribute("erro", erro);
				request.setAttribute("saida", saida);
				request.setAttribute("cliente", cli);
				request.setAttribute("usuario", usuario);
				
				dispatcher = request.getRequestDispatcher("cliente.jsp");
				
			}
		} else {
			dispatcher = request.getRequestDispatcher("cliente.jsp");
		}
		
		dispatcher.forward(request, response);
		
	
	}

}