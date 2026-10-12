package com.webease.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Unit I: JavaBean Domain Model for Support & Maintenance Requests
 */
public class MaintenanceTicket implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int siteId;
    private String businessName;
    private String title;
    private String description;
    private String category;  // "Menu/Price Update", "Image Swap", "Timing Change", "Feature Request", "Bug Fix"
    private String priority;  // "Low", "Normal", "Urgent"
    private String status;    // "Pending", "In Progress", "Resolved"
    private String createdAt;

    public MaintenanceTicket() {
        this.status = "Pending";
        this.priority = "Normal";
        this.createdAt = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
    }

    public MaintenanceTicket(int id, int siteId, String businessName, String title, 
                             String description, String category, String priority, 
                             String status, String createdAt) {
        this.id = id;
        this.siteId = siteId;
        this.businessName = businessName;
        this.title = title;
        this.description = description;
        this.category = category;
        this.priority = priority;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSiteId() { return siteId; }
    public void setSiteId(int siteId) { this.siteId = siteId; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getTitle() { return title; }
    public String getTicketTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
