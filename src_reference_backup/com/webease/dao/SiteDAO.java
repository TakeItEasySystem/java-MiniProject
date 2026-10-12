package com.webease.dao;

import com.webease.exception.SiteNotFoundException;
import com.webease.model.ClientSite;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Client Sites using PreparedStatement
 */
public class SiteDAO {

    public List<ClientSite> getAllSites() {
        List<ClientSite> list = new ArrayList<>();
        String sql = "SELECT * FROM sites ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClientSite site = new ClientSite(
                        rs.getInt("id"),
                        rs.getString("business_name"),
                        rs.getString("category"),
                        rs.getString("domain_url"),
                        rs.getString("status"),
                        rs.getDouble("uptime_percentage"),
                        rs.getInt("response_time_ms"),
                        rs.getInt("page_speed_score"),
                        rs.getString("owner_email"),
                        rs.getString("last_checked")
                );
                list.add(site);
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getAllSites error: " + e.getMessage());
        }
        return list;
    }

    public ClientSite getSiteById(int id) throws SiteNotFoundException {
        String sql = "SELECT * FROM sites WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ClientSite(
                            rs.getInt("id"),
                            rs.getString("business_name"),
                            rs.getString("category"),
                            rs.getString("domain_url"),
                            rs.getString("status"),
                            rs.getDouble("uptime_percentage"),
                            rs.getInt("response_time_ms"),
                            rs.getInt("page_speed_score"),
                            rs.getString("owner_email"),
                            rs.getString("last_checked")
                    );
                } else {
                    throw new SiteNotFoundException("No client website found with ID: " + id);
                }
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getSiteById error: " + e.getMessage());
            throw new SiteNotFoundException("Database error retrieving site " + id, e);
        }
    }

    public boolean updateHealthMetrics(int id, String status, int responseTime, double uptime, String lastChecked) {
        String sql = "UPDATE sites SET status = ?, response_time_ms = ?, uptime_percentage = ?, last_checked = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, responseTime);
            ps.setDouble(3, uptime);
            ps.setString(4, lastChecked);
            ps.setInt(5, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SiteDAO.updateHealthMetrics error: " + e.getMessage());
            return false;
        }
    }
}
