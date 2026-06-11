<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    String bookIdParam = request.getParameter("bookId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Borrow a Book — Garden of Knowledge</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <canvas id="particles-canvas"></canvas>
        <div class="page-transition" id="pageTransition"></div>

        <div class="dashboard-wrapper">
            <nav class="navbar">
                <div class="nav-brand">📚 Garden of Knowledge</div>
                <div class="nav-links">
                    <a href="userDashboard.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </div>
            </nav>

            <div class="content-area">
                <h1 class="page-title">📦 Borrow a Book</h1>
                <div class="form-card glass-card">
                    <form action="borrowProcess.jsp" method="post">
                        <input type="hidden" name="memberId" value="<%= userId %>">

                        <div class="form-group">
                            <label>Select Book</label>
                            <select name="bookId" required>
                                <option value="">-- Choose a book --</option>
                                <%
                                    PreparedStatement ps = conn.prepareStatement(
                                        "SELECT id, title, author FROM books WHERE available_copies > 0 ORDER BY title");
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                                        int bid = rs.getInt("id");
                                        String selected = (bookIdParam != null && bookIdParam.equals(String.valueOf(bid))) ? "selected" : "";
                                %>
                                        <option value="<%= bid %>" <%= selected %>><%= rs.getString("title") %> — <%= rs.getString("author") %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Borrow Date</label>
                            <input type="date" name="borrowDate" required
                                value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>

                        <button type="submit" class="btn-primary">Borrow Book</button>
                        <a href="userDashboard.jsp" class="btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>