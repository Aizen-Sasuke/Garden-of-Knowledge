<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Return a Book — Garden of Knowledge</title>
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
                <h1 class="page-title">🔄 Return a Book</h1>
                <div class="form-card glass-card">
                    <form action="returnProcess.jsp" method="post">

                        <div class="form-group">
                            <label>Select Book to Return</label>
                            <select name="borrowingId" required>
                                <option value="">-- Choose a borrowing --</option>
                                <%
                                    PreparedStatement ps = conn.prepareStatement(
                                        "SELECT b.id, bk.title FROM borrowings b JOIN books bk ON b.book_id = bk.id " +
                                        "WHERE b.member_id = ? AND b.return_date IS NULL ORDER BY b.id");
                                    ps.setInt(1, userId);
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                                %>
                                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("title") %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Return Date</label>
                            <input type="date" name="returnDate" required
                                value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>

                        <button type="submit" class="btn-primary">Return Book</button>
                        <a href="userDashboard.jsp" class="btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>