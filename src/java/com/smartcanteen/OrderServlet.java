
package com.smartcanteen;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static class OrderItem {
        int foodId;
        int quantity;
        String name;
        BigDecimal price;

        OrderItem(int foodId, int quantity, String name,
                  BigDecimal price) {
            this.foodId = foodId;
            this.quantity = quantity;
            this.name = name;
            this.price = price;
        }

        BigDecimal getSubtotal() {
            return price.multiply(BigDecimal.valueOf(quantity))
                    .setScale(2, RoundingMode.HALF_UP);
        }
    }

    private void redirectError(HttpServletRequest request,
                               HttpServletResponse response,
                               String message)
            throws IOException {

        String encoded = URLEncoder.encode(message, "UTF-8");

        response.sendRedirect(
                request.getContextPath()
                + "/cart.jsp?error=" + encoded
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId;

        try {
            userId = Integer.parseInt(
                    String.valueOf(session.getAttribute("userId"))
            );
        } catch (NumberFormatException ex) {
            redirectError(request, response, "Please login again.");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String couponCode = request.getParameter("couponCode");

        String[] foodIds = request.getParameterValues("foodIds");
        String[] quantities = request.getParameterValues("quantities");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            redirectError(request, response, "Please select a payment method.");
            return;
        }

        paymentMethod = paymentMethod.trim();

        if (!paymentMethod.equalsIgnoreCase("Cash")
                && !paymentMethod.equalsIgnoreCase("UPI")
                && !paymentMethod.equalsIgnoreCase("Card")) {
            redirectError(request, response, "Invalid payment method.");
            return;
        }

        if (foodIds == null || quantities == null
                || foodIds.length == 0
                || foodIds.length != quantities.length) {
            redirectError(request, response, "Your cart is empty.");
            return;
        }

        if (foodIds.length > 100) {
            redirectError(request, response, "Too many items in your cart.");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                // 1. Get the logged-in customer's details.
                String customerName;
                String phone;

                String userSql =
                        "SELECT name, phone FROM users WHERE id = ?";

                try (PreparedStatement ps = con.prepareStatement(userSql)) {
                    ps.setInt(1, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new Exception(
                                    "User not found. Please login again."
                            );
                        }

                        customerName = rs.getString("name");
                        phone = rs.getString("phone");
                    }
                }

                // 2. Validate food IDs and calculate prices from the database.
                List<OrderItem> items = new ArrayList<>();
                Set<Integer> uniqueFoodIds = new HashSet<>();
                BigDecimal subtotal = BigDecimal.ZERO;

                String foodSql =
                        "SELECT id, name, price FROM food WHERE id = ?";

                for (int i = 0; i < foodIds.length; i++) {

                    int foodId;
                    int quantity;

                    try {
                        foodId = Integer.parseInt(foodIds[i]);
                        quantity = Integer.parseInt(quantities[i]);
                    } catch (NumberFormatException ex) {
                        throw new Exception(
                                "Invalid food item or quantity."
                        );
                    }

                    if (foodId <= 0 || quantity < 1 || quantity > 99) {
                        throw new Exception(
                                "Food quantity must be between 1 and 99."
                        );
                    }

                    if (!uniqueFoodIds.add(foodId)) {
                        throw new Exception(
                                "Duplicate food item found in cart."
                        );
                    }

                    try (PreparedStatement ps =
                                 con.prepareStatement(foodSql)) {

                        ps.setInt(1, foodId);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                throw new Exception(
                                        "A food item no longer exists. "
                                        + "Please refresh your menu."
                                );
                            }

                            String name = rs.getString("name");
                            BigDecimal price = rs.getBigDecimal("price");

                            if (price == null
                                    || price.compareTo(BigDecimal.ZERO) < 0) {
                                throw new Exception(
                                        "Invalid price for " + name
                                );
                            }

                            OrderItem item = new OrderItem(
                                    foodId, quantity, name, price
                            );

                            items.add(item);
                            subtotal = subtotal.add(item.getSubtotal());
                        }
                    }
                }

                subtotal = subtotal.setScale(2, RoundingMode.HALF_UP);

                if (items.isEmpty() || subtotal.compareTo(
                        BigDecimal.ZERO) <= 0) {
                    throw new Exception("Your cart is empty.");
                }

                // 3. Validate coupon using the database.
                BigDecimal discountAmount = BigDecimal.ZERO;
                String appliedCoupon = null;

                if (couponCode != null && !couponCode.trim().isEmpty()) {

                    couponCode = couponCode.trim();

                    String couponSql =
                            "SELECT coupon_code, discount, min_order_amount, "
                            + "expiry_date, status "
                            + "FROM coupons "
                            + "WHERE UPPER(coupon_code) = UPPER(?) "
                            + "LIMIT 1";

                    try (PreparedStatement ps =
                                 con.prepareStatement(couponSql)) {

                        ps.setString(1, couponCode);

                        try (ResultSet rs = ps.executeQuery()) {

                            if (!rs.next()) {
                                throw new Exception("Invalid coupon code.");
                            }

                            BigDecimal percent = rs.getBigDecimal("discount");
                            BigDecimal minimum =
                                    rs.getBigDecimal("min_order_amount");
                            Date expiry = rs.getDate("expiry_date");
                            String status = rs.getString("status");

                            if (status == null
                                    || !"Active".equalsIgnoreCase(status)) {
                                throw new Exception(
                                        "This coupon is not active."
                                );
                            }

                            if (expiry != null
                                    && expiry.toLocalDate().isBefore(
                                            LocalDate.now())) {
                                throw new Exception("Coupon has expired.");
                            }

                            if (percent == null
                                    || percent.compareTo(BigDecimal.ZERO) <= 0
                                    || percent.compareTo(
                                            new BigDecimal("100")) > 0) {
                                throw new Exception(
                                        "Invalid coupon discount."
                                );
                            }

                            if (minimum == null) {
                                minimum = BigDecimal.ZERO;
                            }

                            if (subtotal.compareTo(minimum) < 0) {
                                throw new Exception(
                                        "Minimum order amount is ₹"
                                        + minimum.toPlainString()
                                        + " for this coupon."
                                );
                            }

                            discountAmount = subtotal.multiply(percent)
                                    .divide(
                                            new BigDecimal("100"),
                                            2,
                                            RoundingMode.HALF_UP
                                    );

                            appliedCoupon = rs.getString("coupon_code");
                        }
                    }
                }

                BigDecimal finalTotal = subtotal.subtract(discountAmount)
                        .setScale(2, RoundingMode.HALF_UP);

                if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                    finalTotal = BigDecimal.ZERO;
                }

                // 4. Prepare the order description.
                StringBuilder details = new StringBuilder();

                for (OrderItem item : items) {
                    if (details.length() > 0) {
                        details.append(", ");
                    }

                    details.append(item.name)
                            .append(" x ")
                            .append(item.quantity);
                }

                if (appliedCoupon != null) {
                    details.append(" | Coupon: ").append(appliedCoupon);
                    details.append(" | Discount: ₹")
                            .append(discountAmount.toPlainString());
                }

                // 5. Save order with the final discounted total.
                int orderId;

                String orderSql =
                        "INSERT INTO orders "
                        + "(customer_name, phone, food_details, total, "
                        + "payment, status) "
                        + "VALUES (?, ?, ?, ?, ?, 'Pending')";

                try (PreparedStatement ps = con.prepareStatement(
                        orderSql, Statement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, customerName);
                    ps.setString(2, phone);
                    ps.setString(3, details.toString());
                    ps.setBigDecimal(4, finalTotal);
                    ps.setString(5, paymentMethod);

                    int affected = ps.executeUpdate();

                    if (affected != 1) {
                        throw new Exception("Could not save your order.");
                    }

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new Exception(
                                    "Could not retrieve order ID."
                            );
                        }

                        orderId = keys.getInt(1);
                    }
                }

                // 6. Save individual food items.
                String itemSql =
                        "INSERT INTO order_items "
                        + "(order_id, food_id, quantity, price, subtotal) "
                        + "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                    for (OrderItem item : items) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, item.foodId);
                        ps.setInt(3, item.quantity);
                        ps.setBigDecimal(4, item.price);
                        ps.setBigDecimal(5, item.getSubtotal());
                        ps.executeUpdate();
                    }
                }

                // 7. Save payment using the discounted final amount.
                String paymentSql =
                        "INSERT INTO payments "
                        + "(order_id, payment_method, amount, payment_status) "
                        + "VALUES (?, ?, ?, 'Pending')";

                try (PreparedStatement ps =
                             con.prepareStatement(paymentSql)) {
                    ps.setInt(1, orderId);
                    ps.setString(2, paymentMethod);
                    ps.setBigDecimal(3, finalTotal);
                    ps.executeUpdate();
                }

                // 8. Commit only after all database inserts succeed.
                con.commit();

                session.removeAttribute("couponCode");
                session.removeAttribute("discountPercent");
                session.removeAttribute("discountAmount");
                session.removeAttribute("finalAmount");
                session.removeAttribute("couponCartTotal");

                response.sendRedirect(
                        request.getContextPath()
                        + "/orders.jsp?success=Order+placed+successfully"
                        + "&orderId=" + orderId
                );

            } catch (Exception ex) {

                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    log("Could not rollback failed order.", rollbackError);
                }

                log("Order placement failed.", ex);

                String message = ex.getMessage();

                if (message == null || message.trim().isEmpty()) {
                    message = "Order failed. Please try again.";
                }

                redirectError(request, response, message);

            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ex) {
                    log("Could not reset database connection.", ex);
                }
            }

        } catch (SQLException ex) {
            log("Database connection or order SQL failed.", ex);

            redirectError(
                    request,
                    response,
                    "Database error. Check your database connection and tables."
            );
        }
    }
}
