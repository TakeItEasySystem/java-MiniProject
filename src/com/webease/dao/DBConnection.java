package com.webease.dao;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Unit III: Java Database Connectivity (JDBC)
 * - JDBC Driver loading (Class.forName)
 * - Connection management (DriverManager.getConnection)
 * - WAL journal mode & busy timeout for robust concurrent multi-threading
 * - Thread-safe connection provisioning (fresh connection per DAO try-with-resources)
 * - Automatic schema initialization and demo data seeding
 */
public class DBConnection {
    private static volatile boolean schemaInitialized = false;

    /**
     * Resolves the most appropriate path for the SQLite database file.
     * Works seamlessly in Tomcat webapps deployment, embedded mode, or standalone IDE execution.
     */
    public static String getDatabasePath() {
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.trim().isEmpty()) {
            // Check possible Tomcat webapps folders
            String[] possibleAppNames = {"ROOT", "webease", "webease-platform"};
            for (String appName : possibleAppNames) {
                File dir = new File(catalinaBase, "webapps" + File.separator + appName + File.separator + "WEB-INF");
                if (dir.exists()) {
                    return new File(dir, "webease.db").getAbsolutePath();
                }
            }
            // Fallback to primary webapps/ROOT/WEB-INF or webapps/webease/WEB-INF directory
            File defaultDir = new File(catalinaBase, "webapps" + File.separator + "ROOT" + File.separator + "WEB-INF");
            if (!defaultDir.exists()) {
                defaultDir.mkdirs();
            }
            return new File(defaultDir, "webease.db").getAbsolutePath();
        }

        // Running locally in workspace or standalone
        File localWebInf = new File("WebContent" + File.separator + "WEB-INF");
        if (localWebInf.exists()) {
            return new File(localWebInf, "webease.db").getAbsolutePath();
        }

        return new File("webease.db").getAbsolutePath();
    }

    /**
     * Obtains a thread-safe SQLite Connection.
     * Each caller (DAO) manages its own connection lifecycle via try-with-resources.
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.sqlite.JDBC");
            String dbPath = getDatabasePath();
            File dbFile = new File(dbPath);
            File parentDir = dbFile.getParentFile();
            if (parentDir != null && !parentDir.exists()) {
                parentDir.mkdirs();
            }

            String url = "jdbc:sqlite:" + dbPath;
            Connection conn = DriverManager.getConnection(url);

            // Enable SQLite WAL mode and 10-second busy timeout for concurrent threads
            try (Statement pragmaStmt = conn.createStatement()) {
                pragmaStmt.execute("PRAGMA journal_mode = WAL;");
                pragmaStmt.execute("PRAGMA busy_timeout = 10000;");
                pragmaStmt.execute("PRAGMA synchronous = NORMAL;");
            }

            if (!schemaInitialized) {
                synchronized (DBConnection.class) {
                    if (!schemaInitialized) {
                        initDatabase(conn);
                        schemaInitialized = true;
                    }
                }
            }

            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("SQLite JDBC Driver not found in classpath: " + e.getMessage());
            throw new SQLException("SQLite Driver not found", e);
        }
    }

    /**
     * Auto-initializes database schema and seeds initial startup demo data.
     */
    private static void initDatabase(Connection conn) {
        if (conn == null) return;

        try (Statement stmt = conn.createStatement()) {
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

            // 4. Website Orders / Project Requests Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS website_orders (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "order_number TEXT UNIQUE NOT NULL, " +
                    "customer_name TEXT NOT NULL, " +
                    "business_name TEXT NOT NULL, " +
                    "category TEXT NOT NULL, " +
                    "phone TEXT NOT NULL, " +
                    "email TEXT NOT NULL, " +
                    "city TEXT, " +
                    "plan_name TEXT NOT NULL, " +
                    "billing_cycle TEXT NOT NULL, " +
                    "estimated_build_price REAL NOT NULL, " +
                    "estimated_retainer_price REAL NOT NULL, " +
                    "features TEXT, " +
                    "notes TEXT, " +
                    "status TEXT NOT NULL, " +
                    "created_at TEXT NOT NULL" +
                    ");");

            // 5. Verified Business Customers Table (Anti-Joke Account Verification)
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS customers (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "name TEXT NOT NULL, " +
                    "email TEXT UNIQUE NOT NULL, " +
                    "phone TEXT NOT NULL, " +
                    "password TEXT NOT NULL, " +
                    "business_name TEXT NOT NULL, " +
                    "category TEXT NOT NULL, " +
                    "city TEXT NOT NULL, " +
                    "business_proof TEXT, " +
                    "created_at TEXT NOT NULL" +
                    ");");

            // Seed initial sample data if sites table is empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM sites;")) {
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
            }

        } catch (SQLException e) {
            System.err.println("Error initializing database schema: " + e.getMessage());
        }
    }

    /**
     * Gracefully closes the database connection on server shutdown.
     */
    public static void closeConnection() {
        // Individual connections are auto-closed by try-with-resources in DAOs.
    }
}
