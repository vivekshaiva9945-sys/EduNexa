/**
 * EduNexa Official PDF Document Generator
 * Generates standards-compliant PDF-1.4 binary documents natively in the browser.
 * Zero external dependencies, instant client-side generation and downloading.
 */

interface AdmitCardData {
  studentName: string;
  rollNumber: string;
  courseCode: string;
  courseName: string;
  examDate: string;
  examTime: string;
  venue: string;
  durationMinutes?: number;
  totalMarks?: number;
  verificationHash?: string;
}

interface FeeReceiptData {
  receiptNumber: string;
  studentName: string;
  rollNumber: string;
  description: string;
  category: string;
  paymentMethod: string;
  paymentDate: string;
  amount: number;
  transactionRef?: string;
}

interface StudyMaterialData {
  courseCode: string;
  title: string;
  description: string;
  facultyName: string;
  uploadedAt: string;
  fileType?: string;
}

/**
 * Escapes characters for PDF literal strings in parentheses ( ... )
 */
function escapePdf(text: string): string {
  if (!text) return "";
  return text
    .replace(/\\/g, "\\\\")
    .replace(/\(/g, "\\(")
    .replace(/\)/g, "\\)")
    .replace(/[^\x20-\x7E]/g, " "); // Replace non-ascii chars with clean space
}

/**
 * Compiles PDF-1.4 binary structure from raw graphic/text streams
 */
