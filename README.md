# Advanced Sales Analytics
 
SQL-based analytics project on a star-schema sales mart. Six analytical questions plus two consolidated reporting views, all written in T-SQL against a `gold` schema (AdventureWorks-style data).
 
**Author:** Hermann N'zi Ngenda
**Date:** May 1, 2026
 
---
 
## What's in here
 
```
advanced-data-analytics/
├── Advanced_Sales_Analytics_Report.docx   # Full written report
├── README.md                              # This file
├── scripts/
│   ├── change-over-time-trends_analysis.sql
│   ├── cumulative_analysis.sql
│   ├── performance_analysis.sql
│   ├── part-to-whole-proportional_analysis.sql
│   ├── data-segmentation_analysis.sql        # product cost bands
│   ├── data-segmentation_analysis2.sql       # customer behavioral segments
│   ├── report_customers.sql                  # gold.report_customers
│   ├── report_products.sql                   # gold.report_products (CREATE VIEW)
│   └── *.png                                 # query screenshots
└── result/
    ├── change-over-time_trend_result.pdf
    ├── cumulative_analysis_result.pdf
    ├── performance_analysis_result.pdf
    ├── part-to-whole-proportional_result.pdf
    ├── data-segmentation_result1.pdf
    ├── data-segmentation_result2.pdf
    ├── report_customers.pdf
    └── report_products.pdf
```
 
## Source data
 
The scripts assume three pre-built objects in the gold layer of a SQL Server warehouse:
 
| Object | Grain | Notable columns |
|---|---|---|
| `gold.fact_sales` | one row per order line | `order_date`, `sales_amount`, `quantity`, `price`, `customer_key`, `product_key` |
| `gold.dim_customers` | one row per customer | `customer_key`, `first_name`, `last_name`, `birthdate` |
| `gold.dim_products` | one row per SKU | `product_key`, `product_name`, `category`, `subcategory`, `cost` |
 
The fact table covers December 2010 through January 2014 (38 months).
 
## The analyses
 
Each script answers a single question. Run them in any order — they don't depend on one another.
 
1. **Change over time** (`change-over-time-trends_analysis.sql`)
   Monthly revenue, customer count, and quantity sold. Reveals the 2013 growth break-out.
2. **Cumulative analysis** (`cumulative_analysis.sql`)
   Running total of revenue alongside a moving average price. Shows the volume-vs-price trade.
3. **Product performance** (`performance_analysis.sql`)
   Yearly product sales compared to the product's lifetime average and to its prior year — uses `AVG OVER` and `LAG`.
4. **Part-to-whole** (`part-to-whole-proportional_analysis.sql`)
   Category share of total revenue. Bikes carry 96.46%.
5. **Data segmentation** (`data-segmentation_analysis.sql`, `data-segmentation_analysis2.sql`)
   Two views: products by cost band, customers by spending and tenure (VIP / Regular / New).
6. **Customer report** (`report_customers.sql`)
   A reusable view that flattens per-customer KPIs — orders, sales, recency, AOV, monthly spend, age group, segment.
7. **Product report** (`report_products.sql`)
   The product-side equivalent. Persisted as `CREATE VIEW gold.report_products` with a guarded drop.
## Headline numbers
 
| Metric | Value |
|---|---|
| Lifetime revenue | $29,356,250 |
| Total customers | 18,484 |
| VIP customers | 1,582 (8.6%) |
| Bikes share of revenue | 96.46% |
| Peak month | December 2013 — $1,874,128 |
| SKUs in catalog | 295 |
 
## How to reproduce
 
1. Connect to a SQL Server database that exposes the `gold` schema described above.
2. Open any script in `scripts/`.
3. Run it against the gold schema.
4. Compare the output to the matching PDF in `result/`.
The two `report_*` scripts can be promoted to views — uncomment the `CREATE VIEW` line at the top of `report_customers.sql`. The product report already runs as a `CREATE VIEW`.
 
## Notes and caveats
 
- The January 2014 row in the trend output is a partial month, not a real demand collapse. Treat it as the dataset's right-hand cutoff.
- Customer segment rule: `lifespan > 12` and `total_spending > 5000` for VIP. Tweak the thresholds in `data-segmentation_analysis2.sql` to fit your own definition.
- The product report's `recency_in_months` is computed against `GETDATE()`, so the value will move every time the view is queried.
## Tooling
 
- **Engine:** Microsoft SQL Server (T-SQL)
- **Functions used:** `SUM OVER`, `AVG OVER`, `LAG`, `DATETRUNC`, `DATEDIFF`, `CASE`, CTEs.
- **Output:** Result sets exported to PDF for review; the written report (`Advanced_Sales_Analytics_Report.docx`) walks through every query and finding.
---
 
For the full narrative — methodology, query-by-query interpretation, dashboard layout and recommendations — see **Advanced_Sales_Analytics_Report.docx** in this folder.
