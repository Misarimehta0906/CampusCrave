package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null
                || email.trim().isEmpty() || password.isEmpty()) {
            response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp?error=empty"
            );
            return;
        }

        String sql = "SELECT admin_id, name, email, password "
                   + "FROM admin WHERE email = ? AND status = 'Active'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    // Matches the plain-text password format used by
                    // the current project. Hashed passwords need verification
                    // using the corresponding password-hashing algorithm.
                    if (storedPassword != null
                            && storedPassword.equals(password)) {

                        HttpSession oldSession = request.getSession(false);

                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);
                        session.setAttribute("adminId",
                                rs.getInt("admin_id"));
                        session.setAttribute("adminName",
                                rs.getString("name"));
                        session.setAttribute("adminEmail",
                                rs.getString("email"));
                        session.setAttribute("adminRole", "admin");

                        session.setMaxInactiveInterval(30 * 60);

                        response.sendRedirect(
                            request.getContextPath() + "/admin/dashboard"
                        );
                        return;
                    }
                }

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/adminLogin.jsp?error=invalid"
                );
            }

        } catch (Exception e) {
            getServletContext().log("Admin login error", e);
            response.sendRedirect(
                request.getContextPath()
                + "/admin/adminLogin.jsp?error=server"
            );
        }
    }
}