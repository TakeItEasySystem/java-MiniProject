package com.webease.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Unit I: JavaBean Domain Model for Inbound Leads & Website Audits
 */
public class AuditLead implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String businessName;
    private String websiteUrl;
    private String ownerEmail;
    private String ownerPhone;
    private String businessType;
    private int healthScore;     // 0 to 100
    private String issuesFound;
    private String createdAt;

    public AuditLead() {
        this.createdAt = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
    }

    public AuditLead(int id, String businessName, String websiteUrl, String ownerEmail, 
                     String ownerPhone, String businessType, int healthScore, 
                     String issuesFound, String createdAt) {
        this.id = id;
        this.businessName = businessName;
        this.websiteUrl = websiteUrl;
        this.ownerEmail = ownerEmail;
        this.ownerPhone = ownerPhone;
        this.businessType = businessType;
        this.healthScore = healthScore;
        this.issuesFound = issuesFound;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getWebsiteUrl() { return websiteUrl; }
    public void setWebsiteUrl(String websiteUrl) { this.websiteUrl = websiteUrl; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    public String getOwnerPhone() { return ownerPhone; }
    public void setOwnerPhone(String ownerPhone) { this.ownerPhone = ownerPhone; }

    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }

    public int getHealthScore() { return healthScore; }
    public void setHealthScore(int healthScore) { this.healthScore = healthScore; }

    public String getIssuesFound() { return issuesFound; }
    public void setIssuesFound(String issuesFound) { this.issuesFound = issuesFound; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
