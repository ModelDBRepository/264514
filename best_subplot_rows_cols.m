function [plotRows,plotCols]=best_subplot_rows_cols(n);
n=ceil(n);
[plotRows,plotCols]=highest_integer_factors(n);
while plotRows<0.5*plotCols
  n=n+1;
  [plotRows,plotCols]=highest_integer_factors(n);
end