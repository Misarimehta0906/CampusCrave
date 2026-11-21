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

@WebServlet("/adminUser")
public class AdminUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> users = new ArrayList<>();

        String sql =
            "SELECT user_id, name, email, phone, created_at " +
            "FROM users " +
            "ORDER BY user_id DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> user = new HashMap<>();

                user.put("user_id",
                        rs.getInt("user_id"));

                user.put("name",
                        rs.getString("name"));

                user.put("email",
                        rs.getString("email"));

                user.put("phone",
                        rs.getString("phone"));

                user.put("created_at",
                        rs.getTimestamp("created_at"));

                users.add(user);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("users", users);

            request.getRequestDispatcher(
                "admin/users.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load users.",
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

                int userId =
                    Integer.parseInt(
                        request.getParameter("userId")
                    );

                String sql =
                    "DELETE FROM users WHERE user_id = ?";

                PreparedStatement ps =
                    con.prepareStatement(sql);

                ps.setInt(1, userId);
                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminUser"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/users.jsp?error=User Operation Failed"
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
