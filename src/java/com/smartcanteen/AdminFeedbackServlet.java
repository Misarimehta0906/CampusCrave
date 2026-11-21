package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/adminFeedback")
public class AdminFeedbackServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> feedbackList =
                new ArrayList<>();

        String sql =
            "SELECT fb.feedback_id, fb.user_id, fb.food_id, " +
            "fb.rating, fb.comment, fb.created_at, " +
            "u.name AS user_name, " +
            "f.name AS food_name " +
            "FROM feedback fb " +
            "LEFT JOIN users u ON fb.user_id = u.user_id " +
            "LEFT JOIN food f ON fb.food_id = f.food_id " +
            "ORDER BY fb.created_at DESC";

        try {
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> feedback =
                        new HashMap<>();

                feedback.put(
                    "feedback_id",
                    rs.getInt("feedback_id")
                );

                feedback.put(
                    "user_id",
                    rs.getInt("user_id")
                );

                feedback.put(
                    "food_id",
                    rs.getInt("food_id")
                );

                feedback.put(
                    "rating",
                    rs.getInt("rating")
                );

                feedback.put(
                    "comment",
                    rs.getString("comment")
                );

                feedback.put(
                    "created_at",
                    rs.getTimestamp("created_at")
                );

                feedback.put(
                    "user_name",
                    rs.getString("user_name")
                );

                feedback.put(
                    "food_name",
                    rs.getString("food_name")
                );

                feedbackList.add(feedback);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "feedbackList",
                feedbackList
            );

            request.getRequestDispatcher(
                "admin/feedback.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load feedback.",
                e
            );
        }
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        String action =
                request.getParameter("action");

        try {
            Connection con =
                    DBConnection.getConnection();

            if ("delete".equals(action)) {

                int feedbackId =
                    Integer.parseInt(
                        request.getParameter(
                            "feedbackId"
                        )
                    );

                String sql =
                    "DELETE FROM feedback " +
                    "WHERE feedback_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, feedbackId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminFeedback"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/feedback.jsp" +
                "?error=Feedback Operation Failed"
            );
        }
    }

    private boolean isAdminLoggedIn(
            HttpServletRequest request) {

        HttpSession session =
                request.getSession(false);

        return session != null
                && session.getAttribute("adminId") != null;
    }
}