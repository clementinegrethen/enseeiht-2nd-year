<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.Collection, mypackage.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<ul>
	<% Collection<Personne> lp = (Collection<Personne>) request.getAttribute("personnes");
	Collection<Adresse> la = (Collection<Adresse>) request.getAttribute("adresses"); %>
	

	<form>
	  <p>Choisir personne : </p>
	  <% for (Personne p : lp) { %> 
		  <div>
		    <input type="radio" name="idp" value="<%=p.getId()%>"><%=p.getPrenom()%> <%=p.getNom()%>
		  </div>
	  <% } %>
	  <p>Choisir adresse : </p>
	  <% for (Adresse a : la) { %> 
		  <div>
		    <input type="radio" name="ida" value="<%=a.getId()%>"> <%=a.getRue()%> <%=a.getVille()%>
		  </div>
	  <% } %>
	  <input type="submit" value="OK">
	<input type="hidden" name="op" value="assoc">
	</form>

${exception}
</body>
</html>