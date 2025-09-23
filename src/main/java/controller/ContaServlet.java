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
import model.ContaCorrente;

@WebServlet("/conta")
public class ContaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ContaServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String codigo = request.getParameter("codigo");
		
		System.out.println("Teste");
		
		ContaCorrente cco = new ContaCorrente();
		String erro = "";
		List<ContaCorrente> ccos = new ArrayList<>();
		
		try {
			
			// GenericDao gDao = new GenericDao();
			// ContaCorrenteDao ccoDao = new ContaCorrenteDao(gDao);
			// contas = ccoDao.listar();
			if (acao != null) {
				cco.setCodigo(Integer.parseInt(codigo));
				
/*	private String cpf;
	private String nome;
	private LocalDate dataPrimeiraConta;
	private String senha;*/
				
				if (acao.equalsIgnoreCase("excluir")) {
					// ccoDao.excluir(cco);
					// ccos = ccoDao.listar();
					cco = null;
				} else {
					// cco = ccoDao.buscar(cco);
					ccos = null;
				}
			}
			
			
		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			cco = new ContaCorrente();
			cco.setCodigo(1323133221);
			cco.setCodigoAgencia(1);
			cco.setDataAbertura(LocalDate.now());
			cco.setLimiteCredito(21.21);
			cco.setSaldo(21.21);
			ccos.add(cco);
			request.setAttribute("erro", erro);
			request.setAttribute("conta_corrente", cco);
			request.setAttribute("contas_correntes", ccos);
			request.setAttribute("teste", "1234");

			System.out.println(ccos);
			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("conta.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<ContaCorrente> ccos = new ArrayList<ContaCorrente>();
		ContaCorrente cco = new ContaCorrente();
		String cmd = "";
		
		
		try {
			String codigo = request.getParameter("codigo");
			String dataAbertura = request.getParameter("data_abertura");
			String saldo = request.getParameter("saldo");
			String limiteCredito = request.getParameter("limite_credito");
			cmd = request.getParameter("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				cco.setCodigo(Integer.parseInt(codigo));
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				cco.setDataAbertura(LocalDate.parse(dataAbertura));
				cco.setSaldo(Double.parseDouble(saldo));
				cco.setLimiteCredito(Double.parseDouble(limiteCredito));
			}
			
			//GenericDao gDao = new GenericDao();
			//AgenciaDao ccoDao = new ContaCorrenteDao(gDao);
			
			if (cmd.equalsIgnoreCase("Inserir")) {
				//ccoDao.inserir(cco);
				//saida = "Conta "+cco.getCodigo()+" inserida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				//ccoDao.atualizar(cco);
				//saida = "Conta "+cco.getCodigo()+" modifcada com sucesso";
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				//ccoDao.excluir(cco);
				//saida = "Conta "+cco.getCodigo()+" excluida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				//cco = ccoDao.buscar(cco);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				//ccos = ccoDao.listar();
			}

		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				cco = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				ccos = null;
			}
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("conta_corrente", cco);
			request.setAttribute("contas_correntes", ccos);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("conta.jsp");
			dispatcher.forward(request, response);
		}
		
	}

}