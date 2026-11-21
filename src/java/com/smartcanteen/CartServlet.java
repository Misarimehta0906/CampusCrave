
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private Integer getLoggedInUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {
            return null;
        }

        Object value = session.getAttribute("userId");

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = getLoggedInUserId(request);

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("increase".equals(action) ||
                "decrease".equals(action) ||
                "remove".equals(action)) {

                updateCart(request, userId, action);
                response.sendRedirect("cart?action=view");
                return;
            }

            if ("view".equals(action) || action == null) {
                showCart(request, response, userId);
                return;
            }

            response.sendRedirect("cart?action=view");

        } catch (Exception e) {
            throw new ServletException("Unable to process cart.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = getLoggedInUserId(request);

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (!"add".equals(action)) {
            response.sendRedirect("cart?action=view");
            return;
        }

        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity < 1 || quantity > 99) {
                response.sendRedirect("menu?error=InvalidQuantity");
                return;
            }

            try (Connection con = DBConnection.getConnection()) {

                // Check whether this food is already in the user's cart.
                String checkSql =
                    "SELECT quantity FROM cart " +
                    "WHERE user_id = ? AND food_id = ? LIMIT 1";

                boolean found = false;

                try (PreparedStatement check = con.prepareStatement(checkSql)) {
                    check.setInt(1, userId);
                    check.setInt(2, foodId);

                    try (ResultSet rs = check.executeQuery()) {
                        if (rs.next()) {
                            found = true;
                        }
                    }
                }

                if (found) {
                    String updateSql =
                        "UPDATE cart SET quantity = quantity + ? " +
                        "WHERE user_id = ? AND food_id = ?";

                    try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                        ps.setInt(1, quantity);
                        ps.setInt(2, userId);
                        ps.setInt(3, foodId);
                        ps.executeUpdate();
                    }
                } else {
                    String insertSql =
                        "INSERT INTO cart (user_id, food_id, quantity) " +
                        "VALUES (?, ?, ?)";

                    try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                        ps.setInt(1, userId);
                        ps.setInt(2, foodId);
                        ps.setInt(3, quantity);
                        ps.executeUpdate();
                    }
                }
            }

            response.sendRedirect("cart?action=view");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Invalid food ID or quantity.");
        } catch (Exception e) {
            throw new ServletException("Unable to add item to cart.", e);
        }
    }

    private void updateCart(HttpServletRequest request,
                            int userId,
                            String action) throws Exception {

        int foodId = Integer.parseInt(request.getParameter("foodId"));

        String sql;

        if ("remove".equals(action)) {
            sql = "DELETE FROM cart WHERE user_id = ? AND food_id = ?";
        } else if ("increase".equals(action)) {
            sql = "UPDATE cart SET quantity = quantity + 1 " +
                  "WHERE user_id = ? AND food_id = ?";
        } else {
            sql = "UPDATE cart SET quantity = GREATEST(quantity - 1, 1) " +
                  "WHERE user_id = ? AND food_id = ?";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, foodId);
            ps.executeUpdate();
        }
    }

    private void showCart(HttpServletRequest request,
                          HttpServletResponse response,
                          int userId)
            throws Exception {

        List<Map<String, Object>> cartItems = new ArrayList<>();
        double cartTotal = 0.0;

        String sql =
            "SELECT c.food_id, f.name, f.category, f.price, " +
            "c.quantity, (f.price * c.quantity) AS subtotal " +
            "FROM cart c " +
            "JOIN food f ON f.id = c.food_id " +
            "WHERE c.user_id = ? " +
            "ORDER BY f.name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();

                    item.put("foodId", rs.getInt("food_id"));
                    item.put("name", rs.getString("name"));
                    item.put("category", rs.getString("category"));
                    item.put("price", rs.getDouble("price"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("subtotal", rs.getDouble("subtotal"));

                    cartTotal += rs.getDouble("subtotal");
                    cartItems.add(item);
                }
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("cart.jsp")
               .forward(request, response);
    }
}
