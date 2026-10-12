package com.webease.dao;

import com.webease.model.WebsiteOrder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: Data Access Object for Inbound Customer Website Build Orders.
 * Uses PreparedStatements for all SQL queries to ensure robust SQL-injection prevention.
 */
public class OrderDAO {

    public boolean insertOrder(WebsiteOrder order) {
        String sql = "INSERT INTO website_orders (order_number, customer_name, business_name, category, " +
                "phone, email, city, plan_name, billing_cycle, estimated_build_price, estimated_retainer_price, " +
                "features, notes, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, order.getOrderNumber());
            ps.setString(2, order.getCustomerName());
            ps.setString(3, order.getBusinessName());
            ps.setString(4, order.getCategory());
            ps.setString(5, order.getPhone());
            ps.setString(6, order.getEmail());
            ps.setString(7, order.getCity());
            ps.setString(8, order.getPlanName());
            ps.setString(9, order.getBillingCycle());
            ps.setDouble(10, order.getEstimatedBuildPrice());
            ps.setDouble(11, order.getEstimatedRetainerPrice());
            ps.setString(12, order.getFeatures());
            ps.setString(13, order.getNotes());
            ps.setString(14, order.getStatus());
            ps.setString(15, order.getCreatedAt());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error inserting website order: " + e.getMessage());
        }
        return false;
    }

    public List<WebsiteOrder> getAllOrders() {
        List<WebsiteOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM website_orders ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving website orders: " + e.getMessage());
        }
        return list;
    }

    public WebsiteOrder getOrderByNumber(String orderNumber) {
        String sql = "SELECT * FROM website_orders WHERE UPPER(order_number) = UPPER(?) LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderNumber.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding order by number: " + e.getMessage());
        }
        return null;
    }

    public List<WebsiteOrder> getOrdersByPhone(String phone) {
        List<WebsiteOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM website_orders WHERE phone LIKE ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + phone.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding orders by phone: " + e.getMessage());
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE website_orders SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
        }
        return false;
    }

    public List<WebsiteOrder> getOrdersByEmail(String email) {
        List<WebsiteOrder> list = new ArrayList<>();
        if (email == null) return list;
        String sql = "SELECT * FROM website_orders WHERE LOWER(email) = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding orders by email: " + e.getMessage());
        }
        return list;
    }

    public boolean updateOrderStatusByNumber(String orderNumber, String status) {
        if (orderNumber == null) return false;
        String sql = "UPDATE website_orders SET status = ? WHERE UPPER(order_number) = UPPER(?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, orderNumber.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status by number: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteOrder(int id) {
        String sql = "DELETE FROM website_orders WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting order: " + e.getMessage());
        }
        return false;
    }

    private WebsiteOrder mapRow(ResultSet rs) throws SQLException {
        return new WebsiteOrder(
                rs.getInt("id"),
                rs.getString("order_number"),
                rs.getString("customer_name"),
                rs.getString("business_name"),
                rs.getString("category"),
                rs.getString("phone"),
                rs.getString("email"),
                rs.getString("city"),
                rs.getString("plan_name"),
                rs.getString("billing_cycle"),
                rs.getDouble("estimated_build_price"),
                rs.getDouble("estimated_retainer_price"),
                rs.getString("features"),
                rs.getString("notes"),
                rs.getString("status"),
                rs.getString("created_at")
        );
    }
}
