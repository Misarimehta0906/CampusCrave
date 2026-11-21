
package com.smartcanteen;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/uploadPhoto")
@MultipartConfig(maxFileSize = 2097152, maxRequestSize = 3145728)
public class UploadPhotoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = ((Number) session.getAttribute("userId")).intValue();
        Path savedFile = null;

        try {
            Part part = request.getPart("photoFile");

            if (part == null || part.getSize() == 0
                    || part.getSize() > 2097152) {
                response.sendRedirect("profile?photoError=size");
                return;
            }

            String type;
            try (InputStream in = part.getInputStream()) {
                BufferedImage image = ImageIO.read(in);

                if (image == null || image.getWidth() > 5000
                        || image.getHeight() > 5000) {
                    response.sendRedirect("profile?photoError=invalid");
                    return;
                }

                String mime = part.getContentType();
                if ("image/jpeg".equalsIgnoreCase(mime)) {
                    type = "jpg";
                } else if ("image/png".equalsIgnoreCase(mime)) {
                    type = "png";
                } else {
                    response.sendRedirect("profile?photoError=type");
                    return;
                }
            }

            String realPath = getServletContext().getRealPath("/uploads");
            if (realPath == null) {
                response.sendRedirect("profile?photoError=storage");
                return;
            }

            Path directory = Paths.get(realPath).toAbsolutePath().normalize();
            Files.createDirectories(directory);

            String filename = "student_" + userId + "_"
                    + UUID.randomUUID() + "." + type;

            savedFile = directory.resolve(filename).normalize();

            if (!savedFile.startsWith(directory)) {
                response.sendRedirect("profile?photoError=storage");
                return;
            }

            try (InputStream in = part.getInputStream()) {
                BufferedImage image = ImageIO.read(in);
                if (image == null || !ImageIO.write(image, type, savedFile.toFile())) {
                    response.sendRedirect("profile?photoError=invalid");
                    return;
                }
            }

            String oldPhoto = null;

            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                try {
                    try (PreparedStatement ps = con.prepareStatement(
                            "SELECT photo FROM users WHERE id=? FOR UPDATE")) {
                        ps.setInt(1, userId);

                        try (java.sql.ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                oldPhoto = rs.getString("photo");
                            } else {
                                con.rollback();
                                response.sendRedirect("login.jsp");
                                return;
                            }
                        }
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE users SET photo=? WHERE id=?")) {
                        ps.setString(1, filename);
                        ps.setInt(2, userId);
                        ps.executeUpdate();
                    }

                    con.commit();
                } catch (Exception e) {
                    con.rollback();
                    throw e;
                } finally {
                    con.setAutoCommit(true);
                }
            }

            if (oldPhoto != null
                    && oldPhoto.matches("student_" + userId
                        + "_[a-fA-F0-9-]+\\.(jpg|png)")) {
                Files.deleteIfExists(directory.resolve(oldPhoto).normalize());
            }

            response.sendRedirect("profile?photoUpdated=1");

        } catch (Exception e) {
            if (savedFile != null) {
                Files.deleteIfExists(savedFile);
            }
            log("Photo upload failed", e);
            response.sendRedirect("profile?photoError=server");
        }
    }
}

