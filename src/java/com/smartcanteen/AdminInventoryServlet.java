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

@WebServlet("/adminInventory")
public class AdminInventoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> inventory =
                new ArrayList<>();

        String sql =
            "SELECT inventory_id, item_name, quantity, " +
            "unit, price, last_updated " +
            "FROM inventory " +
            "ORDER BY inventory_id DESC";

        try {
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> item =
                        new HashMap<>();

                item.put(
                    "inventory_id",
                    rs.getInt("inventory_id")
                );

                item.put(
                    "item_name",
                    rs.getString("item_name")
                );

                item.put(
                    "quantity",
                    rs.getDouble("quantity")
                );

                item.put(
                    "unit",
                    rs.getString("unit")
                );

                item.put(
                    "price",
                    rs.getDouble("price")
                );

                item.put(
                    "last_updated",
                    rs.getTimestamp("last_updated")
                );

                inventory.add(item);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "inventory",
                inventory
            );

            request.getRequestDispatcher(
                "admin/inventory.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load inventory.",
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

                String itemName =
                        request.getParameter("itemName");

                double quantity =
                    Double.parseDouble(
                        request.getParameter("quantity")
                    );

                String unit =
                        request.getParameter("unit");

                double price =
                    Double.parseDouble(
                        request.getParameter("price")
                    );

                String sql =
                    "INSERT INTO inventory " +
                    "(item_name, quantity, unit, price) " +
                    "VALUES (?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, itemName);
                ps.setDouble(2, quantity);
                ps.setString(3, unit);
                ps.setDouble(4, price);

                ps.executeUpdate();

                ps.close();

            } else if ("delete".equals(action)) {

                int inventoryId =
                    Integer.parseInt(
                        request.getParameter(
                            "inventoryId"
                        )
                    );

                String sql =
                    "DELETE FROM inventory " +
                    "WHERE inventory_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, inventoryId);

                ps.executeUpdate();

                ps.close();

            } else if ("update".equals(action)) {

                int inventoryId =
                    Integer.parseInt(
                        request.getParameter(
                            "inventoryId"
                        )
                    );

                String itemName =
                        request.getParameter("itemName");

                double quantity =
                    Double.parseDouble(
                        request.getParameter("quantity")
                    );

                String unit =
                        request.getParameter("unit");

                double price =
                    Double.parseDouble(
                        request.getParameter("price")
                    );

                String sql =
                    "UPDATE inventory SET " +
                    "item_name = ?, " +
                    "quantity = ?, " +
                    "unit = ?, " +
                    "price = ? " +
                    "WHERE inventory_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, itemName);
                ps.setDouble(2, quantity);
                ps.setString(3, unit);
                ps.setDouble(4, price);
                ps.setInt(5, inventoryId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminInventory"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/inventory.jsp" +
                "?error=Inventory Operation Failed"
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
