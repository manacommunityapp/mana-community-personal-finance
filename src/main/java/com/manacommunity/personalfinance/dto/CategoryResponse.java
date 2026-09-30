package com.manacommunity.personalfinance.dto;

import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record CategoryResponse(
        Long id,
        String name,
        String categoryType,
        String icon,
        String color,
        boolean system,
        int sortOrder,
        LocalDateTime createdAt
) {}
