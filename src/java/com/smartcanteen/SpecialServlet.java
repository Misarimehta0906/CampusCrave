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

@WebServlet("/special")
public class SpecialServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> specials = new ArrayList<>();

        String sql =
            "SELECT s.special_id, s.food_id, s.special_date, " +
            "s.description, s.status, " +
            "f.name, f.price, f.image " +
            "FROM specials s " +
            "JOIN food f ON s.food_id = f.food_id " +
            "WHERE s.status = 'Active' " +
            "AND s.special_date = CURDATE() " +
            "ORDER BY s.special_id DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> special = new HashMap<>();

                special.put("special_id",
                        rs.getInt("special_id"));

                special.put("food_id",
                        rs.getInt("food_id"));

                special.put("special_date",
                        rs.getDate("special_date"));

                special.put("description",
                        rs.getString("description"));

                special.put("status",
                        rs.getString("status"));

                special.put("name",
                        rs.getString("name"));

                special.put("price",
                        rs.getDouble("price"));

                special.put("image",
                        rs.getString("image"));

                specials.add(special);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("specials", specials);

            request.getRequestDispatcher("specials.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load today's specials.",
                e
            );
        }
    }
}