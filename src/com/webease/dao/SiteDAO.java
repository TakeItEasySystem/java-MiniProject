package com.webease.dao;

import com.webease.exception.SiteNotFoundException;
import com.webease.model.ClientSite;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Client Sites using PreparedStatement
 * Full CRUD operations, search filters, and fleet metrics calculations.
 */
public class SiteDAO {

    public List<ClientSite> getAllSites() {
        List<ClientSite> list = new ArrayList<>();
        String sql = "SELECT * FROM sites ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSite(rs));
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getAllSites error: " + e.getMessage());
        }
        return list;
    }

    public List<ClientSite> getSitesByOwnerEmail(String email) {
        List<ClientSite> list = new ArrayList<>();
        if (email == null) return list;
        String sql = "SELECT * FROM sites WHERE LOWER(owner_email) = ? ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSite(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getSitesByOwnerEmail error: " + e.getMessage());
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
                    return mapResultSetToSite(rs);
                } else {
                    throw new SiteNotFoundException("No client website found with ID: " + id);
                }
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getSiteById error: " + e.getMessage());
            throw new SiteNotFoundException("Database error retrieving site " + id, e);
        }
    }

    public boolean addSite(ClientSite site) {
        String sql = "INSERT INTO sites (business_name, category, domain_url, status, uptime_percentage, response_time_ms, page_speed_score, owner_email, last_checked) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, site.getBusinessName());
            ps.setString(2, site.getCategory());
            ps.setString(3, site.getDomainUrl());
            ps.setString(4, site.getStatus() != null ? site.getStatus() : "Healthy");
            ps.setDouble(5, site.getUptimePercentage() > 0 ? site.getUptimePercentage() : 99.9);
            ps.setInt(6, site.getResponseTimeMs() > 0 ? site.getResponseTimeMs() : 250);
            ps.setInt(7, site.getPageSpeedScore() > 0 ? site.getPageSpeedScore() : 90);
            ps.setString(8, site.getOwnerEmail());
            ps.setString(9, site.getLastChecked() != null ? site.getLastChecked() : "Just now");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        site.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.addSite error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateSite(ClientSite site) {
        String sql = "UPDATE sites SET business_name = ?, category = ?, domain_url = ?, owner_email = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, site.getBusinessName());
            ps.setString(2, site.getCategory());
            ps.setString(3, site.getDomainUrl());
            ps.setString(4, site.getOwnerEmail());
            ps.setInt(5, site.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SiteDAO.updateSite error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteSite(int id) {
        String sqlDeleteTickets = "DELETE FROM tickets WHERE site_id = ?";
        String sqlDeleteSite = "DELETE FROM sites WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psTickets = conn.prepareStatement(sqlDeleteTickets);
                 PreparedStatement psSite = conn.prepareStatement(sqlDeleteSite)) {

                psTickets.setInt(1, id);
                psTickets.executeUpdate();

                psSite.setInt(1, id);
                int rows = psSite.executeUpdate();

                conn.commit();
                return rows > 0;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.deleteSite error: " + e.getMessage());
            return false;
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

    public List<ClientSite> searchSites(String query) {
        List<ClientSite> list = new ArrayList<>();
        String sql = "SELECT * FROM sites WHERE business_name LIKE ? OR category LIKE ? OR domain_url LIKE ? ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + query.trim() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSite(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.searchSites error: " + e.getMessage());
        }
        return list;
    }

    public double getAverageFleetUptime() {
        String sql = "SELECT AVG(uptime_percentage) FROM sites";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble(1);
                return Math.round(avg * 100.0) / 100.0;
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getAverageFleetUptime error: " + e.getMessage());
        }
        return 99.95;
    }

    public int getAverageFleetLatency() {
        String sql = "SELECT AVG(response_time_ms) FROM sites";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return (int) Math.round(rs.getDouble(1));
            }
        } catch (SQLException e) {
            System.err.println("SiteDAO.getAverageFleetLatency error: " + e.getMessage());
        }
        return 260;
    }

    private ClientSite mapResultSetToSite(ResultSet rs) throws SQLException {
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
    }
}
