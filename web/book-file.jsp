<%@page trimDirectiveWhitespaces="true" contentType="application/octet-stream" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.file.*"%>
<%@page import="java.sql.*"%>
<%@include file="connection.jsp" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String mode = request.getParameter("mode");
        boolean inline = "read".equalsIgnoreCase(mode);

        String fileName = null;
        String filePath = null;
        String fileType = null;

        try (PreparedStatement lookup = conn.prepareStatement(
                "SELECT digital_file_name, digital_file_path, digital_file_type FROM books WHERE id = ?")) {
            lookup.setInt(1, id);
            try (ResultSet rs = lookup.executeQuery()) {
                if (rs.next()) {
                    fileName = rs.getString("digital_file_name");
                    filePath = rs.getString("digital_file_path");
                    fileType = rs.getString("digital_file_type");
                }
            }
        }

        if (fileName == null || filePath == null || filePath.isBlank()) {
            response.sendError(404, "No digital file attached");
            return;
        }

        String uploadDirPath = System.getProperty("user.home") + File.separator + "ProjectIcchi-data" + File.separator + "book-files";
        File file = new File(uploadDirPath, filePath);
        if (!file.exists()) {
            response.sendError(404, "File is missing on the server");
            return;
        }

        String mimeType = fileType;
        if (mimeType == null || mimeType.isBlank()) {
            mimeType = application.getMimeType(file.getName());
        }
        if (mimeType == null || mimeType.isBlank()) {
            try {
                mimeType = Files.probeContentType(file.toPath());
            } catch (Exception ignore) {
                mimeType = null;
            }
        }
        if (mimeType == null || mimeType.isBlank()) {
            mimeType = "application/octet-stream";
        }

        response.reset();
        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());
        response.setHeader("Content-Disposition", (inline ? "inline" : "attachment") + "; filename=\"" + fileName.replace("\"", "") + "\"");

        try (InputStream input = new FileInputStream(file); OutputStream output = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int length;
            while ((length = input.read(buffer)) != -1) {
                output.write(buffer, 0, length);
            }
            output.flush();
        }
        return;
    } catch (Exception ex) {
        response.sendError(500, ex.getMessage());
        return;
    }
%>