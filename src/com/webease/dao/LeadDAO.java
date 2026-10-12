package com.webease.dao;

import com.webease.model.AuditLead;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
                list.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            System.err.println("LeadDAO.getAllLeads error: " + e.getMessage());
        }
        return list;
    }

    public AuditLead getLeadById(int id) {
        String sql = "SELECT * FROM leads WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLead(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("LeadDAO.getLeadById error: " + e.getMessage());
        }
        return null;
    }

    public boolean insertLead(AuditLead lead) {
        String sql = "INSERT INTO leads (business_name, website_url, owner_email, owner_phone, business_type, health_score, issues_found, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, lead.getBusinessName());
            ps.setString(2, lead.getWebsiteUrl());
            ps.setString(3, lead.getOwnerEmail());
            ps.setString(4, lead.getOwnerPhone());
            ps.setString(5, lead.getBusinessType());
            ps.setInt(6, lead.getHealthScore());
            ps.setString(7, lead.getIssuesFound());
            ps.setString(8, lead.getCreatedAt());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        lead.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("LeadDAO.insertLead error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteLead(int id) {
        String sql = "DELETE FROM leads WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("LeadDAO.deleteLead error: " + e.getMessage());
            return false;
        }
    }

    public int getLeadCount() {
        String sql = "SELECT COUNT(*) FROM leads";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("LeadDAO.getLeadCount error: " + e.getMessage());
        }
        return 0;
    }

    private AuditLead mapResultSetToLead(ResultSet rs) throws SQLException {
        return new AuditLead(
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
    }
}
