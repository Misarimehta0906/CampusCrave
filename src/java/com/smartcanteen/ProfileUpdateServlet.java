
package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profileUpdate")
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        if (name == null || name.trim().isEmpty()
                || name.trim().length() > 100
                || (phone != null && phone.trim().length() > 15)) {
            response.sendRedirect("profile?error=invalid");
            return;
        }

        int userId = ((Number) session.getAttribute("userId")).intValue();

        String sql = "UPDATE users SET name = ?, phone = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name.trim());

            if (phone == null || phone.trim().isEmpty()) {
                ps.setNull(2, java.sql.Types.VARCHAR);
            } else {
                ps.setString(2, phone.trim());
            }

            ps.setInt(3, userId);

            if (ps.executeUpdate() > 0) {
                session.setAttribute("userName", name.trim());
                response.sendRedirect("profile?updated=1");
            } else {
                response.sendRedirect("profile?error=update");
            }

        } catch (Exception e) {
            log("Unable to update student profile", e);
            response.sendRedirect("profile?error=server");
        }
    }
}
