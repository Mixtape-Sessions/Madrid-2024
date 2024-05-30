library(fixest)
library(tidyverse)
library(did2s)
library(didimputation)

#' # 2x2 Imputation
# %%
data(df_het)
df_het = df_het |> 
  as_tibble() |> 
  filter(g == 2010 | g == 0, year == 2009 | year == 2011) |>
  mutate(
    d_it = (g == 2010) & (year == 2011),
    post = year == 2011,
    y = dep_var
  )

# TWFE estimate
(twfe_est = feols(y ~ i(d_it) | unit + year, data = df_het, vcov = "hc1"))

resids = resid(feols(c(y, d_it) ~ 0 | unit + year, data = df_het))
ytilde = resids[, 1]
dtilde = resids[, 2]
d = as.logical(df_het$d_it)

ytilde[!d]
ytilde[d]

twfe_est = feols(
  y ~ 0 + i(d_it, ref = FALSE) +  i(post, ref = FALSE) + i(unit), 
  data = df_het, vcov = "hc1"
)


# E(Y_i1 - Y_i0 | D_i = 0)
df_het |> 
  mutate(.by = unit, d_y = y[year == 2011] - y[year == 2009]) |>
  filter(g == 0 & year == 2011) |>
  with(mean(d_y))
coef(twfe_est, keep = "post")

# Y_i0
df_het |>
  filter(g == 2010 & year == 2009) |>
  select(unit, y) |> 
  tail()
coef(twfe_est, keep = "unit")["unit::1483"]


