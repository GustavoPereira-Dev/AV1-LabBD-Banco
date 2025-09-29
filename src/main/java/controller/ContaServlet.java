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
import model.ContaCorrente;
import model.ContaPoupanca;
import persistence.GenericDao;
import persistence.ContaPoupancaDao;
import persistence.ContaCorrenteDao;

@WebServlet("/conta")
public class ContaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ContaServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String usuario = request.getParameter("usuario");
		String codigo = request.getParameter("codigo");
		String tipo = request.getParameter("tipo");
		
		GenericDao gDao = new GenericDao();
		ContaCorrenteDao cDao = new ContaCorrenteDao(gDao);
		ContaPoupancaDao pDao = new ContaPoupancaDao(gDao); 
		
		ContaCorrente c = new ContaCorrente();
		ContaPoupanca p = new ContaPoupanca();
		
		String erro = "";
		List<ContaCorrente> cs = new ArrayList<>();
		List<ContaPoupanca> ps = new ArrayList<>();
		
		
		try {
			

			
			System.out.println("codigo conta get " + codigo);
			if (acao != null && tipo != null) {
				
				System.out.println(c.getCodigo() + " Codigo; " + " CPF " + usuario );
				
				if(tipo.equalsIgnoreCase("Poupanca")) p.setCodigo(codigo);
				if(tipo.equalsIgnoreCase("Corrente")) c.setCodigo(codigo);
				
				if (acao.equalsIgnoreCase("Excluir")) {
					
					if(tipo.equalsIgnoreCase("Poupanca")) pDao.excluir(p);
					if(tipo.equalsIgnoreCase("Corrente")) cDao.excluir(c);
					p = null;
					c = null;
				} else {
					
					System.out.println(c.getCodigo() + " Codigo; " + " CPF " + usuario );
					if(tipo.equalsIgnoreCase("Poupanca")) p = pDao.buscar(p);
					if(tipo.equalsIgnoreCase("Corrente")) c = cDao.buscar(c);
					cs = null;
					ps = null;
				}
			}
			
			
		} catch (Exception e) {
			erro = e.getMessage();
			System.out.println("catch conta get");
		} finally {
//			cco = new ContaCorrente();
//			cco.setCodigo(1323133221);
//			cco.setCodigoAgencia(1);
//			cco.setDataAbertura(LocalDate.now());
//			cco.setLimiteCredito(21.21);
//			cco.setSaldo(21.21);
//			ccos.add(cco);
			request.setAttribute("erro", erro);
			request.setAttribute("conta_corrente", c);
			request.setAttribute("contas_correntes", cs);
			request.setAttribute("conta_poupanca", p);
			request.setAttribute("contas_poupancas", ps);
			request.setAttribute("usuario", usuario);

			//System.out.println(ccos);
			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("conta.jsp");
			dispatcher.forward(request, response);

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		String erro = "";
		List<ContaPoupanca> ps = new ArrayList<ContaPoupanca>();
		ContaPoupanca p = new ContaPoupanca();
		
		List<ContaCorrente> cs = new ArrayList<ContaCorrente>();
		ContaCorrente c = new ContaCorrente();
		Cliente cli = new Cliente();
		
		String cmd = "";
		
		GenericDao gDao = new GenericDao();
		ContaCorrenteDao cDao = new ContaCorrenteDao(gDao);
		ContaPoupancaDao pDao = new ContaPoupancaDao(gDao); 
		
		String usuario = request.getParameter("usuario");
		
		System.out.println(usuario + " cpf parameter");
		
		try {

			String dataAbertura = request.getParameter("data_abertura");
			String saldo = request.getParameter("saldo");
			
			String limiteCredito = request.getParameter("limite_credito");
			String codigoAgencia = request.getParameter("codigo_agencia");
			String cpfConjunto = request.getParameter("cpf_conjunto");
			String percentualRendimento = request.getParameter("percentual_rendimento");
			
			String codigo = request.getParameter("codigo");
			
			cli.setCpf(usuario);
			cmd = request.getParameter("botao");
			
			System.out.println(usuario + " codigo cpf");
			if (!cmd.contains("Listar")) {
				cli.setCpf(usuario);
			}
			if (cmd.contains("Inserir") || cmd.contains("Atualizar")) {

				if(cmd.contains("Poupanca")) p.setSaldo(Double.parseDouble(saldo));		
				if(cmd.contains("Corrente")) p.setSaldo(Double.parseDouble(saldo));		
				
			}
			
			if(cmd.contains("Poupanca")) p.setCodigo(codigo);
			if(cmd.contains("Corrente")) c.setCodigo(codigo);
			
			if (cmd.contains("Inserir")) {
				
				if(cmd.contains("Poupanca")) {
					p.setCodigoAgencia(Long.parseLong(codigoAgencia));
					pDao.inserir(p, cli, cpfConjunto);
				} else {
					c.setCodigoAgencia(Long.parseLong(codigoAgencia));
					cDao.inserir(c, cli, cpfConjunto);
				}
				
				saida = "Conta inserida com sucesso";
			}
			if (cmd.contains("Atualizar")) {
				
				if(cmd.contains("Poupanca")) {
					p.setPercentualRendimento(Double.parseDouble(percentualRendimento));
					pDao.atualizar(p);
					saida = "Conta "+p.getCodigo()+" modifcada com sucesso";
				} else {
					c.setLimiteCredito(Double.parseDouble(limiteCredito));
					cDao.atualizar(c);
					saida = "Conta "+c.getCodigo()+" modifcada com sucesso";
				}
				
				saida = "Conta "+p.getCodigo()+" modifcada com sucesso";
			}
			if (cmd.contains("Excluir")) {
				
				if(cmd.contains("Poupanca")) {
					pDao.excluir(p);
					saida = "Conta "+p.getCodigo()+" excluida com sucesso";
				} else {
					cDao.excluir(c);
					saida = "Conta "+c.getCodigo()+" excluida com sucesso";
				}
				
			}
			if (cmd.contains("Buscar")) {
				
				if(cmd.contains("Poupanca")) {
					p.setCodigo(codigo);
					p = pDao.buscar(p);
				} else {
					p.setCodigo(codigo);
					p = pDao.buscar(p);
				}
			}

			if (cmd.contains("Listar")) {
				
				if(cmd.contains("Poupanca")) {
					ps = pDao.listar(cli);
				} else {
					cs = cDao.listar(cli);
				}

			}

		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
			
			System.out.println("catch");
		} finally {
			if (!cmd.contains("Buscar")) {
				c = null;
				p = null;
			}
			if (!cmd.contains("Listar")) {
				cs = null;
				ps = null;
			}
			
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("conta_corrente", c);
			request.setAttribute("contas_correntes", cs);
			request.setAttribute("conta_poupanca", p);
			request.setAttribute("contas_poupancas", ps);
			request.setAttribute("usuario", usuario);

			RequestDispatcher dispatcher = 
					request.getRequestDispatcher("conta.jsp");
			dispatcher.forward(request, response);
		}
		
	}

}