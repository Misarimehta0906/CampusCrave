
package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
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

@WebServlet(urlPatterns = {
    "/admin/categories",
    "/admin/orders",
    "/admin/users",
    "/admin/feedback",
    "/admin/coupons",
    "/admin/payments",
    "/admin/specials"
})
public class AdminDataServlet extends HttpServlet {

    private static final Map<String, String> TABLES = new HashMap<>();

    static {
        TABLES.put("categories",
            "SELECT category_id, category_name, description, status " +
            "FROM categories ORDER BY category_id DESC");

        TABLES.put("orders",
            "SELECT id, customer_name, phone, food_details, total, payment, status, order_date " +
            "FROM orders ORDER BY id DESC");

        TABLES.put("users",
            "SELECT id, name, username, phone, role " +
            "FROM users ORDER BY id DESC");

        TABLES.put("feedback",
            "SELECT id, name, rating, comment " +
            "FROM feedback ORDER BY id DESC");

        TABLES.put("coupons",
            "SELECT coupon_id, coupon_code, discount, min_order_amount, expiry_date, status " +
            "FROM coupons ORDER BY coupon_id DESC");

        TABLES.put("payments",
            "SELECT payment_id, order_id, payment_method, amount, payment_date, payment_status " +
            "FROM payments ORDER BY payment_id DESC");

        TABLES.put("specials",
            "SELECT special_id, food_id, special_date, description, status " +
            "FROM specials ORDER BY special_id DESC");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp"
            );
            return;
        }

        String path = request.getServletPath();
        String page = path.substring(path.lastIndexOf("/") + 1);

        String sql = TABLES.get(page);

        if (sql == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        List<String> columns = new ArrayList<>();
        List<List<String>> rows = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            ResultSetMetaData md = rs.getMetaData();
            int count = md.getColumnCount();

            for (int i = 1; i <= count; i++) {
                columns.add(md.getColumnLabel(i));
            }

            while (rs.next()) {
                List<String> row = new ArrayList<>();

                for (int i = 1; i <= count; i++) {
                    String value = rs.getString(i);
                    row.add(value == null ? "" : value);
                }

                rows.add(row);
            }

        } catch (SQLException e) {
            getServletContext().log(
                "Admin page error: " + page, e
            );

            throw new ServletException(
                "Unable to load " + page +
                ". Check the database schema.", e
            );
        }

        request.setAttribute("pageName", page);
        request.setAttribute("columns", columns);
        request.setAttribute("rows", rows);

        request.getRequestDispatcher("/admin/admin-data.jsp")
               .forward(request, response);
    }
}
