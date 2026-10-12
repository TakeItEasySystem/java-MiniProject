package com.webease.listener;

import com.webease.dao.DBConnection;
import com.webease.service.MonitorService;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.SQLException;

/**
 * Unit III & V: ServletContextListener managing application lifecycle
 * - Automatically initializes SQLite schema on Tomcat deployment
 * - Spawns proactive daemon thread for 24/7 uptime monitoring
 * - Gracefully releases resources upon Tomcat server stop
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("==================================================");
        System.out.println(" WebEase Platform — Initializing Services");
        System.out.println(" Founders: Ayush Jha | Rishikant Mishra | Yadnesh Sawant");
        System.out.println("==================================================");

        try {
            DBConnection.getConnection();
            System.out.println("[WebEase Init] Database and schema initialized successfully at: " + DBConnection.getDatabasePath());
        } catch (SQLException e) {
            System.err.println("[WebEase Init] Database initialization failed: " + e.getMessage());
        }

        // Start background health monitor daemon thread
        MonitorService.getInstance().startBackgroundMonitoring();
        System.out.println("[WebEase Init] Proactive Health Monitor thread active.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[WebEase Shutdown] Stopping background monitoring thread...");
        MonitorService.getInstance().stopBackgroundMonitoring();

        System.out.println("[WebEase Shutdown] Stopping Jakarta Mail service thread pool...");
        com.webease.service.EmailService.getInstance().shutdown();

        System.out.println("[WebEase Shutdown] Stopping Brevo SMS service thread pool...");
        com.webease.service.BrevoService.getInstance().shutdown();

        System.out.println("[WebEase Shutdown] Closing database connections...");
        DBConnection.closeConnection();

        System.out.println("[WebEase Shutdown] WebEase Platform shut down cleanly.");
    }
}
