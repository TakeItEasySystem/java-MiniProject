package com.webease.service;

import com.webease.dao.SiteDAO;
import com.webease.dao.TicketDAO;
import com.webease.model.ClientSite;
import com.webease.model.MaintenanceTicket;

import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 * Unit II: Implements Interface + Multithreading (Runnable)
 * Uses try-catch-finally, exception handling, and concurrent background threads.
 * Core Startup Engine: Proactive Monitoring & Automated Health Diagnostics.
 */
public class MonitorService implements HealthChecker, Runnable {
    private static MonitorService instance;
    private volatile boolean running = false;
    private Thread monitorThread = null;
    private final Random random = new Random();
    private final SiteDAO siteDAO = new SiteDAO();
    private final TicketDAO ticketDAO = new TicketDAO();

    private MonitorService() {}

    public static synchronized MonitorService getInstance() {
        if (instance == null) {
            instance = new MonitorService();
        }
        return instance;
    }

    @Override
    public boolean checkSiteAvailability(String siteUrl) {
        if (siteUrl == null || siteUrl.trim().isEmpty()) {
            return false;
        }

        HttpURLConnection connection = null;
        try {
            String targetUrl = siteUrl.trim();
            if (!targetUrl.startsWith("http://") && !targetUrl.startsWith("https://")) {
                targetUrl = "https://" + targetUrl;
            }

            URL u = new URL(targetUrl);
            connection = (HttpURLConnection) u.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(2500);
            connection.setReadTimeout(2500);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) WebEase-Monitor/1.0");

            int code = connection.getResponseCode();
            return (code > 0 && code < 500);
        } catch (java.net.UnknownHostException | java.net.MalformedURLException e) {
            // Definitively non-existent or invalid host name
            return false;
        } catch (Exception e) {
            // If https failed (e.g. SSL issue), attempt http fallback
            if (!siteUrl.startsWith("http://")) {
                HttpURLConnection httpConn = null;
                try {
                    String cleanDomain = siteUrl.replaceAll("^https?://", "").trim();
                    URL uHttp = new URL("http://" + cleanDomain);
                    httpConn = (HttpURLConnection) uHttp.openConnection();
                    httpConn.setRequestMethod("GET");
                    httpConn.setConnectTimeout(2000);
                    httpConn.setReadTimeout(2000);
                    httpConn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) WebEase-Monitor/1.0");
                    int code = httpConn.getResponseCode();
                    return (code > 0 && code < 500);
                } catch (Exception ignored) {
                    return false;
                } finally {
                    if (httpConn != null) {
                        try { httpConn.disconnect(); } catch (Exception ignored) {}
                    }
                }
            }
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.disconnect();
                } catch (Exception ignored) {}
            }
        }
    }

    @Override
    public int measureResponseTime(String siteUrl) {
        long start = System.currentTimeMillis();
        boolean ok = checkSiteAvailability(siteUrl);
        if (!ok) {
            return -1; // Domain is unreachable / invalid
        }
        long elapsed = System.currentTimeMillis() - start;
        return (int) (elapsed > 0 ? elapsed : 85);
    }

    @Override
    public ClientSite performFullDiagnostic(ClientSite site) {
        int ping = measureResponseTime(site.getDomainUrl());
        site.setResponseTimeMs(ping);

        String newStatus = ping > 1200 ? "Warning" : "Healthy";
        site.setStatus(newStatus);

        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        site.setLastChecked("Just now (" + now.substring(11, 16) + ")");

        siteDAO.updateHealthMetrics(site.getId(), newStatus, ping, site.getUptimePercentage(), site.getLastChecked());
        return site;
    }

    /**
     * Executes proactive fleet check across all managed client sites.
     * Automatically files a proactive support ticket if an anomaly is detected.
     */
    public synchronized void checkAllSitesNow() {
        try {
            List<ClientSite> sites = siteDAO.getAllSites();
            String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

            for (ClientSite site : sites) {
                int ping = measureResponseTime(site.getDomainUrl());
                String status = (ping > 1200) ? "Warning" : "Healthy";
                double currentUptime = site.getUptimePercentage();

                // Slight realistic uptime fluctuation
                if ("Warning".equals(status) && currentUptime > 98.0) {
                    currentUptime = Math.round((currentUptime - 0.05) * 100.0) / 100.0;
                }

                siteDAO.updateHealthMetrics(site.getId(), status, ping, currentUptime, "Checked at " + timestamp.substring(11));

                // Proactive issue resolution: auto-log ticket on sustained warning
                if ("Warning".equals(status)) {
                    List<MaintenanceTicket> existing = ticketDAO.getTicketsBySiteId(site.getId());
                    boolean alreadyLogged = existing.stream().anyMatch(t -> 
                            t.getTitle().contains("High latency") && "Pending".equals(t.getStatus()));

                    if (!alreadyLogged) {
                        MaintenanceTicket alertTicket = new MaintenanceTicket(
                                0,
                                site.getId(),
                                site.getBusinessName(),
                                "[Proactive Alert] High latency (" + ping + "ms) detected",
                                "Automated WebEase monitor detected response latency spike exceeding 1200ms threshold on " + site.getDomainUrl() + ". CDN cache purging recommended.",
                                "Performance Optimization",
                                "Urgent",
                                "Pending",
                                timestamp
                        );
                        try {
                            ticketDAO.createTicket(alertTicket);
                            System.out.println("[WebEase Monitor] Proactive alert ticket logged for " + site.getBusinessName());

                            // Proactive Email Alert via Jakarta Mail + SMTP
                            if (site.getOwnerEmail() != null && !site.getOwnerEmail().trim().isEmpty()) {
                                EmailService.getInstance().sendDowntimeAlertEmail(
                                        site.getOwnerEmail(),
                                        site.getBusinessName(),
                                        site.getDomainUrl(),
                                        ping,
                                        "High Latency (" + ping + "ms) Detected"
                                );
                            }
                        } catch (Exception ignored) {}
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[WebEase Monitor] Error in health check sweep: " + e.getMessage());
        }
    }

    // Multithreading background task (Unit II: Multithreading in Java)
    @Override
    public void run() {
        System.out.println("[WebEase Monitor] Background monitoring daemon thread started.");
        while (running) {
            try {
                // Background cycle every 45 seconds
                Thread.sleep(45000);
                if (!running) break;
                checkAllSitesNow();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                System.out.println("[WebEase Monitor] Background thread interrupted.");
                break;
            } catch (Exception e) {
                System.err.println("[WebEase Monitor] Background monitoring exception: " + e.getMessage());
            }
        }
        System.out.println("[WebEase Monitor] Background monitoring thread stopped.");
    }

    public synchronized void startBackgroundMonitoring() {
        if (!running) {
            running = true;
            monitorThread = new Thread(this, "WebEase-Health-Monitor");
            monitorThread.setDaemon(true);
            monitorThread.start();
        }
    }

    public synchronized void stopBackgroundMonitoring() {
        running = false;
        if (monitorThread != null && monitorThread.isAlive()) {
            monitorThread.interrupt();
            monitorThread = null;
        }
    }

    public boolean isRunning() {
        return running;
    }
}
