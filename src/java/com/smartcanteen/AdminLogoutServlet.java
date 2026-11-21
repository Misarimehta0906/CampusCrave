package com.smartcanteen;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("adminId");
            session.removeAttribute("adminName");
            session.removeAttribute("adminEmail");
            session.removeAttribute("adminRole");
            session.invalidate();
        }

        response.sendRedirect(
            request.getContextPath() + "/admin/adminLogin.jsp?logout=1"
        );
    }
}