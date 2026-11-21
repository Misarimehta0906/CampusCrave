
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

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> foodList = new ArrayList<>();
        List<Map<String, Object>> categoryList = new ArrayList<>();

        String categorySql =
                "SELECT category_id, category_name "
              + "FROM categories "
              + "WHERE status = 'Active' "
              + "ORDER BY category_name";

        String foodSql =
                "SELECT id, name, category, price, description, special "
              + "FROM food "
              + "ORDER BY id DESC";

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

            // Load food items
            try (PreparedStatement ps =
                         con.prepareStatement(foodSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> food = new HashMap<>();

                    food.put("id", rs.getInt("id"));
                    food.put("name", rs.getString("name"));
                    food.put("category", rs.getString("category"));
                    food.put("price", rs.getDouble("price"));
                    food.put("description", rs.getString("description"));
                    food.put("special", rs.getBoolean("special"));

                    foodList.add(food);
                }
            }

            request.setAttribute("categoryList", categoryList);
            request.setAttribute("foodList", foodList);

            request.getRequestDispatcher("/menu.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load categories and food", e);
        }
    }
}