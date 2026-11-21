
package com.smartcanteen;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp"
            );
            return;
        }

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {

            request.setAttribute("foodCount",
                getCount(st, "SELECT COUNT(*) FROM food"));

            request.setAttribute("userCount",
                getCount(st, "SELECT COUNT(*) FROM users"));

            request.setAttribute("orderCount",
                getCount(st, "SELECT COUNT(*) FROM orders"));

            request.setAttribute("pendingCount",
                getCount(st,
                    "SELECT COUNT(*) FROM orders WHERE status='Pending'"));

            request.setAttribute("categoryCount",
                getCount(st, "SELECT COUNT(*) FROM categories"));

            request.setAttribute("feedbackCount",
                getCount(st, "SELECT COUNT(*) FROM feedback"));

            request.setAttribute("couponCount",
                getCount(st, "SELECT COUNT(*) FROM coupons"));

            request.getRequestDispatcher("/admin/dashboard.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            getServletContext().log("Admin dashboard error", e);

            throw new ServletException(
                "Unable to load admin dashboard.", e
            );
        }
    }

    private int getCount(Statement st, String sql) throws Exception {
        try (ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
