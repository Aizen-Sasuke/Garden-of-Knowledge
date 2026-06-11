<%-- 
    Document   : editBook
    Created on : Feb 26, 2026, 6:50:41 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE id = ?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Book</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <div class="container">
            <h1>✏️ Edit Book</h1>
            <div class="form-card">
                <form action="editBookProcess.jsp" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <label>Title</label>
                    <input type="text" name="title" value="<%= rs.getString("title") %>" required>
                    <label>Author</label>
                    <input type="text" name="author" value="<%= rs.getString("author") %>" required>
                    <label>Genre</label>
                    <input type="text" name="genre" value="<%= rs.getString("genre") %>" required>
                    <label>Total Copies</label>
                    <input type="number" name="totalCopies" value="<%= rs.getInt("total_copies") %>" required>
                    <label>Available Copies</label>
                    <input type="number" name="availableCopies" value="<%= rs.getInt("available_copies") %>" required>
                    <input type="submit" value="Save Changes">
                </form>
            </div>
            <a class="back-link" href="adminDashboard.jsp">← Back to Dashboard</a>
        </div>
    </body>
</html>
