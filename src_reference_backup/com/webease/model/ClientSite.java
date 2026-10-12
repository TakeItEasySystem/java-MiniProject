package com.webease.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Unit I: JavaBean Domain Model (Encapsulation, Constructor, Getters/Setters)
 */
public class ClientSite implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String businessName;
    private String category;
    private String domainUrl;
    private String status;           // Healthy, Warning, Down
    private double uptimePercentage; // e.g. 99.98
    private int responseTimeMs;       // e.g. 248 ms
    private int pageSpeedScore;       // e.g. 92
    private String ownerEmail;
    private String lastChecked;

    public ClientSite() {
        this.status = "Healthy";
        this.uptimePercentage = 99.9;
        this.responseTimeMs = 250;
        this.pageSpeedScore = 90;
        this.lastChecked = new Date().toString();
    }

    public ClientSite(int id, String businessName, String category, String domainUrl, 
                      String status, double uptimePercentage, int responseTimeMs, 
                      int pageSpeedScore, String ownerEmail, String lastChecked) {
        this.id = id;
        this.businessName = businessName;
        this.category = category;
        this.domainUrl = domainUrl;
        this.status = status;
        this.uptimePercentage = uptimePercentage;
        this.responseTimeMs = responseTimeMs;
        this.pageSpeedScore = pageSpeedScore;
        this.ownerEmail = ownerEmail;
        this.lastChecked = lastChecked;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDomainUrl() { return domainUrl; }
    public void setDomainUrl(String domainUrl) { this.domainUrl = domainUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getUptimePercentage() { return uptimePercentage; }
    public void setUptimePercentage(double uptimePercentage) { this.uptimePercentage = uptimePercentage; }

    public int getResponseTimeMs() { return responseTimeMs; }
    public void setResponseTimeMs(int responseTimeMs) { this.responseTimeMs = responseTimeMs; }

    public int getPageSpeedScore() { return pageSpeedScore; }
    public void setPageSpeedScore(int pageSpeedScore) { this.pageSpeedScore = pageSpeedScore; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    public String getLastChecked() { return lastChecked; }
    public void setLastChecked(String lastChecked) { this.lastChecked = lastChecked; }
}
