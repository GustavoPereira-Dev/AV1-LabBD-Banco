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

@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ClienteServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String cpf = request.getParameter("cpf");
		
		Cliente cli = new Cliente();
		String erro = "";
		List<Cliente> clientes = new ArrayList<>();
		
		try {
			
			// GenericDao gDao = new GenericDao();
			// ClienteDao cliDao = new ClienteDao(gDao);
			// clientes = cliDao.listar();
			if (acao != null) {
				cli.setCpf(cpf);
				
/*	private String cpf;
	private String nome;
	private LocalDate dataPrimeiraConta;
	private String senha;*/
				
				if (acao.equalsIgnoreCase("excluir")) {
					// cliDao.excluir(a);
					// clientes = cliDao.listar();
					cli = null;
				} else {
					// cli = aDao.buscar(cli);
					clientes = null;
				}
			}
			
			
		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("cliente", cli);
			request.setAttribute("clientes", clientes);

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
		
		
		try {
			String cpf = request.getParameter("cpf");
			String nome = request.getParameter("nome");
			String primeiraConta = request.getParameter("primeira_conta");
			String senha = request.getParameter("senha");
			cmd = request.getParameter("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				cli.setCpf(cpf);
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				cli.setNome(nome);
				cli.setDataPrimeiraConta(LocalDate.parse(primeiraConta));
				cli.setSenha(senha);
			}
			
			//GenericDao gDao = new GenericDao();
			//AgenciaDao cliDao = new ClienteDao(gDao);
			
			if (cmd.equalsIgnoreCase("Inserir")) {
				//cliDao.inserir(cli);
				//saida = "Cliente "+cli.getNome()+" inserido com sucesso";
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				//cliDao.atualizar(cli);
				//saida = "Cliente "+cli.getNome()+" modifcado com sucesso";
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				//cliDao.excluir(cli);
				//saida = "Cliente "+cli.getCpf()+" excluida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				//cli = cliDao.buscar(cli);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				//clientes = cliDao.listar();
			}

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
			request.setAttribute("clientes", clientes);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("cliente.jsp");
			dispatcher.forward(request, response);
		}
		
	}

}