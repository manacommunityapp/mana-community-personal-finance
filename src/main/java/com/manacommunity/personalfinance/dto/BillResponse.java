package com.manacommunity.personalfinance.dto;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Builder
public record BillResponse(
        Long id,
        String name,
        BigDecimal amount,
        LocalDate dueDate,
        Long categoryId,
        String categoryName,
        String status,
        boolean recurring,
        String recurrencePeriod,
        boolean autoPay,
        String notes,
        LocalDateTime createdAt
) {}
