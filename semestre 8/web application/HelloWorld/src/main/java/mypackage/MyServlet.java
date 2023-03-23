package mypackage;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MyServlet
 */
@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private Facade f;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyServlet() {
        super();
        this.f = new Facade();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String op = request.getParameter("op");
		switch (op) {
			case "ajouterpersonne":
				f.ajoutPersonne(request.getParameter("nom"), request.getParameter("prenom"));
				request.getRequestDispatcher("index.html").forward(request, response);
				return;
			case "ajouteradresse":
				f.ajoutAdresse(request.getParameter("rue"), request.getParameter("ville"));
				request.getRequestDispatcher("index.html").forward(request, response);
				return;
			case "associer":
				Collection<Personne> personnes = f.listePersonnes();
				request.setAttribute("personnes", personnes);
				Collection<Adresse> adresses = f.listeAdresses();
				request.setAttribute("adresses", adresses);
				request.getRequestDispatcher("associer.jsp").forward(request, response);
				return;
			case "assoc":
				int idp = Integer.valueOf(request.getParameter("idp"));
				int ida = Integer.valueOf(request.getParameter("ida"));
				f.associer(idp, ida);
				request.getRequestDispatcher("index.html").forward(request, response);
				return;
			case "lister":
				Collection<Personne> lp = f.listePersonnes();

				RequestDispatcher disp = request.getRequestDispatcher("liste.jsp"); 
				request.setAttribute("personnes", lp);
				disp.forward(request, response);
				
				return;
			default :
				return;
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
