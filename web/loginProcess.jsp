<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connection.jsp" %>
<%
    String uname = request.getParameter("username");
    String upass = request.getParameter("password");

    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM users WHERE username = ? AND password = ?");
    ps.setString(1, uname);
    ps.setString(2, upass);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String role = rs.getString("role");
        int userId = rs.getInt("id");
        
        session.setAttribute("username", uname);
        session.setAttribute("role", role);
        session.setAttribute("userId", userId);
        
        if (role.equals("admin")) {
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("userDashboard.jsp");
        }
    } else {
        request.setAttribute("error", "Invalid username or password!");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
%>