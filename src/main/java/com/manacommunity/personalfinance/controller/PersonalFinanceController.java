package com.manacommunity.personalfinance.controller;

import com.manacommunity.personalfinance.config.AuthenticatedUser;
import com.manacommunity.personalfinance.dto.*;
import com.manacommunity.personalfinance.service.PersonalFinanceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/finance")
@RequiredArgsConstructor
@Tag(name = "Personal Finance", description = "Personal finance management APIs")
public class PersonalFinanceController {

    private final PersonalFinanceService financeService;

    // ── Accounts ────────────────────────────────────────────────────

    @GetMapping("/accounts")
    @Operation(summary = "Get all accounts for the authenticated user")
    public ResponseEntity<List<AccountResponse>> getAccounts(@AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(financeService.getAccounts(principal.userId()));
    }

    @PostMapping("/accounts")
    @Operation(summary = "Create a new financial account")
    public ResponseEntity<AccountResponse> createAccount(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody AccountRequest request) {
        return ResponseEntity.ok(financeService.createAccount(principal.userId(), request));
    }

    @PutMapping("/accounts/{id}")
    @Operation(summary = "Update an existing account")
    public ResponseEntity<AccountResponse> updateAccount(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id,
            @Valid @RequestBody AccountRequest request) {
        return ResponseEntity.ok(financeService.updateAccount(principal.userId(), id, request));
    }

    @DeleteMapping("/accounts/{id}")
    @Operation(summary = "Soft-delete an account")
    public ResponseEntity<Void> deleteAccount(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteAccount(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Transactions ────────────────────────────────────────────────

    @GetMapping("/transactions")
    @Operation(summary = "Get paginated transactions, optionally filtered by account")
    public ResponseEntity<Page<TransactionResponse>> getTransactions(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @RequestParam(required = false) Long accountId,
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(financeService.getTransactions(principal.userId(), accountId, pageable));
    }

    @PostMapping("/transactions")
    @Operation(summary = "Create a new transaction")
    public ResponseEntity<TransactionResponse> createTransaction(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody TransactionRequest request) {
        return ResponseEntity.ok(financeService.createTransaction(principal.userId(), request));
    }

    @PutMapping("/transactions/{id}")
    @Operation(summary = "Update an existing transaction")
    public ResponseEntity<TransactionResponse> updateTransaction(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id,
            @Valid @RequestBody TransactionRequest request) {
        return ResponseEntity.ok(financeService.updateTransaction(principal.userId(), id, request));
    }

    @DeleteMapping("/transactions/{id}")
    @Operation(summary = "Delete a transaction")
    public ResponseEntity<Void> deleteTransaction(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteTransaction(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Categories ──────────────────────────────────────────────────

    @GetMapping("/categories")
    @Operation(summary = "Get all categories (system + user-created)")
    public ResponseEntity<List<CategoryResponse>> getCategories(
            @AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(financeService.getCategories(principal.userId()));
    }

    @PostMapping("/categories")
    @Operation(summary = "Create a custom category")
    public ResponseEntity<CategoryResponse> createCategory(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody CategoryRequest request) {
        return ResponseEntity.ok(financeService.createCategory(principal.userId(), request));
    }

    @PutMapping("/categories/{id}")
    @Operation(summary = "Update a custom category")
    public ResponseEntity<CategoryResponse> updateCategory(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id,
            @Valid @RequestBody CategoryRequest request) {
        return ResponseEntity.ok(financeService.updateCategory(principal.userId(), id, request));
    }

    @DeleteMapping("/categories/{id}")
    @Operation(summary = "Delete a custom category")
    public ResponseEntity<Void> deleteCategory(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteCategory(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Budgets ─────────────────────────────────────────────────────

    @GetMapping("/budgets")
    @Operation(summary = "Get budgets for a given year and optional month")
    public ResponseEntity<List<BudgetResponse>> getBudgets(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @RequestParam int year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(financeService.getBudgets(principal.userId(), year, month));
    }

    @PostMapping("/budgets")
    @Operation(summary = "Create a new budget")
    public ResponseEntity<BudgetResponse> createBudget(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody BudgetRequest request) {
        return ResponseEntity.ok(financeService.createBudget(principal.userId(), request));
    }

    @PutMapping("/budgets/{id}")
    @Operation(summary = "Update a budget")
    public ResponseEntity<BudgetResponse> updateBudget(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id,
            @Valid @RequestBody BudgetRequest request) {
        return ResponseEntity.ok(financeService.updateBudget(principal.userId(), id, request));
    }

    @DeleteMapping("/budgets/{id}")
    @Operation(summary = "Delete a budget")
    public ResponseEntity<Void> deleteBudget(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteBudget(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Bills ───────────────────────────────────────────────────────

    @GetMapping("/bills")
    @Operation(summary = "Get bills, optionally filtered by status")
    public ResponseEntity<List<BillResponse>> getBills(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @RequestParam(required = false) String status) {
        return ResponseEntity.ok(financeService.getBills(principal.userId(), status));
    }

    @PostMapping("/bills")
    @Operation(summary = "Create a new bill")
    public ResponseEntity<BillResponse> createBill(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody BillRequest request) {
        return ResponseEntity.ok(financeService.createBill(principal.userId(), request));
    }

    @PutMapping("/bills/{id}")
    @Operation(summary = "Update a bill")
    public ResponseEntity<BillResponse> updateBill(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id,
            @Valid @RequestBody BillRequest request) {
        return ResponseEntity.ok(financeService.updateBill(principal.userId(), id, request));
    }

    @PatchMapping("/bills/{id}/pay")
    @Operation(summary = "Mark a bill as paid")
    public ResponseEntity<BillResponse> markBillPaid(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        return ResponseEntity.ok(financeService.markBillPaid(principal.userId(), id));
    }

    @DeleteMapping("/bills/{id}")
    @Operation(summary = "Delete a bill")
    public ResponseEntity<Void> deleteBill(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteBill(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Recurring Transactions ──────────────────────────────────────

    @GetMapping("/recurring")
    @Operation(summary = "Get recurring transaction templates")
    public ResponseEntity<List<RecurringTxnResponse>> getRecurringTxns(
            @AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(financeService.getRecurringTxns(principal.userId()));
    }

    @PostMapping("/recurring")
    @Operation(summary = "Create a recurring transaction template")
    public ResponseEntity<RecurringTxnResponse> createRecurringTxn(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody RecurringTxnRequest request) {
        return ResponseEntity.ok(financeService.createRecurringTxn(principal.userId(), request));
    }

    @DeleteMapping("/recurring/{id}")
    @Operation(summary = "Deactivate a recurring transaction")
    public ResponseEntity<Void> deleteRecurringTxn(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable Long id) {
        financeService.deleteRecurringTxn(principal.userId(), id);
        return ResponseEntity.noContent().build();
    }

    // ── Dashboard Summary ───────────────────────────────────────────

    @GetMapping("/summary")
    @Operation(summary = "Get financial dashboard summary for current month")
    public ResponseEntity<FinanceSummaryResponse> getSummary(
            @AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(financeService.getSummary(principal.userId()));
    }
}
