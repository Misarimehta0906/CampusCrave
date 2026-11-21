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

@WebServlet("/userLogin")
public class UserLoginServlet extends HttpServlet {

    private static final int MAX_USERNAME_LENGTH = 100;
    private static final int MAX_PASSWORD_LENGTH = 255;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.trim().isEmpty()
                || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        username = username.trim();

        if (username.length() > MAX_USERNAME_LENGTH
                || password.length() > MAX_PASSWORD_LENGTH) {
            response.sendRedirect("login.jsp?error=1");
            return;
        }

        String sql = "SELECT id, name, username, password, role "
                   + "FROM users WHERE username = ? LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String role = rs.getString("role");

                    boolean validRole = role != null
                            && "customer".equalsIgnoreCase(role.trim());

                    boolean validPassword = storedPassword != null
                            && !storedPassword.isEmpty()
                            && storedPassword.equals(password);

                    if (validRole && validPassword) {
                        HttpSession oldSession = request.getSession(false);
                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("userName", rs.getString("name"));
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("userRole", role.trim().toLowerCase());

                        response.sendRedirect("index.jsp");
                        return;
                    }
                }
            }

            response.sendRedirect("login.jsp?error=1");

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to login. Check database connection and users table.", e);
        }
    }
}