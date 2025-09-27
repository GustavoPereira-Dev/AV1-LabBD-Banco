package controller;

import java.io.IOException;
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
import model.Conta;
import model.ContaCorrente;
import persistence.ClienteDao;
import persistence.GenericDao;

@WebServlet("/autenticacao")
public class AutenticacaoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AutenticacaoServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String cpf = request.getParameter("cpf");
		String auth = request.getParameter("auth");
		String teste = request.getParameter("horario-modal");
		
		System.out.println(teste + "123");
		
		Cliente cli = new Cliente();
		String erro = "";
		List<Cliente> clientes = new ArrayList<>();
		
		try {
			
			GenericDao gDao = new GenericDao();
			ClienteDao cliDao = new ClienteDao(gDao);
			
			if (acao != null) {
				cli.setCpf(cpf);
				
				
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
			request.setAttribute("auth", auth);
			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("autenticacao.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<Cliente> clientes = new ArrayList<Cliente>();
		Cliente cli = new Cliente();
		String cmd = "";
		String formaAuth = request.getParameter("forma_auth");
		RequestDispatcher dispatcher;
		
		System.out.println("Auth: " + formaAuth);
		try {
			
			String cpf = request.getParameter("cpf");
			String senha = request.getParameter("senha");
			GenericDao gDao = new GenericDao();
			ClienteDao cliDao = new ClienteDao(gDao);
			
			cli.setCpf(cpf);;
			cli.setSenha(senha);
			
			if(formaAuth != null) {
				
				if(formaAuth.equals("cadastro")) {
					Conta conta = new ContaCorrente();
					
					String nome = request.getParameter("nome");
					String tipoConta = request.getParameter("tipo_conta");
					String codAgencia = request.getParameter("cod_agencia");
					
					conta.setCodigoAgencia(Long.parseLong(codAgencia));
					
					cli.setNome(nome);
					cli.setCpf(cpf);
					
					
					System.out.println("Inicio Inserir");
					
					cliDao.inserir(cli, conta, tipoConta);
					
					System.out.println("Fim inserir");
				} else {
					cliDao.validarLogin(cli);
				}
				
				System.out.println("AAAAAAAAAAAAAA");
				request.setAttribute("usuario", cli.getCpf());
				

			} else {
				
				String nome = request.getParameter("nome");
				String primeiraConta = request.getParameter("primeira_conta");
			
				cmd = request.getParameter("botao");
				
				if (!cmd.equalsIgnoreCase("Listar")) {
					cli.setCpf(cpf);
				}
				if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
					cli.setNome(nome);
					cli.setDataPrimeiraConta(LocalDate.parse(primeiraConta));
					cli.setSenha(senha);
				}
				

				
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
			}
			

			dispatcher = request.getRequestDispatcher("cliente.jsp");
			request.setAttribute("usuario", cli.getCpf());
			
		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
			
			System.out.println("catch");
			dispatcher = request.getRequestDispatcher("autenticacao.jsp");
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
			request.setAttribute("auth", formaAuth);
			

			
		}
		
		dispatcher.forward(request, response);
		
		
	}

}