<%-- 
    Document   : addMemberProcess
    Created on : Feb 24, 2026, 11:49:42 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO members (name, email, phone) VALUES (?, ?, ?)");
    ps.setString(1, name);
    ps.setString(2, email);
    ps.setString(3, phone);
    ps.executeUpdate();

    response.sendRedirect("home.jsp");
%>
