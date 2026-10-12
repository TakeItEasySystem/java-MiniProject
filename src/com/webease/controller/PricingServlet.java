package com.webease.controller;

import com.webease.model.PricingQuote;
import com.webease.service.PricingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Unit I, II & IV: REST API Controller providing dynamic quotes based on OOP Polymorphism
 */
public class PricingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PricingService pricingService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.pricingService = PricingService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processQuote(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processQuote(req, resp);
    }

    private void processQuote(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String plan = req.getParameter("plan");
        String monthsParam = req.getParameter("months");
        String annualParam = req.getParameter("annual");
        String whatsappParam = req.getParameter("whatsapp");
        String razorpayParam = req.getParameter("razorpay");
        String seoParam = req.getParameter("seo");

        int months = 1;
        if (monthsParam != null && !monthsParam.trim().isEmpty()) {
            try {
                months = Integer.parseInt(monthsParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        boolean isAnnual = "true".equalsIgnoreCase(annualParam) || months >= 12;
        boolean addWhatsApp = "true".equalsIgnoreCase(whatsappParam);
        boolean addRazorpay = "true".equalsIgnoreCase(razorpayParam);
        boolean addSeo = "true".equalsIgnoreCase(seoParam);

        PricingQuote quote = pricingService.generateQuote(plan, months, isAnnual, addWhatsApp, addRazorpay, addSeo);

        PrintWriter out = resp.getWriter();
        out.print("{" +
                "\"planName\":\"" + escapeJson(quote.getPlanName()) + "\"," +
                "\"setupFee\":" + quote.getSetupFee() + "," +
                "\"monthlyRetainer\":" + quote.getMonthlyRetainer() + "," +
                "\"months\":" + quote.getMonths() + "," +
                "\"subtotal\":" + quote.getSubtotal() + "," +
                "\"discountAmount\":" + quote.getDiscountAmount() + "," +
                "\"addOnsCost\":" + quote.getAddOnsCost() + "," +
                "\"gstAmount\":" + quote.getGstAmount() + "," +
                "\"grandTotal\":" + quote.getGrandTotal() + "," +
                "\"billingCycle\":\"" + escapeJson(quote.getBillingCycle()) + "\"" +
                "}");
        out.flush();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
