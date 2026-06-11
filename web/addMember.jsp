<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Member — Garden of Knowledge</title>
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
                    <a href="adminDashboard.jsp">Dashboard</a>
                    <a href="logout.jsp">Logout</a>
                </div>
            </nav>

            <div class="content-area">
                <h1 class="page-title">👤 Add New Member</h1>
                <div class="form-card glass-card">
                    <form action="addMemberProcess.jsp" method="post">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" required placeholder="Enter full name">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" required placeholder="Enter email address">
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="text" name="phone" placeholder="Enter phone number">
                        </div>
                        <button type="submit" class="btn-primary">Add Member</button>
                        <a href="adminDashboard.jsp" class="btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>

        <script src="style.js"></script>
    </body>
</html>