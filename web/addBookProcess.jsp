<%-- 
    Document   : addBookProcess
    Created on : Feb 24, 2026, 11:49:16 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String genre = request.getParameter("genre");
    int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));

    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO books (title, author, genre, total_copies, available_copies) VALUES (?, ?, ?, ?, ?)");
    ps.setString(1, title);
    ps.setString(2, author);
    ps.setString(3, genre);
    ps.setInt(4, totalCopies);
    ps.setInt(5, totalCopies);
    ps.executeUpdate();

    response.sendRedirect("home.jsp");
%>
