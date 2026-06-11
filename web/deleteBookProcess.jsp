<%-- 
    Document   : deleteBookProcess
    Created on : Feb 26, 2026, 6:51:42 PM
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

    PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE id = ?");
    ps.setInt(1, id);
    ps.executeUpdate();

    response.sendRedirect("adminDashboard.jsp");
%>
