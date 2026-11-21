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

@WebServlet("/favoriteList")
public class FavoriteListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        List<Map<String, Object>> favorites = new ArrayList<>();

        String sql =
            "SELECT f.food_id, f.name, f.price, f.description, f.image, " +
            "c.category_name " +
            "FROM favorites fav " +
            "JOIN food f ON fav.food_id = f.food_id " +
            "LEFT JOIN categories c ON f.category_id = c.category_id " +
            "WHERE fav.user_id = ? " +
            "ORDER BY fav.added_date DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> favorite = new HashMap<>();

                favorite.put("food_id",
                        rs.getInt("food_id"));

                favorite.put("name",
                        rs.getString("name"));

                favorite.put("price",
                        rs.getDouble("price"));

                favorite.put("description",
                        rs.getString("description"));

                favorite.put("image",
                        rs.getString("image"));

                favorite.put("category_name",
                        rs.getString("category_name"));

                favorites.add(favorite);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("favorites", favorites);

            request.getRequestDispatcher("favorites.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load favorite foods.",
                e
            );
        }
    }
}