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

@WebServlet("/offers")
public class OfferServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> offers = new ArrayList<>();

        String sql =
            "SELECT offer_id, offer_title, description, discount, " +
            "start_date, end_date, status " +
            "FROM offers " +
            "WHERE status = 'Active' " +
            "AND start_date <= CURDATE() " +
            "AND end_date >= CURDATE() " +
            "ORDER BY offer_id DESC";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> offer = new HashMap<>();

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

            request.setAttribute("offers", offers);

            request.getRequestDispatcher("offers.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load offers.",
                e
            );
        }
    }
}