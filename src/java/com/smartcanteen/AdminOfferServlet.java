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

@WebServlet("/adminOffer")
public class AdminOfferServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect("admin/adminLogin.jsp");
            return;
        }

        List<Map<String, Object>> offers =
                new ArrayList<>();

        String sql =
            "SELECT offer_id, offer_title, description, " +
            "discount, start_date, end_date, status " +
            "FROM offers " +
            "ORDER BY offer_id DESC";

        try {
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> offer =
                        new HashMap<>();

                offer.put(
                    "offer_id",
                    rs.getInt("offer_id")
                );

                offer.put(
                    "offer_title",
                    rs.getString("offer_title")
                );

                offer.put(
                    "description",
                    rs.getString("description")
                );

                offer.put(
                    "discount",
                    rs.getDouble("discount")
                );

                offer.put(
                    "start_date",
                    rs.getDate("start_date")
                );

                offer.put(
                    "end_date",
                    rs.getDate("end_date")
                );

                offer.put(
                    "status",
                    rs.getString("status")
                );

                offers.add(offer);
            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute(
                "offers",
                offers
            );

            request.getRequestDispatcher(
                "admin/offers.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load offers.",
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

                String offerTitle =
                        request.getParameter(
                            "offerTitle"
                        );

                String description =
                        request.getParameter(
                            "description"
                        );

                double discount =
                    Double.parseDouble(
                        request.getParameter(
                            "discount"
                        )
                    );

                String startDate =
                        request.getParameter(
                            "startDate"
                        );

                String endDate =
                        request.getParameter(
                            "endDate"
                        );

                String status =
                        request.getParameter("status");

                if (status == null ||
                    status.trim().isEmpty()) {

                    status = "Active";
                }

                String sql =
                    "INSERT INTO offers " +
                    "(offer_title, description, " +
                    "discount, start_date, end_date, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, offerTitle);
                ps.setString(2, description);
                ps.setDouble(3, discount);
                ps.setString(4, startDate);
                ps.setString(5, endDate);
                ps.setString(6, status);

                ps.executeUpdate();

                ps.close();

            } else if ("delete".equals(action)) {

                int offerId =
                    Integer.parseInt(
                        request.getParameter(
                            "offerId"
                        )
                    );

                String sql =
                    "DELETE FROM offers " +
                    "WHERE offer_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, offerId);

                ps.executeUpdate();

                ps.close();

            } else if ("updateStatus".equals(action)) {

                int offerId =
                    Integer.parseInt(
                        request.getParameter(
                            "offerId"
                        )
                    );

                String status =
                        request.getParameter("status");

                String sql =
                    "UPDATE offers " +
                    "SET status = ? " +
                    "WHERE offer_id = ?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, status);
                ps.setInt(2, offerId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect(
                "adminOffer"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin/offers.jsp" +
                "?error=Offer Operation Failed"
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