package com.webease.dao;

import com.webease.exception.InvalidTicketException;
import com.webease.model.MaintenanceTicket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Maintenance Tickets using PreparedStatement
 */
public class TicketDAO {

    public List<MaintenanceTicket> getAllTickets() {
        List<MaintenanceTicket> list = new ArrayList<>();
        String sql = "SELECT * FROM tickets ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MaintenanceTicket t = new MaintenanceTicket(
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
                list.add(t);
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getAllTickets error: " + e.getMessage());
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
                    MaintenanceTicket t = new MaintenanceTicket(
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
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            System.err.println("TicketDAO.getTicketsBySiteId error: " + e.getMessage());
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
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ticket.getSiteId());
            ps.setString(2, ticket.getBusinessName());
            ps.setString(3, ticket.getTitle().trim());
            ps.setString(4, ticket.getDescription() != null ? ticket.getDescription().trim() : "");
            ps.setString(5, ticket.getCategory());
            ps.setString(6, ticket.getPriority());
            ps.setString(7, ticket.getStatus());
            ps.setString(8, ticket.getCreatedAt());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TicketDAO.createTicket error: " + e.getMessage());
            return false;
        }
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
}
