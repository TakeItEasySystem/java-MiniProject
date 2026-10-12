package com.webease.dao;

import com.webease.model.AuditLead;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Inbound Leads & Audit Submissions using PreparedStatement
 */
public class LeadDAO {

    public List<AuditLead> getAllLeads() {
        List<AuditLead> list = new ArrayList<>();
        String sql = "SELECT * FROM leads ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AuditLead lead = new AuditLead(
                        rs.getInt("id"),
                        rs.getString("business_name"),
                        rs.getString("website_url"),
                        rs.getString("owner_email"),
                        rs.getString("owner_phone"),
                        rs.getString("business_type"),
                        rs.getInt("health_score"),
                        rs.getString("issues_found"),
                        rs.getString("created_at")
                );
                list.add(lead);
            }
        } catch (SQLException e) {
            System.err.println("LeadDAO.getAllLeads error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertLead(AuditLead lead) {
        String sql = "INSERT INTO leads (business_name, website_url, owner_email, owner_phone, business_type, health_score, issues_found, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lead.getBusinessName());
            ps.setString(2, lead.getWebsiteUrl());
            ps.setString(3, lead.getOwnerEmail());
            ps.setString(4, lead.getOwnerPhone());
            ps.setString(5, lead.getBusinessType());
            ps.setInt(6, lead.getHealthScore());
            ps.setString(7, lead.getIssuesFound());
            ps.setString(8, lead.getCreatedAt());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeadDAO.insertLead error: " + e.getMessage());
            return false;
        }
    }
}
