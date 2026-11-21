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

@WebServlet("/adminOrder")
public class AdminOrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> orders = new ArrayList<>();

        String sql =
            "SELECT o.order_id, o.user_id, u.name, u.email, " +
            "o.total_amount, o.status, o.order_date " +
            "FROM orders o " +
            "LEFT JOIN users u ON o.user_id = u.user_id " +
            "ORDER BY o.order_date DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> order =
                    new HashMap<>();

                order.put(
                    "order_id",
                    rs.getInt("order_id")
                );

                order.put(
                    "user_id",
                    rs.getInt("user_id")
                );

                order.put(
                    "name",
                    rs.getString("name")
                );

                order.put(
                    "email",
                    rs.getString("email")
                );

                order.put(
                    "total_amount",
                    rs.getDouble("total_amount")
                );

                order.put(
                    "status",
                    rs.getString("status")
                );

                order.put(
                    "order_date",
                    rs.getTimestamp("order_date")
                );

                orders.add(order);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "orders",
                orders
            );

            request.getRequestDispatcher(
                "admin/orders.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load orders.",
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

                int orderId =
                    Integer.parseInt(
                        request.getParameter("orderId")
                    );

                String status =
                    request.getParameter("status");

                String sql =
                    "UPDATE orders " +
                    "SET status = ? " +
                    "WHERE order_id = ?";

                PreparedStatement ps =
                    con.prepareStatement(sql);

                ps.setString(1, status);
                ps.setInt(2, orderId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminOrder"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/orders.jsp?error=Order Operation Failed"
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
