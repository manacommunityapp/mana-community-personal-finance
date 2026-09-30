package com.manacommunity.personalfinance.repository;

import com.manacommunity.personalfinance.entity.FinanceCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FinanceCategoryRepository extends JpaRepository<FinanceCategory, Long> {

    @Query("SELECT c FROM FinanceCategory c WHERE (c.userId = :userId OR c.system = true) ORDER BY c.sortOrder ASC, c.name ASC")
    List<FinanceCategory> findByUserIdOrSystem(Long userId);

    @Query("SELECT c FROM FinanceCategory c WHERE (c.userId = :userId OR c.system = true) AND c.categoryType = :type ORDER BY c.sortOrder ASC, c.name ASC")
    List<FinanceCategory> findByUserIdOrSystemAndType(Long userId, FinanceCategory.CategoryType type);

    List<FinanceCategory> findByUserIdOrderBySortOrderAscNameAsc(Long userId);
}
