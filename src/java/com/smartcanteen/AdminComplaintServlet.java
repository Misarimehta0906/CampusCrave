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

@WebServlet("/adminComplaint")
public class AdminComplaintServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> complaints =
                new ArrayList<>();

        String sql =
            "SELECT c.complaint_id, c.user_id, " +
            "c.subject, c.description, " +
            "c.complaint_date, c.status, " +
            "u.name AS user_name, u.email " +
            "FROM complaints c " +
            "LEFT JOIN users u ON c.user_id = u.user_id " +
            "ORDER BY c.complaint_date DESC";

        try {
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> complaint =
                        new HashMap<>();

                complaint.put(
                    "complaint_id",
                    rs.getInt("complaint_id")
                );

                complaint.put(
                    "user_id",
                    rs.getInt("user_id")
                );

                complaint.put(
                    "user_name",
                    rs.getString("user_name")
                );

                complaint.put(
                    "email",
                    rs.getString("email")
                );

                complaint.put(
                    "subject",
                    rs.getString("subject")
                );

                complaint.put(
                    "description",
                    rs.getString("description")
                );

                complaint.put(
                    "complaint_date",
                    rs.getTimestamp("complaint_date")
                );

                complaint.put(
                    "status",
                    rs.getString("status")
                );

                complaints.add(complaint);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "complaints",
                complaints
            );

            request.getRequestDispatcher(
                "admin/complaints.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load complaints.",
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

            if ("updateStatus".equals(action)) {

                int complaintId =
                    Integer.parseInt(
                        request.getParameter(
                            "complaintId"
                        )
                    );

                String status =
                        request.getParameter("status");

                String sql =
                    "UPDATE complaints " +
                    "SET status = ? " +
                    "WHERE complaint_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, status);
                ps.setInt(2, complaintId);

                ps.executeUpdate();

                ps.close();

            } else if ("delete".equals(action)) {

                int complaintId =
                    Integer.parseInt(
                        request.getParameter(
                            "complaintId"
                        )
                    );

                String sql =
                    "DELETE FROM complaints " +
                    "WHERE complaint_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, complaintId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminComplaint"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/complaints.jsp" +
                "?error=Complaint Operation Failed"
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
