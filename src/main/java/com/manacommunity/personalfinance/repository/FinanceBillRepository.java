package com.manacommunity.personalfinance.repository;

import com.manacommunity.personalfinance.entity.FinanceBill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface FinanceBillRepository extends JpaRepository<FinanceBill, Long> {

    List<FinanceBill> findByUserIdOrderByDueDateAsc(Long userId);

    List<FinanceBill> findByUserIdAndStatusOrderByDueDateAsc(Long userId, FinanceBill.BillStatus status);

    List<FinanceBill> findByUserIdAndDueDateBetweenOrderByDueDateAsc(Long userId, LocalDate from, LocalDate to);

    int countByUserIdAndStatus(Long userId, FinanceBill.BillStatus status);

    @Query("SELECT COALESCE(SUM(b.amount), 0) FROM FinanceBill b WHERE b.userId = :userId AND b.status = 'PENDING'")
    BigDecimal sumPendingAmount(Long userId);
}
