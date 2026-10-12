package com.webease.test;

import com.webease.dao.DBConnection;
import com.webease.dao.LeadDAO;
import com.webease.dao.SiteDAO;
import com.webease.dao.TicketDAO;
import com.webease.model.AuditLead;
import com.webease.model.ClientSite;
import com.webease.model.MaintenanceTicket;
import com.webease.model.PricingQuote;
import com.webease.service.MonitorService;
import com.webease.service.PricingService;

import java.sql.Connection;
import java.util.List;

public class BackendTest {
    public static void main(String[] args) {
        System.out.println("======================================================");
        System.out.println("  WebEase Backend Test Suite");
        System.out.println("======================================================");

        try {
            // 1. Test DBConnection
            System.out.print("[1/6] Testing DBConnection and SQLite Schema... ");
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("PASSED (DB Path: " + DBConnection.getDatabasePath() + ")");
            } else {
                throw new RuntimeException("Database connection failed");
            }

            // 2. Test SiteDAO
            System.out.print("[2/6] Testing SiteDAO (CRUD & Metrics)... ");
            SiteDAO siteDAO = new SiteDAO();
            List<ClientSite> sites = siteDAO.getAllSites();
            if (sites.isEmpty()) {
                throw new RuntimeException("Sites list should not be empty after seeding");
            }
            ClientSite site1 = siteDAO.getSiteById(1);
            if (!"The Daily Bite Café".equals(site1.getBusinessName())) {
                throw new RuntimeException("Unexpected site 1 name: " + site1.getBusinessName());
            }
            // Add a test site
            ClientSite testSite = new ClientSite(0, "Test Bakery", "Restaurants & Cafés", "testbakery.in", "Healthy", 99.9, 210, 95, "owner@testbakery.in", "Now");
            boolean siteAdded = siteDAO.addSite(testSite);
            if (!siteAdded || testSite.getId() <= 0) {
                throw new RuntimeException("Failed to add test site");
            }
            siteDAO.deleteSite(testSite.getId());
            System.out.println("PASSED (" + sites.size() + " seed sites verified)");

            // 3. Test TicketDAO
            System.out.print("[3/6] Testing TicketDAO (CRUD & Status Filters)... ");
            TicketDAO ticketDAO = new TicketDAO();
            List<MaintenanceTicket> tickets = ticketDAO.getAllTickets();
            if (tickets.isEmpty()) {
                throw new RuntimeException("Tickets list should not be empty after seeding");
            }
            MaintenanceTicket newTicket = new MaintenanceTicket(0, 1, "The Daily Bite Café", "Test Ticket Title", "Test description", "Content Update", "Normal", "Pending", "2026-10-10 10:00");
            boolean ticketCreated = ticketDAO.createTicket(newTicket);
            if (!ticketCreated || newTicket.getId() <= 0) {
                throw new RuntimeException("Failed to create test ticket");
            }
            ticketDAO.updateStatus(newTicket.getId(), "In Progress");
            ticketDAO.deleteTicket(newTicket.getId());
            System.out.println("PASSED (" + tickets.size() + " seed tickets verified)");

            // 4. Test LeadDAO
            System.out.print("[4/6] Testing LeadDAO (Audit Submissions)... ");
            LeadDAO leadDAO = new LeadDAO();
            AuditLead lead = new AuditLead(0, "Sunrise Dental Clinic", "sunrisedental.com", "dr@sunrisedental.com", "9876543210", "Clinics & Healthcare", 78, "Missing SSL.", "2026-10-10 10:00");
            boolean leadInserted = leadDAO.insertLead(lead);
            if (!leadInserted || lead.getId() <= 0) {
                throw new RuntimeException("Failed to insert audit lead");
            }
            leadDAO.deleteLead(lead.getId());
            System.out.println("PASSED");

            // 5. Test PricingService & OOP Polymorphism
            System.out.print("[5/6] Testing PricingService (Polymorphic Plans)... ");
            PricingService pricing = PricingService.getInstance();
            PricingQuote starterQuote = pricing.generateQuote("starter", 1, false);
            PricingQuote growthAnnual = pricing.generateQuote("growth", 12, true, true, true, true);
            PricingQuote enterpriseQuote = pricing.generateQuote("enterprise", 6, false);

            if (starterQuote.getSetupFee() != 5000.0 || growthAnnual.getDiscountAmount() <= 0 || enterpriseQuote.getMonthlyRetainer() != 6000.0) {
                throw new RuntimeException("Pricing calculation error: starter=" + starterQuote.getSetupFee() + ", enterprise=" + enterpriseQuote.getMonthlyRetainer());
            }
            System.out.println("PASSED (Starter: Rs." + starterQuote.getGrandTotal() + ", Growth Annual: Rs." + growthAnnual.getGrandTotal() + ")");

            // 6. Test MonitorService & Health Diagnostic
            System.out.print("[6/6] Testing MonitorService (Proactive Diagnostic)... ");
            MonitorService monitor = MonitorService.getInstance();
            int latency = monitor.measureResponseTime("thedailybite.in");
            if (latency <= 0) {
                throw new RuntimeException("Invalid latency measurement");
            }
            monitor.checkAllSitesNow();
            System.out.println("PASSED (Measured Latency: " + latency + "ms)");

            System.out.println("======================================================");
            System.out.println("  ALL BACKEND TESTS PASSED SUCCESSFULLY! (100%)");
            System.out.println("======================================================");

            DBConnection.closeConnection();
        } catch (Exception e) {
            System.err.println("\nTEST FAILED: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
