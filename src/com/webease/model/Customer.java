package com.webease.model;

import java.io.Serializable;

/**
 * Unit I & III: JavaBean POJO for Registered Business Customers
 * Represents verified business clients with anti-spam / anti-joke credentials.
 */
public class Customer implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String businessName;
    private String category;
    private String city;
    private String businessProof; // GSTIN, Udyam MSME, Google Business link, or Business UPI
    private String createdAt;

    public Customer() {}

    public Customer(int id, String name, String email, String phone, String password,
                    String businessName, String category, String city, String businessProof, String createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.businessName = businessName;
        this.category = category;
        this.city = city;
        this.businessProof = businessProof;
        this.createdAt = createdAt;
    }

    public boolean isProfileComplete() {
        return businessName != null && !businessName.trim().isEmpty() && !"Pending Business Setup".equalsIgnoreCase(businessName.trim())
                && name != null && !name.trim().isEmpty() && !name.startsWith("Partner ")
                && category != null && !category.trim().isEmpty() && !"Pending".equalsIgnoreCase(category.trim())
                && city != null && !city.trim().isEmpty() && !"Pending".equalsIgnoreCase(city.trim())
                && businessProof != null && !businessProof.trim().isEmpty() && !"Pending".equalsIgnoreCase(businessProof.trim());
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getBusinessProof() {
        return businessProof;
    }

    public void setBusinessProof(String businessProof) {
        this.businessProof = businessProof;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
