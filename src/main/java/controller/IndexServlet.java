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
import model.Conta;
import model.ContaPoupanca;
// import persistence.GenericDao;
// import persistence.ContaPoupancaDao;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public IndexServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String codigo = request.getParameter("codigo");
		
		String auth = request.getParameter("auth");
		
		System.out.println(auth + " Index ");
		
		ContaPoupanca cpo = new ContaPoupanca();
		String erro = "";
		List<ContaPoupanca> cpos = new ArrayList<>();
		
		try {
			
			// GenericDao gDao = new GenericDao();
			// ContaPoupancaDao cpoDao = new ContaPoupancaDao(gDao);
			// cpos = cpoDao.listar();
			if (acao != null) {
				cpo.setCodigo(Integer.parseInt(codigo));
				
/*	private String cpf;
	private String nome;
	private LocalDate dataPrimeiraConta;
	private String senha;*/
				
				if (acao.equalsIgnoreCase("excluir")) {
					// cpoDao.excluir(cpo);
					// cpos = cpoDao.listar();
					cpo = null;
				} else {
					// cpo = cpoDao.buscar(cpo);
					cpos = null;
				}
			}
			
			
		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("conta_poupanca", cpo);
			request.setAttribute("contas_poupancas", cpos);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("contapoupanca.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<ContaPoupanca> cpos = new ArrayList<ContaPoupanca>();
		ContaPoupanca cpo = new ContaPoupanca();
		String cmd = "";
		
		String auth = request.getParameter("auth");
		
		System.out.println(auth + " Index ");
		
		try {
			String codigo = request.getParameter("codigo");
			String dataAbertura = request.getParameter("data_abertura");
			String saldo = request.getParameter("saldo");
			String percentualRendimento = request.getParameter("percentual_rendimento");
			String diaAniversario = request.getParameter("dia_aniversario");
			cmd = request.getParameter("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				cpo.setCodigo(Integer.parseInt(codigo));
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				cpo.setDataAbertura(LocalDate.parse(dataAbertura));
				cpo.setSaldo(Double.parseDouble(saldo));
				cpo.setPercentualRendimento(Double.parseDouble(percentualRendimento));
				cpo.setDiaAniversario(LocalDate.parse(diaAniversario));
			}
			
			//GenericDao gDao = new GenericDao();
			//ContaPoupancaDao cpoDao = new ContaPoupancaDao(gDao);
			
			if (cmd.equalsIgnoreCase("Inserir")) {
				//cpoDao.inserir(cpo);
				//saida = "Conta "+cpo.getCodigo()+" inserida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				//cpoDao.atualizar(cpo);
				//saida = "Conta "+cpo.getCodigo()+" modifcada com sucesso";
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				//cpoDao.excluir(cpo);
				//saida = "Conta "+cpo.getCodigo()+" excluida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				//cpo = cpoDao.buscar(cpo);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				//cpos = cpoDao.listar();
			}

		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				cpo = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				cpos = null;
			}
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("conta_poupanca", cpo);
			request.setAttribute("contas_poupancas", cpos);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("contapoupanca.jsp");
			dispatcher.forward(request, response);
		}
		
	}

}