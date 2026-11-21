
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

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

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

        String current = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (current == null || newPass == null || confirm == null
                || current.isEmpty() || newPass.length() < 6
                || !newPass.equals(confirm)) {
            response.sendRedirect("changePassword.jsp?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String stored;

            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT password FROM users WHERE id=?")) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendRedirect("login.jsp");
                        return;
                    }
                    stored = rs.getString("password");
                }
            }

            // Existing registration code stores plain-text passwords.
            if (stored == null || !stored.equals(current)) {
                response.sendRedirect("changePassword.jsp?error=current");
                return;
            }

            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET password=? WHERE id=?")) {
                ps.setString(1, newPass);
                ps.setInt(2, userId);

                if (ps.executeUpdate() > 0) {
                    response.sendRedirect("changePassword.jsp?changed=1");
                } else {
                    response.sendRedirect("changePassword.jsp?error=server");
                }
            }

        } catch (Exception e) {
            log("Unable to change password", e);
            response.sendRedirect("changePassword.jsp?error=server");
        }
    }
}

