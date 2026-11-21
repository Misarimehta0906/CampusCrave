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

@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        List<Map<String, Object>> orders = new ArrayList<>();

        String sql =
            "SELECT order_id, total_amount, status, order_date " +
            "FROM orders " +
            "WHERE user_id = ? " +
            "ORDER BY order_date DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> order = new HashMap<>();

                order.put("order_id",
                        rs.getInt("order_id"));

                order.put("total_amount",
                        rs.getDouble("total_amount"));

                order.put("status",
                        rs.getString("status"));

                order.put("order_date",
                        rs.getTimestamp("order_date"));

                orders.add(order);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("orders", orders);

            request.getRequestDispatcher("orders.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load order history.",
                e
            );
        }
    }
}