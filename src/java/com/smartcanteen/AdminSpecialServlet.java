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

@WebServlet("/adminSpecial")
public class AdminSpecialServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> specials =
                new ArrayList<>();

        String sql =
            "SELECT s.special_id, s.food_id, " +
            "s.special_date, s.description, s.status, " +
            "f.name, f.price, f.image " +
            "FROM specials s " +
            "LEFT JOIN food f ON s.food_id = f.food_id " +
            "ORDER BY s.special_id DESC";

        try {
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> special =
                        new HashMap<>();

                special.put(
                    "special_id",
                    rs.getInt("special_id")
                );

                special.put(
                    "food_id",
                    rs.getInt("food_id")
                );

                special.put(
                    "special_date",
                    rs.getDate("special_date")
                );

                special.put(
                    "description",
                    rs.getString("description")
                );

                special.put(
                    "status",
                    rs.getString("status")
                );

                special.put(
                    "name",
                    rs.getString("name")
                );

                special.put(
                    "price",
                    rs.getDouble("price")
                );

                special.put(
                    "image",
                    rs.getString("image")
                );

                specials.add(special);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "specials",
                specials
            );

            request.getRequestDispatcher(
                "admin/specials.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load specials.",
                e
            );
        }
    }

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

            if ("add".equals(action)) {

                int foodId =
                    Integer.parseInt(
                        request.getParameter("foodId")
                    );

                String specialDate =
                        request.getParameter(
                            "specialDate"
                        );

                String description =
                        request.getParameter(
                            "description"
                        );

                String status =
                        request.getParameter("status");

                if (status == null ||
                    status.trim().isEmpty()) {

                    status = "Active";
                }

                String sql =
                    "INSERT INTO specials " +
                    "(food_id, special_date, " +
                    "description, status) " +
                    "VALUES (?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, foodId);
                ps.setString(2, specialDate);
                ps.setString(3, description);
                ps.setString(4, status);

                ps.executeUpdate();

                ps.close();

            } else if ("delete".equals(action)) {

                int specialId =
                    Integer.parseInt(
                        request.getParameter(
                            "specialId"
                        )
                    );

                String sql =
                    "DELETE FROM specials " +
                    "WHERE special_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, specialId);

                ps.executeUpdate();

                ps.close();

            } else if ("updateStatus".equals(action)) {

                int specialId =
                    Integer.parseInt(
                        request.getParameter(
                            "specialId"
                        )
                    );

                String status =
                        request.getParameter("status");

                String sql =
                    "UPDATE specials " +
                    "SET status = ? " +
                    "WHERE special_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, status);
                ps.setInt(2, specialId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminSpecial"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/specials.jsp" +
                "?error=Special Operation Failed"
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