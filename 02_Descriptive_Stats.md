Descriptive Stats
================
Tomoya Ozawa
2021/06/11

## Prepare

``` r
list_02_table_figure_data <- readRDS("./intermediate/list_02_table_figure_data.rds")
```

## Summary of replacement data: Table Ⅱa

  - Subsample of buses for which at least 1 replacement occurred

<!-- end list -->

``` r
list_02_table_figure_data$table_2_a
```

<div class="kable-table">

| Bus\_group  | Max\_Mileage | Min\_Mileage | Mean\_Mileage | SD\_Mileage | Max\_Elapsed\_Time | Min\_Elapsed\_Time | Mean\_Elapsed\_Time | SD\_Elapsed\_Time | Number\_of\_Observations |
| :---------- | -----------: | -----------: | ------------: | ----------: | -----------------: | -----------------: | ------------------: | ----------------: | -----------------------: |
| 1           |            0 |            0 |             0 |           0 |                  0 |                  0 |                 0.0 |               0.0 |                        0 |
| 2           |            0 |            0 |             0 |           0 |                  0 |                  0 |                 0.0 |               0.0 |                        0 |
| 3           |       273400 |       124800 |        199733 |       37459 |                 74 |                 38 |                59.0 |              11.0 |                       27 |
| 4           |       387300 |       121300 |        257336 |       65477 |                116 |                 28 |                73.7 |              23.6 |                       33 |
| 5           |       322500 |       118000 |        245291 |       60258 |                127 |                 31 |                85.6 |              30.2 |                       11 |
| 6           |       237200 |        82400 |        150786 |       61007 |                127 |                 49 |                74.8 |              35.7 |                        7 |
| 7           |       331800 |       121000 |        208963 |       48981 |                104 |                 41 |                68.3 |              17.1 |                       27 |
| 8           |       297500 |       132000 |        186700 |       43956 |                104 |                 36 |                58.2 |              22.5 |                       19 |
| Full Sample |       387300 |        82400 |        216354 |       60475 |                127 |                 28 |                68.1 |              22.7 |                      124 |

</div>

## Summary of replacement data: Table Ⅱb

  - Subsample of buses for which no replacement occurred

<!-- end list -->

``` r
list_02_table_figure_data$table_2_b
```

<div class="kable-table">

| Bus\_group  | Max\_Mileage | Min\_Mileage | Mean\_Mileage | SD\_Mileage | Max\_Elapsed\_Time | Min\_Elapsed\_Time | Mean\_Elapsed\_Time | SD\_Elapsed\_Time | Number\_of\_Observations |
| :---------- | -----------: | -----------: | ------------: | ----------: | -----------------: | -----------------: | ------------------: | ----------------: | -----------------------: |
| 1           |       120151 |        65643 |        100117 |       12929 |                 24 |                 24 |                24.0 |              0.00 |                       15 |
| 2           |       161748 |       142009 |        151182 |        8530 |                 48 |                 48 |                48.0 |              0.00 |                        4 |
| 3           |       280802 |       199626 |        250766 |       21325 |                 75 |                 75 |                75.0 |              0.00 |                       21 |
| 4           |       352450 |       310910 |        337222 |       17802 |                118 |                117 |               117.8 |              0.45 |                        5 |
| 5           |       326843 |       326843 |        326843 |           0 |                130 |                130 |               130.0 |              0.00 |                        1 |
| 6           |       299040 |       232395 |        265264 |       33332 |                130 |                128 |               129.3 |              1.15 |                        3 |
| 7           |            0 |            0 |             0 |           0 |                  0 |                  0 |                 0.0 |              0.00 |                        0 |
| 8           |            0 |            0 |             0 |           0 |                  0 |                  0 |                 0.0 |              0.00 |                        0 |
| Full Sample |       352450 |        65643 |        207782 |       85208 |                130 |                 24 |                66.0 |             35.06 |                       49 |

</div>
