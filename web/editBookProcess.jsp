<%-- 
    Document   : editBookProcess
    Created on : Feb 26, 2026, 6:51:18 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String genre = request.getParameter("genre");
    int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));
    int availableCopies = Integer.parseInt(request.getParameter("availableCopies"));

    PreparedStatement ps = conn.prepareStatement(
        "UPDATE books SET title=?, author=?, genre=?, total_copies=?, available_copies=? WHERE id=?");
    ps.setString(1, title);
    ps.setString(2, author);
    ps.setString(3, genre);
    ps.setInt(4, totalCopies);
    ps.setInt(5, availableCopies);
    ps.setInt(6, id);
    ps.executeUpdate();

    response.sendRedirect("adminDashboard.jsp");
%>