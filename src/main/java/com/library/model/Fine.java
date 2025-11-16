package com.library.model;

import java.math.BigDecimal;
import java.util.Date;

public class Fine {
    private int fineId;
    private int issuanceId;
    private BigDecimal fineAmount;
    private String status; // 'PENDING', 'PAID'
    private Date createdAt;
    private Date paidAt;

    // Default constructor
    public Fine() {
    }

    // Parameterized constructor
    public Fine(int fineId, int issuanceId, BigDecimal fineAmount, String status) {
        this.fineId = fineId;
        this.issuanceId = issuanceId;
        this.fineAmount = fineAmount;
        this.status = status;
    }

    // Getters and Setters
    public int getFineId() {
        return fineId;
    }

    public void setFineId(int fineId) {
        this.fineId = fineId;
    }

    public int getIssuanceId() {
        return issuanceId;
    }

    public void setIssuanceId(int issuanceId) {
        this.issuanceId = issuanceId;
    }

    public BigDecimal getFineAmount() {
        return fineAmount;
    }

    public void setFineAmount(BigDecimal fineAmount) {
        this.fineAmount = fineAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Date paidAt) {
        this.paidAt = paidAt;
    }

    @Override
    public String toString() {
        return "Fine{" +
                "fineId=" + fineId +
                ", issuanceId=" + issuanceId +
                ", fineAmount=" + fineAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", paidAt=" + paidAt +
                '}';
    }
}
