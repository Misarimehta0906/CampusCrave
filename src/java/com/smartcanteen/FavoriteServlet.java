package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String action = request.getParameter("action");
        String foodId = request.getParameter("foodId");

        try {
            Connection con = DBConnection.getConnection();

            if ("add".equals(action)) {

                String sql =
                    "INSERT INTO favorites(user_id, food_id) " +
                    "SELECT ?, ? " +
                    "WHERE NOT EXISTS " +
                    "(SELECT 1 FROM favorites WHERE user_id = ? AND food_id = ?)";

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, userId);
                ps.setInt(2, Integer.parseInt(foodId));
                ps.setInt(3, userId);
                ps.setInt(4, Integer.parseInt(foodId));

                ps.executeUpdate();
                ps.close();

            } else if ("remove".equals(action)) {

                String sql =
                    "DELETE FROM favorites " +
                    "WHERE user_id = ? AND food_id = ?";

                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, userId);
                ps.setInt(2, Integer.parseInt(foodId));

                ps.executeUpdate();
                ps.close();
            }

            con.close();

            response.sendRedirect("favorites.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "menu.jsp?error=Favorite Operation Failed"
            );
        }
    }
}
