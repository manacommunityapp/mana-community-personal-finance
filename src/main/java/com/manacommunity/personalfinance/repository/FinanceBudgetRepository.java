package com.manacommunity.personalfinance.repository;

import com.manacommunity.personalfinance.entity.FinanceBudget;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FinanceBudgetRepository extends JpaRepository<FinanceBudget, Long> {

    List<FinanceBudget> findByUserIdAndBudgetYearOrderByCategoryNameAsc(Long userId, int year);

    List<FinanceBudget> findByUserIdAndBudgetYearAndBudgetMonthOrderByCategoryNameAsc(Long userId, int year, Integer month);

    Optional<FinanceBudget> findByUserIdAndCategoryIdAndBudgetYearAndBudgetMonth(Long userId, Long categoryId, int year, Integer month);
}
