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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminPayment")
public class AdminPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> payments =
                new ArrayList<>();

        String sql =
            "SELECT p.payment_id, p.order_id, " +
            "p.payment_method, p.amount, " +
            "p.payment_date, p.payment_status, " +
            "u.name, u.email " +
            "FROM payments p " +
            "JOIN orders o ON p.order_id = o.order_id " +
            "LEFT JOIN users u ON o.user_id = u.user_id " +
            "ORDER BY p.payment_date DESC";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> payment =
                        new HashMap<>();

                payment.put(
                    "payment_id",
                    rs.getInt("payment_id")
                );

                payment.put(
                    "order_id",
                    rs.getInt("order_id")
                );

                payment.put(
                    "payment_method",
                    rs.getString("payment_method")
                );

                payment.put(
                    "amount",
                    rs.getDouble("amount")
                );

                payment.put(
                    "payment_date",
                    rs.getTimestamp("payment_date")
                );

                payment.put(
                    "payment_status",
                    rs.getString("payment_status")
                );

                payment.put(
                    "name",
                    rs.getString("name")
                );

                payment.put(
                    "email",
                    rs.getString("email")
                );

                payments.add(payment);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "payments",
                payments
            );

            request.getRequestDispatcher(
                "admin/payments.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load payments.",
                e
            );
        }
    }


    @Override
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

                int paymentId =
                    Integer.parseInt(
                        request.getParameter("paymentId")
                    );

                String status =
                        request.getParameter("status");

                String sql =
                    "UPDATE payments " +
                    "SET payment_status = ? " +
                    "WHERE payment_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, status);
                ps.setInt(2, paymentId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminPayment"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/payments.jsp?error=Payment Operation Failed"
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