<%-- 
    Document   : deleteBookProcess
    Created on : Feb 26, 2026, 6:51:42 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%@page import="java.io.File"%>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));

    PreparedStatement fileLookup = conn.prepareStatement("SELECT digital_file_path FROM books WHERE id = ?");
    fileLookup.setInt(1, id);
    ResultSet fileResult = fileLookup.executeQuery();
    if (fileResult.next() && fileResult.getString("digital_file_path") != null) {
        String uploadDir = System.getProperty("user.home") + "/ProjectIcchi-data/book-files";
        File attachedFile = new File(uploadDir, fileResult.getString("digital_file_path"));
        if (attachedFile.exists()) {
            attachedFile.delete();
        }
    }

    PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE id = ?");
    ps.setInt(1, id);
    ps.executeUpdate();

    response.sendRedirect("adminDashboard.jsp");
%>
