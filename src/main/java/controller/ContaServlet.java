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
		
		GenericDao gDao = new GenericDao();
		ContaCorrenteDao cDao = new ContaCorrenteDao(gDao);
		ContaPoupancaDao pDao = new ContaPoupancaDao(gDao); 
		
		ContaCorrente c = new ContaCorrente();
		ContaPoupanca p = new ContaPoupanca();
		
		String erro = "";
		List<ContaCorrente> cs = new ArrayList<>();
		List<ContaPoupanca> ps = new ArrayList<>();
		
		System.out.println("get conta");
		System.out.println(usuario + " get usuario");
		
		try {
			p.setCodigo(codigo);
			c.setCodigo(codigo);
			
			System.out.println("codigo conta get " + codigo);
			// contas = ccoDao.listar();
			if (acao != null) {
				//cco.setCodigo(codigo);
				
				if (acao.equalsIgnoreCase("excluir")) {
					// ccoDao.excluir(cco);
					// ccos = ccoDao.listar();
					c = null;
				} else {
					c = cDao.buscar(c);
					p = pDao.buscar(p);
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
		//ContaCorrenteDao cDao = new ContaCorrenteDao(gDao);
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
			if (!cmd.equalsIgnoreCase("Listar")) {
				cli.setCpf(usuario);
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				//c.setDataAbertura(LocalDate.parse(dataAbertura));
				c.setSaldo(Double.parseDouble(saldo));
				p.setSaldo(Double.parseDouble(saldo));
				//c.setLimiteCredito(Double.parseDouble(limiteCredito));
			}
			
			//GenericDao gDao = new GenericDao();
			//AgenciaDao ccoDao = new ContaCorrenteDao(gDao);
			p.setCodigo(codigo);
			c.setCodigo(codigo);
			
			if (cmd.equalsIgnoreCase("Inserir")) {
				p.setCodigoAgencia(Long.parseLong(codigoAgencia));
				//cDao.inserir(c);
				pDao.inserir(p, cli, cpfConjunto);
				saida = "Conta inserida com sucesso";
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				
				p.setPercentualRendimento(Double.parseDouble(percentualRendimento));
				
				//cDao.atualizar(c);
				//saida = "Conta "+c.getCodigo()+" modifcada com sucesso";
				pDao.atualizar(p);
				saida = "Conta "+p.getCodigo()+" modifcada com sucesso";
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				//cDao.excluir(c);
				//saida = "Conta "+cco.getCodigo()+" excluida com sucesso";
				pDao.excluir(p);
				saida = "Conta "+p.getCodigo()+" excluida com sucesso";
				
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				p.setCodigo(codigo);
				c.setCodigo(codigo);
				//c = cDao.buscar(c);
				p = pDao.buscar(p);
				System.out.println(p + " Conta Poupanca");
			}

			if (cmd.equalsIgnoreCase("Listar")) {
				System.out.println("Listar cliente");
				//cs = cDao.listar(cli);
				ps = pDao.listar(cli);
				System.out.println("DASDAASD");
				System.out.println("Sem catch");
			}

		} catch (Exception e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
			
			System.out.println("catch");
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				c = null;
				p = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				//cs = null;
				//ps = null;
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