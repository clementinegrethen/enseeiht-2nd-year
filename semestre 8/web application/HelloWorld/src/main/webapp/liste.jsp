<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.Collection, mypackage.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Liste</title>
</head>
<body>
	<ul>
	<% Collection<Personne> l = (Collection<Personne>) request.getAttribute("personnes");
	for (Personne p : l) { %> 
		<li>
			<p><%=p.getPrenom()%> <%=p.getNom()%></p>
			<ul>
				<% for (Adresse a : p.getAdresses()) { %> 
					<li><%=a.getRue()%> <%=a.getVille()%></li>
				<% } %> 
			</ul>
		</li>
	<% } %>
	</ul>
	
${exception}
		
</body>
</html>