function compilePdf(pageStreams: string[]): Uint8Array {
  const objects: string[] = [];

  // Object 1: Catalog
  // Object 2: Pages
  // Object 3..3+N: Page objects
  // Object: Font Normal
  // Object: Font Bold
  // Objects: Page contents

  const numPages = pageStreams.length;
  const fontNormalIndex = 3 + numPages;
  const fontBoldIndex = fontNormalIndex + 1;
  const contentStartIndex = fontBoldIndex + 1;

  // Catalog
  objects.push("<< /Type /Catalog /Pages 2 0 R >>");

  // Pages
  const pageRefs = Array.from({ length: numPages }, (_, i) => `${3 + i} 0 R`).join(" ");
  objects.push(`<< /Type /Pages /Kids [${pageRefs}] /Count ${numPages} >>`);

  // Page Objects
  for (let i = 0; i < numPages; i++) {
    const contentRef = `${contentStartIndex + i} 0 R`;
    objects.push(
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595.28 841.89] /Resources << /Font << /F1 ${fontNormalIndex} 0 R /F2 ${fontBoldIndex} 0 R >> >> /Contents ${contentRef} >>`
    );
  }

  // Fonts
  objects.push("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>");
  objects.push("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>");

  // Content Streams
  for (let i = 0; i < numPages; i++) {
    const rawContent = pageStreams[i];
    const enc = new TextEncoder();
    const bytes = enc.encode(rawContent);
    objects.push(`<< /Length ${bytes.length} >>\nstream\n${rawContent}\nendstream`);
  }

  // Construct binary file
  let header = "%PDF-1.4\n";
  let body = "";
  const xref: string[] = ["0000000000 65535 f \n"];
  let offset = header.length;

  for (let i = 0; i < objects.length; i++) {
    const objStr = `${i + 1} 0 obj\n${objects[i]}\nendobj\n`;
    xref.push(String(offset).padStart(10, "0") + " 00000 n \n");
    offset += objStr.length;
    body += objStr;
  }

  const xrefOffset = offset;
  const xrefStr = `xref\n0 ${objects.length + 1}\n` + xref.join("");
  const trailerStr = `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefOffset}\n%%EOF`;

  const fullText = header + body + xrefStr + trailerStr;
  return new TextEncoder().encode(fullText);
}

/**
 * Triggers client-side download for a given Blob
 */
export function triggerFileDownload(blob: Blob, fileName: string) {
  if (typeof window === "undefined") return;
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = fileName;
  document.body.appendChild(anchor);
  anchor.click();
  document.body.removeChild(anchor);
  setTimeout(() => URL.revokeObjectURL(url), 2000);
}

/**
 * 1. OFFICIAL ADMIT CARD / EXAMINATION HALL TICKET
 */
export function downloadAdmitCardPDF(data: AdmitCardData) {
  let stream = "";

  // Outer border
  stream += "0.15 0.25 0.45 RG 1.5 w 25 25 545 790 re S\n";
  stream += "0.75 0.8 0.9 RG 0.5 w 28 28 539 784 re S\n";

  // Header Banner (Navy blue)
  stream += "0.08 0.18 0.36 rg 30 740 535 70 re f\n";

  // Header Text
  stream += "BT 1 1 1 rg /F2 16 Tf 45 780 Td (APEX INSTITUTE OF TECHNOLOGY) Tj ET\n";
  stream += "BT 0.8 0.9 1 rg /F1 9 Tf 45 765 Td (DIRECTORATE OF EXAMINATIONS & ACADEMIC EVALUATION) Tj ET\n";
  stream += "BT 0.9 0.95 1 rg /F2 10 Tf 45 750 Td (OFFICIAL EXAMINATION HALL TICKET / ADMIT PASS) Tj ET\n";

  // Watermark bar
  stream += "0.93 0.95 0.98 rg 30 705 535 25 re f\n";
  stream += "BT 0.1 0.3 0.6 rg /F2 10 Tf 45 714 Td (SEMESTER EXAMINATION SESSION - AUTUMN 2026) Tj ET\n";
  stream += `BT 0.3 0.3 0.3 rg /F1 9 Tf 400 714 Td (Status: ISSUED & VERIFIED) Tj ET\n`;

  // Candidate Profile Box
  stream += "0.85 0.88 0.92 RG 1 w 35 520 525 175 re S\n";
  stream += "0.96 0.97 0.99 rg 35 670 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 11 Tf 45 678 Td (CANDIDATE & REGISTRATION CREDENTIALS) Tj ET\n";

  const rows = [
    ["Candidate Full Name:", data.studentName || "Vivek I H"],
    ["Student Roll Number:", data.rollNumber || "APEX-2024-V01"],
    ["Academic Department:", "Computer Science & Engineering (B.Tech)"],
    ["Academic Standing:", "Regular Semester Student - Good Standing"],
    ["Verification Pass Code:", data.verificationHash || "SEC-APX-98F12-PASS"],
  ];

  let y = 645;
  rows.forEach(([label, val]) => {
    stream += `BT 0.35 0.4 0.45 rg /F2 9.5 Tf 45 ${y} Td (${escapePdf(label)}) Tj ET\n`;
    stream += `BT 0.1 0.1 0.15 rg /F1 9.5 Tf 200 ${y} Td (${escapePdf(val)}) Tj ET\n`;
    // faint line
    stream += `0.92 0.93 0.95 RG 0.5 w 45 ${y - 4} 505 0.5 re S\n`;
    y -= 25;
  });

  // Examination Schedule Box
  stream += "0.85 0.88 0.92 RG 1 w 35 320 525 185 re S\n";
  stream += "0.96 0.97 0.99 rg 35 480 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 11 Tf 45 488 Td (SCHEDULED COURSE PAPER & VENUE ALLOCATION) Tj ET\n";

  const examRows = [
    ["Course Code & Title:", `${data.courseCode} - ${data.courseName}`],
    ["Examination Date:", data.examDate],
    ["Scheduled Time:", `${data.examTime} (Duration: ${data.durationMinutes || 180} Mins)`],
    ["Assigned Examination Hall:", data.venue || "Auditorium Hall B-201"],
    ["Designated Desk/Seat:", "Seat #42 (Row 4, Wing B)"],
    ["Max Assessment Marks:", `${data.totalMarks || 100} Marks (Theory / Practical)`],
  ];

  y = 455;
  examRows.forEach(([label, val]) => {
    stream += `BT 0.35 0.4 0.45 rg /F2 9.5 Tf 45 ${y} Td (${escapePdf(label)}) Tj ET\n`;
    stream += `BT 0.1 0.1 0.15 rg /F1 9.5 Tf 200 ${y} Td (${escapePdf(val)}) Tj ET\n`;
    stream += `0.92 0.93 0.95 RG 0.5 w 45 ${y - 4} 505 0.5 re S\n`;
    y -= 24;
  });

  // Barcode visual representation
  stream += "0.1 0.1 0.1 rg\n";
  for (let bx = 45; bx < 280; bx += Math.floor(Math.random() * 4) + 2) {
    const barW = (bx % 3 === 0) ? 2 : 1;
    stream += `${bx} 250 ${barW} 30 re f\n`;
  }
  stream += "BT 0.2 0.2 0.2 rg /F1 8 Tf 45 238 Td (*SEC-APX-2026-PASS-98F12-VERIFIED*) Tj ET\n";

  // Official Signature & Seal Block
  stream += "BT 0.2 0.3 0.5 rg /F2 9 Tf 360 260 Td (Controller of Examinations) Tj ET\n";
  stream += "BT 0.4 0.4 0.4 rg /F1 8 Tf 360 248 Td (Apex Institute of Technology) Tj ET\n";
  stream += "0.2 0.3 0.5 RG 1 w 360 272 150 0.5 re S\n";

  // Instructions
  stream += "0.98 0.98 0.98 rg 35 60 525 155 re f\n";
  stream += "0.85 0.85 0.85 RG 0.8 w 35 60 525 155 re S\n";
  stream += "BT 0.8 0.1 0.1 rg /F2 9.5 Tf 45 195 Td (MANDATORY EXAMINATION REGULATIONS & INSTRUCTIONS:) Tj ET\n";

  const instructions = [
    "1. Candidates must arrive at the allotted examination venue at least 20 minutes prior to session start.",
    "2. Present this official Hall Ticket along with your Institutional Smart ID card at the entrance desk.",
    "3. Strictly prohibited: Mobile phones, smartwatches, programmable calculators, and unauthorized sheets.",
    "4. Candidate identity will be verified against the digital institutional registry barcode above.",
    "5. Candidates leaving the hall before 60 minutes have elapsed will not be permitted to re-enter.",
  ];

  y = 175;
  instructions.forEach((ins) => {
    stream += `BT 0.25 0.25 0.25 rg /F1 8.5 Tf 45 ${y} Td (${escapePdf(ins)}) Tj ET\n`;
    y -= 18;
  });

  stream += "BT 0.5 0.5 0.5 rg /F1 7.5 Tf 45 40 Td (EduNexa Authenticated Examination Document - Generated electronically. No manual counter-signature required.) Tj ET\n";

  const pdfBytes = compilePdf([stream]);
  const blob = new Blob([pdfBytes as any], { type: "application/pdf" });
  const filename = `Official_Admit_Card_${data.courseCode || "EXAM"}_${data.rollNumber || "STUDENT"}.pdf`;
  triggerFileDownload(blob, filename);
}

/**
 * 2. OFFICIAL FEE RECEIPT / BURSAR TAX INVOICE
 */
export function downloadFeeReceiptPDF(data: FeeReceiptData) {
  let stream = "";

  // Outer border
  stream += "0.1 0.4 0.25 RG 1.5 w 25 25 545 790 re S\n";
  stream += "0.8 0.9 0.85 RG 0.5 w 28 28 539 784 re S\n";

  // Header Banner (Emerald / Deep Teal)
  stream += "0.06 0.35 0.24 rg 30 740 535 70 re f\n";

  // Header Text
  stream += "BT 1 1 1 rg /F2 16 Tf 45 780 Td (APEX INSTITUTE OF TECHNOLOGY) Tj ET\n";
  stream += "BT 0.85 0.95 0.9 rg /F1 9 Tf 45 765 Td (OFFICE OF THE INSTITUTIONAL BURSAR & FINANCIAL TREASURY) Tj ET\n";
  stream += "BT 0.95 1 0.95 rg /F2 10 Tf 45 750 Td (OFFICIAL PAYMENT RECEIPT & ELECTRONIC TAX INVOICE) Tj ET\n";

  // Voucher bar
  stream += "0.92 0.97 0.94 rg 30 705 535 25 re f\n";
  stream += `BT 0.05 0.4 0.25 rg /F2 10 Tf 45 714 Td (Voucher No: ${escapePdf(data.receiptNumber || "REC-2026-APEX-8901")}) Tj ET\n`;
  stream += `BT 0.2 0.3 0.25 rg /F1 9 Tf 380 714 Td (Date: ${escapePdf(data.paymentDate || new Date().toISOString().split("T")[0])}) Tj ET\n`;

  // Student Info Box
  stream += "0.85 0.9 0.88 RG 1 w 35 550 525 145 re S\n";
  stream += "0.95 0.98 0.96 rg 35 665 525 25 re f\n";
  stream += "BT 0.1 0.35 0.2 rg /F2 10.5 Tf 45 673 Td (STUDENT & PAYER BILLING PROFILE) Tj ET\n";

  const studentDetails = [
    ["Student Candidate Name:", data.studentName || "Vivek I H"],
    ["Student Roll Number:", data.rollNumber || "APEX-2024-V01"],
    ["Academic Department:", "Computer Science & Engineering"],
    ["Academic Session:", "Fall Semester 2026 / Academic Year 2026-27"],
  ];

  let y = 642;
  studentDetails.forEach(([label, val]) => {
    stream += `BT 0.3 0.4 0.35 rg /F2 9.5 Tf 45 ${y} Td (${escapePdf(label)}) Tj ET\n`;
    stream += `BT 0.1 0.15 0.1 rg /F1 9.5 Tf 200 ${y} Td (${escapePdf(val)}) Tj ET\n`;
    stream += `0.92 0.95 0.93 RG 0.5 w 45 ${y - 4} 505 0.5 re S\n`;
    y -= 25;
  });

  // Invoice Breakdown Box
  stream += "0.85 0.9 0.88 RG 1 w 35 340 525 200 re S\n";
  stream += "0.95 0.98 0.96 rg 35 510 525 25 re f\n";
  stream += "BT 0.1 0.35 0.2 rg /F2 10.5 Tf 45 518 Td (ITEMIZED CHARGE & SETTLEMENT BREAKDOWN) Tj ET\n";

  // Table header
  stream += "0.9 0.94 0.92 rg 45 480 505 20 re f\n";
  stream += "BT 0.1 0.25 0.15 rg /F2 9 Tf 55 486 Td (Item Description) Tj ET\n";
  stream += "BT 0.1 0.25 0.15 rg /F2 9 Tf 280 486 Td (Category) Tj ET\n";
  stream += "BT 0.1 0.25 0.15 rg /F2 9 Tf 440 486 Td (Amount Settled) Tj ET\n";

  // Item row
  stream += `BT 0.1 0.1 0.1 rg /F1 9.5 Tf 55 455 Td (${escapePdf(data.description)}) Tj ET\n`;
  stream += `BT 0.2 0.3 0.2 rg /F1 9 Tf 280 455 Td (${escapePdf(data.category)}) Tj ET\n`;
  stream += `BT 0.05 0.4 0.2 rg /F2 11 Tf 440 455 Td (INR ${data.amount.toLocaleString()}.00) Tj ET\n`;

  // Total bar
  stream += "0.92 0.97 0.94 rg 45 400 505 35 re f\n";
  stream += "0.7 0.85 0.75 RG 1 w 45 400 505 35 re S\n";
  stream += "BT 0.1 0.25 0.15 rg /F2 11 Tf 55 413 Td (NET TOTAL AMOUNT CLEARED:) Tj ET\n";
  stream += `BT 0.05 0.45 0.2 rg /F2 14 Tf 400 411 Td (INR ${data.amount.toLocaleString()}.00) Tj ET\n`;

  // Payment Channel Details
  y = 370;
  stream += `BT 0.3 0.4 0.35 rg /F2 9 Tf 45 ${y} Td (Payment Instrument:) Tj ET\n`;
  stream += `BT 0.1 0.1 0.1 rg /F1 9 Tf 170 ${y} Td (${escapePdf(data.paymentMethod || "UPI / Instant NetBanking")}) Tj ET\n`;

  stream += `BT 0.3 0.4 0.35 rg /F2 9 Tf 320 ${y} Td (Transaction Status:) Tj ET\n`;
  stream += `BT 0.05 0.45 0.2 rg /F2 9.5 Tf 430 ${y} Td (SETTLED - PAID) Tj ET\n`;

  // Stamp / Watermark
  stream += "0.92 0.98 0.94 rg 35 210 240 100 re f\n";
  stream += "0.7 0.85 0.75 RG 1 w 35 210 240 100 re S\n";
  stream += "BT 0.05 0.4 0.2 rg /F2 11 Tf 45 285 Td (AUTHENTICATED RECEIPT) Tj ET\n";
  stream += "BT 0.2 0.3 0.25 rg /F1 8 Tf 45 270 Td (EduNexa Institutional Finance Engine) Tj ET\n";
  stream += `BT 0.2 0.3 0.25 rg /F1 8 Tf 45 255 Td (Ref: ${escapePdf(data.transactionRef || "TXN-9481-9921-OKAXIS")}) Tj ET\n`;
  stream += "BT 0.05 0.45 0.2 rg /F2 8.5 Tf 45 235 Td (STATUS: ZERO BALANCE OUTSTANDING) Tj ET\n";

  // Signature Block
  stream += "BT 0.1 0.2 0.15 rg /F2 9 Tf 360 240 Td (Chief Financial Officer / Bursar) Tj ET\n";
  stream += "BT 0.4 0.4 0.4 rg /F1 8 Tf 360 228 Td (Apex Institute of Technology) Tj ET\n";
  stream += "0.2 0.4 0.3 RG 1 w 360 252 150 0.5 re S\n";

  // Terms and legal footer
  stream += "0.98 0.98 0.98 rg 35 60 525 125 re f\n";
  stream += "0.88 0.88 0.88 RG 0.8 w 35 60 525 125 re S\n";
  stream += "BT 0.2 0.2 0.2 rg /F2 9 Tf 45 165 Td (IMPORTANT PAYMENT POLICIES & NOTICES:) Tj ET\n";

  const receiptNotes = [
    "1. Fees once deposited are non-refundable except under institutional refund charter guidelines.",
    "2. This document serves as an authenticated tax invoice for education allowance or bursar audits.",
    "3. Keep this electronic voucher for campus clearance, laboratory admittance, and examination pass issuance.",
    "4. For institutional tax deductions and sponsor invoicing inquiries, email accounts@apex.edunexa.edu.",
  ];

  y = 145;
  receiptNotes.forEach((note) => {
    stream += `BT 0.3 0.3 0.3 rg /F1 8.5 Tf 45 ${y} Td (${escapePdf(note)}) Tj ET\n`;
    y -= 18;
  });

  stream += "BT 0.5 0.5 0.5 rg /F1 7.5 Tf 45 40 Td (Apex Institutional Bursar - Electronically verified document generated by EduNexa ERP.) Tj ET\n";

  const pdfBytes = compilePdf([stream]);
  const blob = new Blob([pdfBytes as any], { type: "application/pdf" });
  const filename = `Fee_Receipt_${data.receiptNumber || "REC-8901"}.pdf`;
  triggerFileDownload(blob, filename);
}

/**
 * 3. DIGITAL COURSE MATERIAL / STUDY RESOURCE PACKET
 */
export function downloadStudyMaterialPDF(data: StudyMaterialData) {
  let stream = "";

  // Outer border
  stream += "0.2 0.3 0.5 RG 1.5 w 25 25 545 790 re S\n";

  // Header Banner
  stream += "0.1 0.2 0.4 rg 30 740 535 70 re f\n";
  stream += "BT 1 1 1 rg /F2 16 Tf 45 780 Td (APEX INSTITUTE OF TECHNOLOGY) Tj ET\n";
  stream += "BT 0.85 0.9 1 rg /F1 9 Tf 45 765 Td (DEPARTMENT OF COMPUTER SCIENCE & INFORMATION SYSTEMS) Tj ET\n";
  stream += `BT 0.95 0.98 1 rg /F2 11 Tf 45 750 Td (${escapePdf(data.courseCode)}: COURSE STUDY RESOURCE & LECTURE DOSSIER) Tj ET\n`;

  // Document details bar
  stream += "0.93 0.95 0.98 rg 30 705 535 25 re f\n";
  stream += `BT 0.1 0.25 0.5 rg /F2 9.5 Tf 45 714 Td (Topic: ${escapePdf(data.title)}) Tj ET\n`;
  stream += `BT 0.3 0.3 0.3 rg /F1 8.5 Tf 380 714 Td (Author: ${escapePdf(data.facultyName || "Faculty Lead")}) Tj ET\n`;

  // Overview box
  stream += "0.85 0.88 0.92 RG 1 w 35 590 525 105 re S\n";
  stream += "0.96 0.97 0.99 rg 35 665 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 10.5 Tf 45 673 Td (COURSE OVERVIEW & CURRICULAR CONTEXT) Tj ET\n";

  stream += `BT 0.2 0.2 0.2 rg /F1 9 Tf 45 645 Td (Description: ${escapePdf(data.description)}) Tj ET\n`;
  stream += `BT 0.3 0.3 0.3 rg /F1 8.5 Tf 45 625 Td (Published Date: ${escapePdf(data.uploadedAt || new Date().toISOString().split("T")[0])} | Format: Standard Academic Curriculum Pack) Tj ET\n`;
  stream += `BT 0.1 0.3 0.5 rg /F2 8.5 Tf 45 605 Td (Targeted Competencies: Algorithmic Rigor, Problem Solving, Enterprise Architecture) Tj ET\n`;

  // Curriculum Modules Box
  stream += "0.85 0.88 0.92 RG 1 w 35 240 525 340 re S\n";
  stream += "0.96 0.97 0.99 rg 35 550 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 10.5 Tf 45 558 Td (CORE SYLLABUS LECTURE CHAPTERS & PRACTICAL CODE HIGHLIGHTS) Tj ET\n";

  const chapters = [
    ["Chapter 1: Foundational Theory & Mathematical Concepts", "Time complexity bounds, asymptotic notation (Big-O, Omega, Theta), recurrence relations and master theorem applications."],
    ["Chapter 2: Data Structures & Abstract Data Types (ADT)", "Memory layouts of linear containers, balanced trees (AVL, Red-Black), dynamic heaps, hash table collision resolution strategies."],
    ["Chapter 3: Algorithmic Paradigms & Dynamic Programming", "Divide-and-conquer principles, greedy heuristics, optimal substructure, memoization matrices, Bellman-Ford & Dijkstra algorithms."],
    ["Chapter 4: System Integration, Threading & Concurrency", "Multi-process memory isolation, locks, semaphores, race condition mitigation, and high-throughput transactional database indexing."],
    ["Chapter 5: Laboratory Code Patterns & Practical Applications", "Clean architecture, testing fixtures, memory profiling with Valgrind, and building resilient microservices."],
  ];

  let y = 525;
  chapters.forEach(([chapTitle, chapDesc]) => {
    stream += `BT 0.1 0.25 0.5 rg /F2 9.5 Tf 45 ${y} Td (${escapePdf(chapTitle)}) Tj ET\n`;
    stream += `BT 0.25 0.25 0.25 rg /F1 8.5 Tf 45 ${y - 14} Td (${escapePdf(chapDesc)}) Tj ET\n`;
    stream += `0.92 0.93 0.95 RG 0.5 w 45 ${y - 20} 505 0.5 re S\n`;
    y -= 55;
  });

  // Recommended Reading & Exercises
  stream += "0.98 0.98 0.98 rg 35 60 525 170 re f\n";
  stream += "0.85 0.85 0.85 RG 0.8 w 35 60 525 170 re S\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 9.5 Tf 45 210 Td (PREPARATION QUESTIONS & SUPPLEMENTARY TEXTBOOKS:) Tj ET\n";

  const studyGuides = [
    "Q1. Derive the average-case runtime complexity for QuickSort and contrast with Randomized Pivot selection.",
    "Q2. Explain the difference between B-Trees and B+ Trees in the context of relational database disk I/O optimization.",
    "Q3. Implement a lock-free concurrent queue using atomic compare-and-swap (CAS) primitives.",
    "Required Reading: 'Introduction to Algorithms' (Cormen, Leiserson, Rivest, Stein) - Chapters 4, 7, and 12.",
    "Laboratory Practical: Submit assignment repository link before the end-of-module deadline.",
  ];

  y = 190;
  studyGuides.forEach((g) => {
    stream += `BT 0.25 0.25 0.25 rg /F1 8.5 Tf 45 ${y} Td (${escapePdf(g)}) Tj ET\n`;
    y -= 22;
  });

  stream += "BT 0.5 0.5 0.5 rg /F1 7.5 Tf 45 40 Td (Official Apex Digital Library Academic Resource - Distributed via EduNexa Student Portal.) Tj ET\n";

  const pdfBytes = compilePdf([stream]);
  const blob = new Blob([pdfBytes as any], { type: "application/pdf" });
  const sanitizedTitle = (data.title || "Study_Packet").replace(/[^a-zA-Z0-9_-]/g, "_");
  const filename = `${data.courseCode || "COURSE"}_${sanitizedTitle}.pdf`;
  triggerFileDownload(blob, filename);
}

interface TranscriptData {
  studentName: string;
  rollNumber: string;
  avgScore: string;
  results: Array<{
    course_code: string;
    course_name: string;
    title: string;
    exam_date: string;
    marks_obtained?: number;
    total_marks: number;
    grade?: string;
    remarks?: string;
  }>;
}

/**
 * 4. OFFICIAL CERTIFIED ACADEMIC TRANSCRIPT
 */
export function downloadTranscriptPDF(data: TranscriptData) {
  let stream = "";

  // Outer double border
  stream += "0.15 0.25 0.45 RG 1.5 w 25 25 545 790 re S\n";
  stream += "0.75 0.8 0.9 RG 0.5 w 28 28 539 784 re S\n";

  // Header Banner
  stream += "0.08 0.18 0.36 rg 30 740 535 70 re f\n";
  stream += "BT 1 1 1 rg /F2 16 Tf 45 780 Td (APEX INSTITUTE OF TECHNOLOGY) Tj ET\n";
  stream += "BT 0.85 0.9 1 rg /F1 9 Tf 45 765 Td (OFFICE OF THE ACADEMIC REGISTRAR - ACCREDITATION BOARD) Tj ET\n";
  stream += "BT 0.95 0.98 1 rg /F2 10.5 Tf 45 750 Td (CERTIFIED SEMESTER GRADE TRANSCRIPT & PERFORMANCE RECORD) Tj ET\n";

  // Transcript Info Bar
  stream += "0.93 0.95 0.98 rg 30 705 535 25 re f\n";
  stream += `BT 0.1 0.2 0.4 rg /F2 9.5 Tf 45 714 Td (Candidate: ${escapePdf(data.studentName || "Vivek I H")} | Roll No: ${escapePdf(data.rollNumber || "APEX-2024-V01")}) Tj ET\n`;
  stream += `BT 0.05 0.4 0.2 rg /F2 9.5 Tf 410 714 Td (Cumulative Score: ${escapePdf(data.avgScore)}%) Tj ET\n`;

  // Student details table
  stream += "0.85 0.88 0.92 RG 1 w 35 600 525 95 re S\n";
  stream += "0.96 0.97 0.99 rg 35 670 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 10.5 Tf 45 678 Td (ACADEMIC REGISTRATION & DEGREE DETAILS) Tj ET\n";

  const rows = [
    ["Degree Program:", "Bachelor of Technology (Computer Science & Engineering)"],
    ["Department / School:", "School of Computing & Information Systems"],
    ["Academic Standing:", "Certified Pass - First Class with Distinction"],
  ];

  let y = 650;
  rows.forEach(([label, val]) => {
    stream += `BT 0.3 0.4 0.45 rg /F2 9 Tf 45 ${y} Td (${escapePdf(label)}) Tj ET\n`;
    stream += `BT 0.1 0.1 0.15 rg /F1 9 Tf 180 ${y} Td (${escapePdf(val)}) Tj ET\n`;
    y -= 20;
  });

  // Table of Course Results
  stream += "0.85 0.88 0.92 RG 1 w 35 250 525 340 re S\n";
  stream += "0.96 0.97 0.99 rg 35 565 525 25 re f\n";
  stream += "BT 0.1 0.2 0.4 rg /F2 10.5 Tf 45 573 Td (EVALUATED COURSE SCORES & ACCREDITED LETTER GRADES) Tj ET\n";

  // Table Columns Header
  stream += "0.9 0.93 0.96 rg 45 538 505 22 re f\n";
  stream += "BT 0.1 0.2 0.35 rg /F2 8.5 Tf 55 545 Td (Course Code) Tj ET\n";
  stream += "BT 0.1 0.2 0.35 rg /F2 8.5 Tf 135 545 Td (Course Title / Examination Paper) Tj ET\n";
  stream += "BT 0.1 0.2 0.35 rg /F2 8.5 Tf 350 545 Td (Score) Tj ET\n";
  stream += "BT 0.1 0.2 0.35 rg /F2 8.5 Tf 410 545 Td (Percentage) Tj ET\n";
  stream += "BT 0.1 0.2 0.35 rg /F2 8.5 Tf 485 545 Td (Grade) Tj ET\n";

  y = 512;
  const items = data.results && data.results.length > 0 ? data.results : [
    { course_code: "APEX-CS301", course_name: "Data Structures & Algorithms", title: "Semester End Theory", exam_date: "2026-11-01", marks_obtained: 94, total_marks: 100, grade: "A+" },
    { course_code: "APEX-CS302", course_name: "Operating Systems Architecture", title: "Theory & Kernel Lab", exam_date: "2026-11-05", marks_obtained: 91, total_marks: 100, grade: "A" },
    { course_code: "APEX-CS303", course_name: "Database Engineering & SQL", title: "Final Evaluation", exam_date: "2026-11-09", marks_obtained: 96, total_marks: 100, grade: "A+" },
    { course_code: "APEX-CS304", course_name: "Computer Networks & Security", title: "Practical Assessment", exam_date: "2026-11-14", marks_obtained: 89, total_marks: 100, grade: "A" },
  ];

  items.slice(0, 6).forEach((item, idx) => {
    const rowBg = idx % 2 === 0 ? "0.98 0.99 1" : "1 1 1";
    stream += `${rowBg} rg 45 ${y - 8} 505 24 re f\n`;

    const score = item.marks_obtained !== undefined ? item.marks_obtained : 92;
    const pct = ((score / item.total_marks) * 100).toFixed(1);

    stream += `BT 0.1 0.3 0.6 rg /F2 9 Tf 55 ${y} Td (${escapePdf(item.course_code)}) Tj ET\n`;
    stream += `BT 0.15 0.15 0.2 rg /F1 8.5 Tf 135 ${y} Td (${escapePdf(item.course_name.slice(0, 36))}) Tj ET\n`;
    stream += `BT 0.1 0.1 0.1 rg /F2 9 Tf 350 ${y} Td (${score} / ${item.total_marks}) Tj ET\n`;
    stream += `BT 0.05 0.4 0.2 rg /F2 9 Tf 415 ${y} Td (${pct}%) Tj ET\n`;
    stream += `BT 0.1 0.2 0.5 rg /F2 10 Tf 495 ${y} Td (${escapePdf(item.grade || "A")}) Tj ET\n`;

    stream += `0.9 0.92 0.95 RG 0.5 w 45 ${y - 8} 505 0.5 re S\n`;
    y -= 32;
  });

  // Official Seal & Signature Block
  stream += "0.93 0.97 0.95 rg 35 120 230 115 re f\n";
  stream += "0.8 0.9 0.85 RG 1 w 35 120 230 115 re S\n";
  stream += "BT 0.05 0.4 0.2 rg /F2 10.5 Tf 45 210 Td (INSTITUTIONAL REGISTRAR SEAL) Tj ET\n";
  stream += "BT 0.2 0.3 0.25 rg /F1 8 Tf 45 195 Td (Apex Institute of Technology) Tj ET\n";
  stream += "BT 0.2 0.3 0.25 rg /F1 8 Tf 45 180 Td (Accredited by National Academic Council) Tj ET\n";
  stream += "BT 0.05 0.4 0.2 rg /F2 8.5 Tf 45 160 Td (AUTHENTICITY: ELECTRONICALLY SIGNED) Tj ET\n";
  stream += "BT 0.4 0.4 0.4 rg /F1 7.5 Tf 45 135 Td (Ref: REG-2026-TRN-98401) Tj ET\n";

  stream += "BT 0.15 0.25 0.45 rg /F2 9.5 Tf 360 150 Td (Dean of Academic Affairs) Tj ET\n";
  stream += "BT 0.4 0.4 0.4 rg /F1 8.5 Tf 360 136 Td (Office of Academic Records) Tj ET\n";
  stream += "0.2 0.3 0.5 RG 1 w 360 165 150 0.5 re S\n";

  // Legal footer
  stream += "BT 0.5 0.5 0.5 rg /F1 7.5 Tf 45 40 Td (This transcript is an official digital record issued by Apex Institute of Technology through the EduNexa System.) Tj ET\n";

  const pdfBytes = compilePdf([stream]);
  const blob = new Blob([pdfBytes as any], { type: "application/pdf" });
  const filename = `Official_Academic_Transcript_${data.rollNumber || "STUDENT"}.pdf`;
  triggerFileDownload(blob, filename);
}

