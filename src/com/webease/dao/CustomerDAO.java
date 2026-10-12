package com.webease.dao;

import com.webease.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit III: JDBC DAO for Verified Customers with PreparedStatements
 * Prevents SQL injection and manages client account authentication.
 */
public class CustomerDAO {

    public boolean registerCustomer(Customer customer) {
        String sql = "INSERT INTO customers (name, email, phone, password, business_name, category, city, business_proof, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail().toLowerCase().trim());
            ps.setString(3, customer.getPhone().trim());
            ps.setString(4, customer.getPassword());
            ps.setString(5, customer.getBusinessName());
            ps.setString(6, customer.getCategory());
            ps.setString(7, customer.getCity());
            ps.setString(8, customer.getBusinessProof());
            ps.setString(9, customer.getCreatedAt());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        customer.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.registerCustomer error: " + e.getMessage());
        }
        return false;
    }

    public Customer authenticate(String emailOrPhone, String password) {
        if (emailOrPhone == null || password == null) return null;

        String input = emailOrPhone.trim().toLowerCase();
        String digits = input.replaceAll("[^0-9]", "");
        String phone10 = digits.length() >= 10 ? digits.substring(digits.length() - 10) : digits;

        String sql = "SELECT * FROM customers WHERE (LOWER(email) = ? OR phone = ? OR phone = ?) AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, input);
            ps.setString(2, digits);
            ps.setString(3, phone10);
            ps.setString(4, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.authenticate error: " + e.getMessage());
        }
        return null;
    }

    public Customer getCustomerByEmail(String email) {
        if (email == null) return null;

        String sql = "SELECT * FROM customers WHERE LOWER(email) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.getCustomerByEmail error: " + e.getMessage());
        }
        return null;
    }

    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM customers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.getCustomerById error: " + e.getMessage());
        }
        return null;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.getAllCustomers error: " + e.getMessage());
        }
        return list;
    }

    public boolean updateProfile(Customer customer) {
        String sql = "UPDATE customers SET name = ?, business_name = ?, category = ?, city = ?, business_proof = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getBusinessName());
            ps.setString(3, customer.getCategory());
            ps.setString(4, customer.getCity());
            ps.setString(5, customer.getBusinessProof());
            ps.setInt(6, customer.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CustomerDAO.updateProfile error: " + e.getMessage());
        }
        return false;
    }

    public Customer getCustomerByPhone(String phone) {
        if (phone == null) return null;
        String digits = phone.replaceAll("[^0-9]", "");
        String phone10 = digits.length() >= 10 ? digits.substring(digits.length() - 10) : digits;
        String sql = "SELECT * FROM customers WHERE phone = ? OR phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, digits);
            ps.setString(2, phone10);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("CustomerDAO.getCustomerByPhone error: " + e.getMessage());
        }
        return null;
    }

    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CustomerDAO.deleteCustomer error: " + e.getMessage());
        }
        return false;
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        return new Customer(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("password"),
                rs.getString("business_name"),
                rs.getString("category"),
                rs.getString("city"),
                rs.getString("business_proof"),
                rs.getString("created_at")
        );
    }
}
