package com.webease.dao;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Unit III: Java Database Connectivity (JDBC)
 * - JDBC Driver loading (Class.forName)
 * - Connection management (DriverManager.getConnection)
 * - Executing SQL statements with Statement & PreparedStatement
 */
public class DBConnection {
    private static Connection connection = null;

    private static String getDatabasePath() {
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.isEmpty()) {
            File webappsDir = new File(catalinaBase, "webapps" + File.separator + "webease" + File.separator + "WEB-INF");
            if (!webappsDir.exists()) {
                webappsDir.mkdirs();
            }
            return new File(webappsDir, "webease.db").getAbsolutePath();
        }
        return "webease.db";
    }

    public static synchronized Connection getConnection() throws SQLException {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("org.sqlite.JDBC");
                String dbPath = getDatabasePath();
                String url = "jdbc:sqlite:" + dbPath;
                connection = DriverManager.getConnection(url);
                initDatabase();
            }
        } catch (ClassNotFoundException e) {
            System.err.println("SQLite JDBC Driver not found in classpath: " + e.getMessage());
            throw new SQLException("SQLite Driver not found", e);
        }
        return connection;
    }

    /**
     * Auto-initializes database schema and seeds initial startup demo data
     */
    private static void initDatabase() {
        try (Statement stmt = connection.createStatement()) {
            // 1. Sites Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS sites (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "business_name TEXT NOT NULL, " +
                    "category TEXT NOT NULL, " +
                    "domain_url TEXT NOT NULL, " +
                    "status TEXT NOT NULL, " +
                    "uptime_percentage REAL NOT NULL, " +
                    "response_time_ms INTEGER NOT NULL, " +
                    "page_speed_score INTEGER NOT NULL, " +
                    "owner_email TEXT, " +
                    "last_checked TEXT" +
                    ");");

            // 2. Tickets Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS tickets (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "site_id INTEGER, " +
                    "business_name TEXT NOT NULL, " +
                    "title TEXT NOT NULL, " +
                    "description TEXT, " +
                    "category TEXT NOT NULL, " +
                    "priority TEXT NOT NULL, " +
                    "status TEXT NOT NULL, " +
                    "created_at TEXT NOT NULL" +
                    ");");

            // 3. Leads Table (From Free Audit tool)
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS leads (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "business_name TEXT, " +
                    "website_url TEXT NOT NULL, " +
                    "owner_email TEXT NOT NULL, " +
                    "owner_phone TEXT, " +
                    "business_type TEXT, " +
                    "health_score INTEGER NOT NULL, " +
                    "issues_found TEXT, " +
                    "created_at TEXT NOT NULL" +
                    ");");

            // Seed initial data if sites table is empty
            var rs = stmt.executeQuery("SELECT COUNT(*) FROM sites;");
            if (rs.next() && rs.getInt(1) == 0) {
                stmt.executeUpdate("INSERT INTO sites (business_name, category, domain_url, status, uptime_percentage, response_time_ms, page_speed_score, owner_email, last_checked) VALUES " +
                        "('The Daily Bite Café', 'Restaurants & Cafés', 'thedailybite.in', 'Healthy', 99.98, 248, 92, 'contact@thedailybite.in', 'Just now'), " +
                        "('FitPulse Gym & Fitness', 'Gyms & Fitness', 'fitpulseclub.in', 'Healthy', 99.95, 310, 88, 'trainer@fitpulseclub.in', '5 mins ago'), " +
                        "('Glow & Grace Salon', 'Salons & Beauty', 'glowandgrace.com', 'Healthy', 99.99, 195, 95, 'info@glowandgrace.com', '10 mins ago'), " +
                        "('Apex Coaching Classes', 'Tutors & Coaching', 'apexclasses.edu', 'Warning', 98.40, 680, 74, 'admin@apexclasses.edu', '15 mins ago');");

                stmt.executeUpdate("INSERT INTO tickets (site_id, business_name, title, description, category, priority, status, created_at) VALUES " +
                        "(1, 'The Daily Bite Café', 'Update Weekend Breakfast Menu Prices', 'Please update the cappuccino price to Rs 140 and add avocado toast to the breakfast section.', 'Menu/Price Update', 'Normal', 'In Progress', 'Today, 10:15 AM'), " +
                        "(1, 'The Daily Bite Café', 'Add Diwali Festive Offer Banner', 'Display 20% discount on orders above Rs 1000 with code DIWALI20.', 'Content Update', 'Urgent', 'Resolved', 'Yesterday, 04:30 PM'), " +
                        "(2, 'FitPulse Gym & Fitness', 'Fix Contact Us Form Mobile Alignment', 'The submit button on the mobile screen was wrapping awkwardly.', 'Bug Fix', 'Normal', 'Resolved', '2 days ago');");
            }
        } catch (SQLException e) {
            System.err.println("Error initializing database schema: " + e.getMessage());
        }
    }
}
