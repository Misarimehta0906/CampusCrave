
package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String ratingText = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (name == null || name.trim().isEmpty()
                || ratingText == null
                || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/feedback.jsp?error=required");
            return;
        }

        int rating;

        try {
            rating = Integer.parseInt(ratingText);
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/feedback.jsp?error=rating");
            return;
        }

        if (rating < 1 || rating > 5) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/feedback.jsp?error=rating");
            return;
        }

        String sql =
                "INSERT INTO feedback (name, rating, comment) "
              + "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setInt(2, rating);
            ps.setString(3, comment.trim());

            ps.executeUpdate();

            response.sendRedirect(
                    request.getContextPath() + "/thankyou.jsp");

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to save feedback", e);
        }
    }
}
