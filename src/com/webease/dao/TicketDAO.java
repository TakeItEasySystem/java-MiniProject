package com.webease.dao;

import com.webease.exception.InvalidTicketException;
import com.webease.model.MaintenanceTicket;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Maintenance Tickets using PreparedStatement
 * Full CRUD operations, status updates, and filtering by client or status.
 */
public class TicketDAO {

    public List<MaintenanceTicket> getAllTickets() {
        List<MaintenanceTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM tickets ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToTicket(rs));
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getAllTickets error: " + e.getMessage());
        }
        return list;
    }

    public List<MaintenanceTicket> getTicketsByBusinessName(String businessName) {
        List<MaintenanceTicket> list = new ArrayList<>();
        if (businessName == null) return list;
        String sql = "SELECT * FROM tickets WHERE LOWER(business_name) = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, businessName.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getTicketsByBusinessName error: " + e.getMessage());
        }
        return list;
    }

    public List<MaintenanceTicket> getTicketsBySiteId(int siteId) {
        List<MaintenanceTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM tickets WHERE site_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, siteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getTicketsBySiteId error: " + e.getMessage());
        }
        return list;
    }

    public MaintenanceTicket getTicketById(int id) {
        String sql = "SELECT * FROM tickets WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTicket(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getTicketById error: " + e.getMessage());
        }
        return null;
    }

    public List<MaintenanceTicket> getTicketsByStatus(String status) {
        List<MaintenanceTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM tickets WHERE status = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getTicketsByStatus error: " + e.getMessage());
        }
        return list;
    }

    public boolean createTicket(MaintenanceTicket ticket) throws InvalidTicketException {
        if (ticket.getTitle() == null || ticket.getTitle().trim().isEmpty()) {
            throw new InvalidTicketException("Ticket title cannot be empty");
        }
        if (ticket.getCategory() == null || ticket.getCategory().trim().isEmpty()) {
            throw new InvalidTicketException("Ticket category must be specified");
        }

        String sql = "INSERT INTO tickets (site_id, business_name, title, description, category, priority, status, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, ticket.getSiteId());
            ps.setString(2, ticket.getBusinessName());
            ps.setString(3, ticket.getTitle().trim());
            ps.setString(4, ticket.getDescription() != null ? ticket.getDescription().trim() : "");
            ps.setString(5, ticket.getCategory());
            ps.setString(6, ticket.getPriority() != null ? ticket.getPriority() : "Normal");
            ps.setString(7, ticket.getStatus() != null ? ticket.getStatus() : "Pending");
            ps.setString(8, ticket.getCreatedAt());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        ticket.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.createTicket error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStatus(int ticketId, String newStatus) {
        String sql = "UPDATE tickets SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, ticketId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TicketDAO.updateStatus error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteTicket(int ticketId) {
        String sql = "DELETE FROM tickets WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ticketId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TicketDAO.deleteTicket error: " + e.getMessage());
            return false;
        }
    }

    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM tickets WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getCountByStatus error: " + e.getMessage());
        }
        return 0;
    }

    private MaintenanceTicket mapResultSetToTicket(ResultSet rs) throws SQLException {
        return new MaintenanceTicket(
                rs.getInt("id"),
                rs.getInt("site_id"),
                rs.getString("business_name"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getString("category"),
                rs.getString("priority"),
                rs.getString("status"),
                rs.getString("created_at")
        );
    }
}
