"use client";

import React, { useState } from "react";
import { useStudent } from "@/hooks/useStudent";
import { MetricCard } from "@/components/shared/MetricCard";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  CreditCard,
  CheckCircle2,
  AlertTriangle,
  Clock,
  Download,
  Receipt,
  DollarSign,
  ShieldCheck,
  Building2,
  X,
  ArrowUpRight,
  Sparkles,
} from "lucide-react";
import { FeeTransactionItem } from "@/lib/mockData";

export default function StudentFeeLedgerPage() {
  const {
    feeLedger,
    isLoadingFeeLedger,
    payFeeInvoice,
    isPayingFee,
  } = useStudent();

  const [activeTab, setActiveTab] = useState<"ALL" | "PAID" | "PENDING" | "OVERDUE">("ALL");
  const [selectedPayInvoice, setSelectedPayInvoice] = useState<FeeTransactionItem | null>(null);
  const [selectedReceipt, setSelectedReceipt] = useState<FeeTransactionItem | null>(null);
  const [paymentMethod, setPaymentMethod] = useState("UPI / Net Banking");
  const [paymentSuccess, setPaymentSuccess] = useState<string | null>(null);

  const transactions = feeLedger.transactions || [];
  const totalDues = feeLedger.total_dues || 0;
  const totalPaid = feeLedger.total_paid || 0;
  const totalOverdue = feeLedger.total_overdue || 0;

  const filteredTransactions = transactions.filter((t) => {
    if (activeTab === "PAID") return t.status === "PAID";
    if (activeTab === "PENDING") return t.status === "UNPAID";
    if (activeTab === "OVERDUE") return t.status === "OVERDUE";
    return true;
  });

  const handleOpenPay = (item: FeeTransactionItem) => {
    setSelectedPayInvoice(item);
    setPaymentSuccess(null);
  };

  const handleConfirmPay = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedPayInvoice) return;

    try {
      await payFeeInvoice({
        feeId: selectedPayInvoice.fee_id,
        paymentMethod,
      });
      setPaymentSuccess(`Payment of ₹${selectedPayInvoice.amount.toLocaleString()} processed successfully!`);
      setTimeout(() => {
        setSelectedPayInvoice(null);
        setPaymentSuccess(null);
      }, 1500);
    } catch (err: any) {
      console.error("Payment error:", err);
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "PAID":
        return (
          <Badge className="bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 font-semibold px-2.5 py-0.5">
            <CheckCircle2 className="w-3 h-3 mr-1" /> Paid
          </Badge>
        );
      case "OVERDUE":
        return (
          <Badge className="bg-rose-500/15 text-rose-400 border border-rose-500/30 font-semibold px-2.5 py-0.5">
            <AlertTriangle className="w-3 h-3 mr-1" /> Overdue
          </Badge>
        );
      default:
        return (
          <Badge className="bg-amber-500/15 text-amber-400 border border-amber-500/30 font-semibold px-2.5 py-0.5">
            <Clock className="w-3 h-3 mr-1" /> Pending
          </Badge>
        );
    }
  };

  const getCategoryBadge = (category: string) => {
    switch (category) {
      case "TUITION":
        return <Badge className="bg-blue-500/10 text-blue-400 border border-blue-500/20">Tuition Fee</Badge>;
      case "LABORATORY":
        return <Badge className="bg-purple-500/10 text-purple-400 border border-purple-500/20">Lab Access</Badge>;
      case "LIBRARY":
        return <Badge className="bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">Digital Library</Badge>;
      case "HOSTEL":
        return <Badge className="bg-amber-500/10 text-amber-400 border border-amber-500/20">Residential</Badge>;
      case "EXAMINATION":
        return <Badge className="bg-rose-500/10 text-rose-400 border border-rose-500/20">Exam Board</Badge>;
      default:
        return <Badge variant="outline">{category}</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-white">
              Student Fee Ledger & Billing
            </h1>
            <Badge variant="outline" className="text-emerald-400 border-emerald-500/30 bg-emerald-500/10">
              STD-09
            </Badge>
          </div>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            Itemized institutional invoices, tuition fee schedules, and official payment receipts
          </p>
        </div>

        {totalDues > 0 && (
          <Button
            onClick={() => {
              const pendingItem = transactions.find((t) => t.status !== "PAID");
              if (pendingItem) handleOpenPay(pendingItem);
            }}
            className="bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-semibold text-xs rounded-xl shadow-lg shadow-emerald-900/30 px-5 h-10 cursor-pointer"
          >
            <CreditCard className="h-4 w-4 mr-2" /> Settle Outstanding Dues (₹{totalDues.toLocaleString()})
          </Button>
        )}
      </div>

      {/* Summary KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          title="Total Outstanding Dues"
          value={`₹${totalDues.toLocaleString()}`}
          description={totalDues > 0 ? "Immediate clearance recommended" : "Zero pending balance"}
          icon={<AlertTriangle className={`h-5 w-5 ${totalDues > 0 ? "text-rose-500" : "text-slate-500"}`} />}
          spotlightColor={totalDues > 0 ? "rgba(244, 63, 94, 0.15)" : "rgba(59, 130, 246, 0.15)"}
        />
        <MetricCard
          title="Total Fees Paid"
          value={`₹${totalPaid.toLocaleString()}`}
          description="Verified academic fees cleared"
          icon={<CheckCircle2 className="h-5 w-5 text-emerald-500" />}
          spotlightColor="rgba(16, 185, 129, 0.15)"
        />
        <MetricCard
          title="Overdue Invoices"
          value={`₹${totalOverdue.toLocaleString()}`}
          description="Late fee grace period active"
          icon={<Clock className="h-5 w-5 text-amber-500" />}
          spotlightColor="rgba(245, 158, 11, 0.15)"
        />
        <MetricCard
          title="Account Standing"
          value={totalOverdue > 0 ? "Review Required" : "Good Standing"}
          description="Institutional bursar registration"
          icon={<ShieldCheck className="h-5 w-5 text-blue-500" />}
          spotlightColor="rgba(59, 130, 246, 0.15)"
        />
      </div>

      {/* Filter Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-800 pb-3">
        {(["ALL", "PAID", "PENDING", "OVERDUE"] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 rounded-xl text-xs font-semibold transition-all cursor-pointer ${
              activeTab === tab
                ? "bg-blue-600 text-white shadow-md shadow-blue-600/30"
                : "text-slate-400 hover:text-white hover:bg-slate-800/60"
            }`}
          >
            {tab === "ALL" && `All Transactions (${transactions.length})`}
            {tab === "PAID" && `Paid Invoices (${transactions.filter((t) => t.status === "PAID").length})`}
            {tab === "PENDING" && `Pending (${transactions.filter((t) => t.status === "UNPAID").length})`}
            {tab === "OVERDUE" && `Overdue Dues (${transactions.filter((t) => t.status === "OVERDUE").length})`}
          </button>
        ))}
      </div>

      {/* Invoices Table */}
      {isLoadingFeeLedger ? (
        <div className="rounded-2xl border border-slate-800 bg-slate-900/60 p-8 text-center text-slate-400 animate-pulse">
          Loading student financial ledger...
        </div>
      ) : filteredTransactions.length === 0 ? (
        <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center text-slate-400">
          <Receipt className="mx-auto h-10 w-10 text-slate-600 mb-3" />
          <h3 className="text-base font-semibold text-white">No transaction records</h3>
          <p className="text-xs text-slate-500 mt-1">
            No fee invoices match the current filter selection.
          </p>
        </div>
      ) : (
        <div className="rounded-2xl border border-slate-800 bg-slate-900/80 overflow-hidden shadow-xl backdrop-blur-sm">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-950/80 border-b border-slate-800 text-slate-400 uppercase font-semibold text-[10px]">
                <tr>
                  <th className="px-5 py-3">Description & Voucher</th>
                  <th className="px-4 py-3">Category</th>
                  <th className="px-4 py-3">Due Date</th>
                  <th className="px-4 py-3">Settlement Date</th>
                  <th className="px-4 py-3 text-right">Amount</th>
                  <th className="px-4 py-3 text-center">Status</th>
                  <th className="px-5 py-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/60 text-slate-200">
                {filteredTransactions.map((item) => (
                  <tr key={item.fee_id} className="hover:bg-slate-800/40 transition-colors">
                    <td className="px-5 py-4">
                      <div className="font-semibold text-white">{item.description}</div>
                      {item.receipt_number && (
                        <div className="text-[10px] text-slate-500 font-mono mt-0.5">
                          Ref: {item.receipt_number}
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-4">{getCategoryBadge(item.fee_type)}</td>
                    <td className="px-4 py-4 text-slate-400">{item.due_date}</td>
                    <td className="px-4 py-4 text-slate-400">
                      {item.payment_date ? item.payment_date.split("T")[0] : "—"}
                    </td>
                    <td className="px-4 py-4 text-right font-bold text-white text-sm">
                      ₹{item.amount.toLocaleString()}
                    </td>
                    <td className="px-4 py-4 text-center">{getStatusBadge(item.status)}</td>
                    <td className="px-5 py-4 text-right">
                      {item.status === "PAID" ? (
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => setSelectedReceipt(item)}
                          className="text-xs h-8 border-slate-700 bg-slate-950/80 text-slate-300 hover:text-white cursor-pointer"
                        >
                          <Receipt className="h-3 w-3 mr-1" /> Receipt
                        </Button>
                      ) : (
                        <Button
                          size="sm"
                          onClick={() => handleOpenPay(item)}
                          className="text-xs h-8 bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-lg shadow-sm cursor-pointer"
                        >
                          Pay Now →
                        </Button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Pay Modal Dialog */}
      {selectedPayInvoice && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-xs">
          <div className="w-full max-w-md rounded-3xl border border-slate-700/80 bg-slate-900 p-6 shadow-2xl text-white space-y-5 animate-in fade-in zoom-in-95">
            <div className="flex items-start justify-between border-b border-slate-800 pb-3">
              <div>
                <span className="text-[10px] font-bold text-emerald-400 uppercase tracking-wider">
                  Institutional Fee Gateway
                </span>
                <h3 className="text-base font-bold text-white mt-0.5">
                  Secure Fee Payment Settlement
                </h3>
              </div>
              <button
                onClick={() => setSelectedPayInvoice(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 cursor-pointer"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {paymentSuccess && (
              <div className="p-3 rounded-xl bg-emerald-500/20 border border-emerald-500/40 text-emerald-300 text-xs flex items-center gap-2">
                <CheckCircle2 className="h-4 w-4 shrink-0" />
                <span>{paymentSuccess}</span>
              </div>
            )}

            <div className="p-4 rounded-2xl bg-slate-950 border border-slate-800 space-y-2 text-xs">
              <div className="text-slate-400">{selectedPayInvoice.description}</div>
              <div className="text-2xl font-black text-white">
                ₹{selectedPayInvoice.amount.toLocaleString()}
              </div>
              <div className="text-[11px] text-slate-500">
                Payment Category: {selectedPayInvoice.fee_type} • Due: {selectedPayInvoice.due_date}
              </div>
            </div>

            <form onSubmit={handleConfirmPay} className="space-y-4">
              <div className="space-y-1.5 text-xs">
                <label className="font-semibold text-slate-300">Select Payment Instrument</label>
                <select
                  value={paymentMethod}
                  onChange={(e) => setPaymentMethod(e.target.value)}
                  className="w-full rounded-xl border border-slate-700 bg-slate-950 p-2.5 text-xs text-white focus:outline-none focus:ring-2 focus:ring-emerald-500"
                >
                  <option value="UPI / Instant NetBanking">UPI / Instant NetBanking (Zero Convenience Fee)</option>
                  <option value="Institutional Credit Card">Institutional Credit / Debit Card (Visa, RuPay, MC)</option>
                  <option value="Student Education Loan Account">Student Education Loan Account Drawdown</option>
                </select>
              </div>

              <div className="flex items-center justify-end gap-2 pt-2 border-t border-slate-800">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => setSelectedPayInvoice(null)}
                  className="text-xs text-slate-400 hover:text-white"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={isPayingFee}
                  className="text-xs bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-xl px-5 h-10 shadow-md shadow-emerald-900/40 cursor-pointer"
                >
                  {isPayingFee ? (
                    <span className="flex items-center gap-2">
                      <span className="h-3 w-3 animate-spin rounded-full border-2 border-white border-t-transparent" />
                      Authorizing Payment...
                    </span>
                  ) : (
                    `Pay ₹${selectedPayInvoice.amount.toLocaleString()} Now`
                  )}
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Official Receipt Voucher Modal */}
      {selectedReceipt && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-xs">
          <div className="w-full max-w-md rounded-3xl border border-slate-700/80 bg-slate-900 p-6 shadow-2xl text-white space-y-4 animate-in fade-in zoom-in-95">
            <div className="flex items-start justify-between border-b border-slate-800 pb-3">
              <div className="flex items-center gap-2">
                <Building2 className="h-5 w-5 text-emerald-400" />
                <div>
                  <h3 className="text-sm font-bold text-white">Apex Institute of Technology</h3>
                  <p className="text-[10px] text-slate-400">Institutional Bursar • Official Fee Voucher</p>
                </div>
              </div>
              <button
                onClick={() => setSelectedReceipt(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 cursor-pointer"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="bg-slate-950 p-4 rounded-2xl border border-slate-800 space-y-2.5 text-xs">
              <div className="flex justify-between">
                <span className="text-slate-500">Receipt Voucher</span>
                <span className="font-mono font-bold text-emerald-400">{selectedReceipt.receipt_number || "REC-2026-APEX-8901"}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">Student Roll Number</span>
                <span className="font-mono text-white">APEX-2024-101</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">Item Description</span>
                <span className="font-medium text-slate-200">{selectedReceipt.description}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">Payment Channel</span>
                <span className="text-slate-300">{selectedReceipt.payment_method || "UPI / Net Banking"}</span>
              </div>
              <div className="flex justify-between border-t border-slate-800 pt-2 font-bold text-sm">
                <span className="text-white">Amount Settled</span>
                <span className="text-emerald-400">₹{selectedReceipt.amount.toLocaleString()}</span>
              </div>
            </div>

            <div className="text-[10px] text-slate-500 text-center">
              This is an authenticated electronic tax invoice generated by the EduNexa Financial Engine.
            </div>

            <div className="flex justify-end gap-2 pt-1">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setSelectedReceipt(null)}
                className="text-xs border-slate-700 bg-slate-900 text-slate-300"
              >
                Close
              </Button>
              <Button
                size="sm"
                onClick={() => {
                  alert("Printing official invoice PDF voucher...");
                  setSelectedReceipt(null);
                }}
                className="text-xs bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-xl px-4 cursor-pointer"
              >
                <Download className="h-3.5 w-3.5 mr-1" /> Download PDF
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
