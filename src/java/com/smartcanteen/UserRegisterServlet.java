
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

@WebServlet("/userRegister")
public class UserRegisterServlet extends HttpServlet {

    private static final int MIN_PASSWORD_LENGTH = 6;
    private static final int MAX_NAME_LENGTH = 100;
    private static final int MAX_USERNAME_LENGTH = 100;
    private static final int MAX_PASSWORD_LENGTH = 255;

    private static final String NAME_REGEX = "^[\\p{L} .'-]+$";
    private static final String USERNAME_REGEX = "^[A-Za-z0-9._-]+$";
    private static final String PHONE_REGEX = "^[0-9]{10}$";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check all fields
        if (name == null || username == null || phone == null
                || password == null || confirmPassword == null
                || name.trim().isEmpty()
                || username.trim().isEmpty()
                || phone.trim().isEmpty()
                || password.isEmpty()
                || confirmPassword.isEmpty()) {

            response.sendRedirect("register.jsp?error=empty");
            return;
        }

        name = name.trim().replaceAll("\\s+", " ");
        username = username.trim();
        phone = phone.trim();

        // Name validation
        if (name.length() > MAX_NAME_LENGTH
                || !name.matches(NAME_REGEX)) {

            response.sendRedirect("register.jsp?error=name");
            return;
        }

        // Username validation
        if (username.length() > MAX_USERNAME_LENGTH
                || !username.matches(USERNAME_REGEX)) {

            response.sendRedirect("register.jsp?error=username");
            return;
        }

        // Phone number validation
        if (!phone.matches(PHONE_REGEX)) {

            response.sendRedirect("register.jsp?error=phone");
            return;
        }

        // Password validation
        if (password.length() < MIN_PASSWORD_LENGTH
                || password.length() > MAX_PASSWORD_LENGTH
                || password.trim().isEmpty()) {

            response.sendRedirect("register.jsp?error=password");
            return;
        }

        // Confirm password validation
        if (!password.equals(confirmPassword)) {

            response.sendRedirect("register.jsp?error=mismatch");
            return;
        }

        String checkSql =
                "SELECT id FROM users WHERE username = ? LIMIT 1";

        String insertSql =
                "INSERT INTO users (name, username, password, phone, role) "
                + "VALUES (?, ?, ?, ?, 'customer')";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {

                // Check duplicate username
                try (PreparedStatement check =
                        con.prepareStatement(checkSql)) {

                    check.setString(1, username);

                    try (ResultSet rs = check.executeQuery()) {

                        if (rs.next()) {
                            con.rollback();

                            response.sendRedirect(
                                    "register.jsp?error=exists");
                            return;
                        }
                    }
                }

                // Insert user into database
                try (PreparedStatement ps =
                        con.prepareStatement(insertSql)) {

                    ps.setString(1, name);
                    ps.setString(2, username);
                    ps.setString(3, password);
                    ps.setString(4, phone);

                    ps.executeUpdate();
                }

                con.commit();

                response.sendRedirect("login.jsp?registered=1");

            } catch (Exception e) {

                con.rollback();
                throw e;

            } finally {

                con.setAutoCommit(true);
            }

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to register. Check database connection and users table.", e);
        }
    }
}
