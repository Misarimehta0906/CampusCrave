package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        try {
            Connection con = DBConnection.getConnection();

            String sql =
                "INSERT INTO complaints " +
                "(user_id, subject, description, status) " +
                "VALUES (?, ?, ?, 'Pending')";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, description);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(
                "complaints.jsp?success=Complaint Submitted Successfully"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "complaints.jsp?error=Complaint Submission Failed"
            );
        }
    }
}
