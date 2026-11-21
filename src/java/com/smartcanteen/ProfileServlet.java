
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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether student is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId;

        try {
            userId = ((Number) session.getAttribute("userId")).intValue();
        } catch (Exception e) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        String sql = "SELECT id, name, username, phone, photo, role "
                   + "FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    request.setAttribute("studentId", rs.getInt("id"));
                    request.setAttribute("studentName", rs.getString("name"));
                    request.setAttribute("studentUsername", rs.getString("username"));
                    request.setAttribute("studentPhone", rs.getString("phone"));
                    request.setAttribute("studentPhoto", rs.getString("photo"));
                    request.setAttribute("studentRole", rs.getString("role"));

                    request.getRequestDispatcher("/profile.jsp")
                           .forward(request, response);

                } else {
                    session.invalidate();
                    response.sendRedirect("login.jsp");
                }
            }

        } catch (Exception e) {
            log("Error loading student profile", e);
            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load profile. Check the database and server logs."
            );
        }
    }
}
