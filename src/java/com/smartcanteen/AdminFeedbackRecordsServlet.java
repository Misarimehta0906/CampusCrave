
package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminFeedbackRecords")
public class AdminFeedbackRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> feedbackList = new ArrayList<>();

        String sql =
                "SELECT id, name, rating, comment "
              + "FROM feedback ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();

                item.put("id", rs.getInt("id"));
                item.put("name", rs.getString("name"));
                item.put("rating", rs.getInt("rating"));
                item.put("comment", rs.getString("comment"));

                feedbackList.add(item);
            }

            request.setAttribute("feedbackList", feedbackList);

            request.getRequestDispatcher("/admin/feedbackRecords.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load feedback records", e);
        }
    }
}
