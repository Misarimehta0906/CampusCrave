
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

@WebServlet("/adminCategory")
public class AdminCategoryServlet extends HttpServlet {

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

        List<Map<String, Object>> categories = new ArrayList<>();

        String sql =
                "SELECT category_id, category_name, description, status "
              + "FROM categories ORDER BY category_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();

                category.put("category_id",
                        rs.getInt("category_id"));
                category.put("category_name",
                        rs.getString("category_name"));
                category.put("description",
                        rs.getString("description"));
                category.put("status",
                        rs.getString("status"));

                categories.add(category);
            }

            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/admin/categories.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load categories", e);
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
        String ctx = request.getContextPath();

        if ("add".equalsIgnoreCase(action)) {

            String name = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            if (name == null || name.trim().isEmpty()) {
                response.sendRedirect(ctx
                        + "/adminCategory?error=required");
                return;
            }

            if (status == null
                    || (!"Active".equals(status)
                    && !"Inactive".equals(status))) {
                status = "Active";
            }

            String checkSql =
                    "SELECT category_id FROM categories "
                  + "WHERE LOWER(category_name) = LOWER(?)";

            String insertSql =
                    "INSERT INTO categories "
                  + "(category_name, description, status) "
                  + "VALUES (?, ?, ?)";

            try (Connection con = DBConnection.getConnection()) {

                try (PreparedStatement ps =
                             con.prepareStatement(checkSql)) {
                    ps.setString(1, name.trim());

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            response.sendRedirect(ctx
                                    + "/adminCategory?error=duplicate");
                            return;
                        }
                    }
                }

                try (PreparedStatement ps =
                             con.prepareStatement(insertSql)) {

                    ps.setString(1, name.trim());
                    ps.setString(2,
                            description == null
                            ? "" : description.trim());
                    ps.setString(3, status);

                    ps.executeUpdate();
                }

                response.sendRedirect(
                        ctx + "/adminCategory?success=added");

            } catch (SQLException e) {
                throw new ServletException(
                        "Unable to add category", e);
            }

        } else if ("delete".equalsIgnoreCase(action)) {

            String idText = request.getParameter("categoryId");

            try {
                int categoryId = Integer.parseInt(idText);

                String sql =
                        "DELETE FROM categories WHERE category_id = ?";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setInt(1, categoryId);
                    int deleted = ps.executeUpdate();

                    response.sendRedirect(ctx
                            + (deleted > 0
                            ? "/adminCategory?success=deleted"
                            : "/adminCategory?error=notfound"));
                }

            } catch (NumberFormatException e) {
                response.sendRedirect(
                        ctx + "/adminCategory?error=invalid");
            } catch (SQLException e) {
                throw new ServletException(
                        "Unable to delete category. It may be used by food items.",
                        e);
            }

        } else {
            response.sendRedirect(ctx + "/adminCategory");
        }
    }
}
