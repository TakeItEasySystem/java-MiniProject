package com.webease.model;

import java.io.Serializable;

/**
 * JavaBean POJO representing an Inbound Website Build & Management Order.
 * Follows JavaBeans specifications: private fields, no-arg constructor, getters/setters.
 */
public class WebsiteOrder implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String orderNumber;
    private String customerName;
    private String businessName;
    private String category;
    private String phone;
    private String email;
    private String city;
    private String planName;
    private String billingCycle;
    private double estimatedBuildPrice;
    private double estimatedRetainerPrice;
    private String features;
    private String notes;
    private String status; // New, In Review, Designing, Development, Launched
    private String createdAt;

    public WebsiteOrder() {
    }

    public WebsiteOrder(int id, String orderNumber, String customerName, String businessName, String category,
                        String phone, String email, String city, String planName, String billingCycle,
                        double estimatedBuildPrice, double estimatedRetainerPrice, String features,
                        String notes, String status, String createdAt) {
        this.id = id;
        this.orderNumber = orderNumber;
        this.customerName = customerName;
        this.businessName = businessName;
        this.category = category;
        this.phone = phone;
        this.email = email;
        this.city = city;
        this.planName = planName;
        this.billingCycle = billingCycle;
        this.estimatedBuildPrice = estimatedBuildPrice;
        this.estimatedRetainerPrice = estimatedRetainerPrice;
        this.features = features;
        this.notes = notes;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    public String getBillingCycle() { return billingCycle; }
    public void setBillingCycle(String billingCycle) { this.billingCycle = billingCycle; }

    public double getEstimatedBuildPrice() { return estimatedBuildPrice; }
    public void setEstimatedBuildPrice(double estimatedBuildPrice) { this.estimatedBuildPrice = estimatedBuildPrice; }

    public double getEstimatedRetainerPrice() { return estimatedRetainerPrice; }
    public void setEstimatedRetainerPrice(double estimatedRetainerPrice) { this.estimatedRetainerPrice = estimatedRetainerPrice; }

    public String getFeatures() { return features; }
    public void setFeatures(String features) { this.features = features; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // Compatibility getters for JSP Expression Language
    public double getBuildPrice() { return estimatedBuildPrice; }
    public double getRetainerPrice() { return estimatedRetainerPrice; }
    public String getWhatsappNumber() { return phone; }
}
