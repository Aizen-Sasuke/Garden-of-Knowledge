<%-- 
    Document   : logout
    Created on : Feb 26, 2026, 6:59:41 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>