
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

@WebServlet("/admin/food")
public class AdminFoodServlet extends HttpServlet {

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return session != null
                && session.getAttribute("adminId") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> categoryList = new ArrayList<>();
        List<Map<String, Object>> foodList = new ArrayList<>();

        String categorySql =
                "SELECT category_id, category_name "
              + "FROM categories "
              + "WHERE status = 'Active' "
              + "ORDER BY category_name";

        String foodSql =
                "SELECT id, name, category, price, description, special "
              + "FROM food ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection()) {

            // Load active categories
            try (PreparedStatement ps =
                         con.prepareStatement(categorySql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> category = new HashMap<>();

                    category.put("category_id",
                            rs.getInt("category_id"));
                    category.put("category_name",
                            rs.getString("category_name"));

                    categoryList.add(category);
                }
            }

            // Load existing food
            try (PreparedStatement ps =
                         con.prepareStatement(foodSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> food = new HashMap<>();

                    food.put("id", rs.getInt("id"));
                    food.put("name", rs.getString("name"));
                    food.put("category", rs.getString("category"));
                    food.put("price", rs.getDouble("price"));
                    food.put("description",
                            rs.getString("description"));
                    food.put("special", rs.getBoolean("special"));

                    foodList.add(food);
                }
            }

            request.setAttribute("categoryList", categoryList);
            request.setAttribute("foodList", foodList);

            request.getRequestDispatcher("/admin/food.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load food and categories", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/adminLogin.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/food");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            if ("add".equalsIgnoreCase(action)) {

                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String priceText = request.getParameter("price");
                String description =
                        request.getParameter("description");

                if (name == null || name.trim().isEmpty()
                        || category == null || category.trim().isEmpty()
                        || priceText == null || priceText.trim().isEmpty()) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/food?error=required");
                    return;
                }

                double price;

                try {
                    price = Double.parseDouble(priceText);
                } catch (NumberFormatException e) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/food?error=price");
                    return;
                }

                if (price < 0 || Double.isNaN(price)
                        || Double.isInfinite(price)) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/food?error=price");
                    return;
                }

                // Ensure selected category exists and is active
                String checkSql =
                        "SELECT category_id FROM categories "
                      + "WHERE category_name = ? "
                      + "AND status = 'Active'";

                boolean categoryExists = false;

                try (PreparedStatement ps =
                             con.prepareStatement(checkSql)) {

                    ps.setString(1, category.trim());

                    try (ResultSet rs = ps.executeQuery()) {
                        categoryExists = rs.next();
                    }
                }

                if (!categoryExists) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/food?error=category");
                    return;
                }

                boolean special =
                        "1".equals(request.getParameter("special"));

                String insertSql =
                        "INSERT INTO food "
                      + "(name, category, price, description, special) "
                      + "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement ps =
                             con.prepareStatement(insertSql)) {

                    ps.setString(1, name.trim());
                    ps.setString(2, category.trim());
                    ps.setDouble(3, price);
                    ps.setString(4,
                            description == null
                            ? "" : description.trim());
                    ps.setBoolean(5, special);

                    ps.executeUpdate();
                }

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/food?success=added");
                return;

            } else if ("delete".equalsIgnoreCase(action)) {

                String idText = request.getParameter("id");

                if (idText == null || idText.trim().isEmpty()) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/food?error=id");
                    return;
                }

                int id = Integer.parseInt(idText);

                String deleteSql = "DELETE FROM food WHERE id = ?";

                try (PreparedStatement ps =
                             con.prepareStatement(deleteSql)) {

                    ps.setInt(1, id);
                    ps.executeUpdate();
                }

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/food?success=deleted");
                return;
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/food");

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to save food", e);
        } catch (NumberFormatException e) {
            throw new ServletException(
                    "Invalid food ID", e);
        }
    }
}
