<%@page trimDirectiveWhitespaces="true" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.nio.file.*"%>
<%@page import="java.sql.*"%>
<%@page import="jakarta.servlet.http.Part"%>
<%@include file="connection.jsp" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }

    try {
        String mode = request.getParameter("mode");
        boolean editMode = "edit".equalsIgnoreCase(mode);
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String genre = request.getParameter("genre");
        int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));
        int availableCopies = editMode && request.getParameter("availableCopies") != null
                ? Integer.parseInt(request.getParameter("availableCopies"))
                : totalCopies;
        int bookId = editMode ? Integer.parseInt(request.getParameter("id")) : -1;
        boolean removeDigitalFile = "true".equalsIgnoreCase(request.getParameter("removeDigitalFile"));

        String oldFileName = null;
        String oldFilePath = null;
        String oldFileType = null;
        Long oldFileSize = null;

        if (editMode) {
            try (PreparedStatement lookup = conn.prepareStatement(
                    "SELECT digital_file_name, digital_file_path, digital_file_type, digital_file_size FROM books WHERE id = ?")) {
                lookup.setInt(1, bookId);
                try (ResultSet current = lookup.executeQuery()) {
                    if (current.next()) {
                        oldFileName = current.getString("digital_file_name");
                        oldFilePath = current.getString("digital_file_path");
                        oldFileType = current.getString("digital_file_type");
                        long size = current.getLong("digital_file_size");
                        oldFileSize = current.wasNull() ? null : size;
                    }
                }
            }
        }

        String digitalFileName = oldFileName;
        String digitalFilePath = oldFilePath;
        String digitalFileType = oldFileType;
        Long digitalFileSize = oldFileSize;

        Part filePart = null;
        try {
            filePart = request.getPart("digitalFile");
        } catch (Exception ignore) {
            filePart = null;
        }

        String uploadDirPath = System.getProperty("user.home") + File.separator + "ProjectIcchi-data" + File.separator + "book-files";
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String safeName = submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");
            String storedName = System.currentTimeMillis() + "_" + safeName;
            File targetFile = new File(uploadDir, storedName);

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            if (editMode && oldFilePath != null && !oldFilePath.isBlank() && !oldFilePath.equals(storedName)) {
                File previousFile = new File(uploadDir, oldFilePath);
                if (previousFile.exists()) {
                    previousFile.delete();
                }
            }

            digitalFileName = submittedName;
            digitalFilePath = storedName;
            digitalFileType = filePart.getContentType();
            digitalFileSize = filePart.getSize();
        } else if (editMode && removeDigitalFile) {
            if (oldFilePath != null && !oldFilePath.isBlank()) {
                File previousFile = new File(uploadDir, oldFilePath);
                if (previousFile.exists()) {
                    previousFile.delete();
                }
            }
            digitalFileName = null;
            digitalFilePath = null;
            digitalFileType = null;
            digitalFileSize = null;
        }

        if (editMode) {
            try (PreparedStatement update = conn.prepareStatement(
                    "UPDATE books SET title = ?, author = ?, genre = ?, total_copies = ?, available_copies = ?, digital_file_name = ?, digital_file_path = ?, digital_file_type = ?, digital_file_size = ? WHERE id = ?")) {
                update.setString(1, title);
                update.setString(2, author);
                update.setString(3, genre);
                update.setInt(4, totalCopies);
                update.setInt(5, availableCopies);
                update.setString(6, digitalFileName);
                update.setString(7, digitalFilePath);
                update.setString(8, digitalFileType);
                if (digitalFileSize == null) {
                    update.setNull(9, Types.BIGINT);
                } else {
                    update.setLong(9, digitalFileSize);
                }
                update.setInt(10, bookId);
                update.executeUpdate();
            }
        } else {
            try (PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO books (title, author, genre, total_copies, available_copies, digital_file_name, digital_file_path, digital_file_type, digital_file_size) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)") ) {
                insert.setString(1, title);
                insert.setString(2, author);
                insert.setString(3, genre);
                insert.setInt(4, totalCopies);
                insert.setInt(5, availableCopies);
                insert.setString(6, digitalFileName);
                insert.setString(7, digitalFilePath);
                insert.setString(8, digitalFileType);
                if (digitalFileSize == null) {
                    insert.setNull(9, Types.BIGINT);
                } else {
                    insert.setLong(9, digitalFileSize);
                }
                insert.executeUpdate();
            }
        }

        response.sendRedirect("adminDashboard.jsp");
        return;
    } catch (Exception ex) {
        response.sendError(500, ex.getMessage());
        return;
    }
%>