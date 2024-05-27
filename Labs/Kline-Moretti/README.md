

# Tennessee Valley Authority Empirical Application

## Intro

This exercise is going to work with data from Kline and Moretti (2014).
This paper aims to analyze the impacts of the “Tennessee Valley
Authority” (TVA) on local agriculture and manufacturing employment. The
TVA was a huge federal spending program in the 1940s that aimed at
electrification of the region, building hundreds of large dams (in
Scott’s terms, a ton of ‘bite’).

The region was centered in Tennessee and surrounding other southern
states. The region had a large agriculture industry, but very little
manufacturing. Electrification brought in a lot industry, moving the
economy away from agriculture. We are going to test for this in the data
using census data (recorded every 10 years).

![Tennessee Valley Authority Dam](img/tva_map.jpeg)

![Tennessee Valley Authority Map](img/tva_dam.jpeg)

``` r
library(tidyverse)
library(fixest)
library(DRDID)
library(did)

options(readr.show_progress = FALSE, readr.show_col_types = FALSE)
setFixest_etable(markdown = FALSE)
```

First, we will load our dataset:

``` r
df <- read_csv("data/tva.csv")
head(df)
```

    # A tibble: 6 × 18
      county_code  year   tva treat  post ln_agriculture ln_manufacturing
      <chr>       <dbl> <dbl> <dbl> <dbl>          <dbl>            <dbl>
    1 01001        1920     0     0     0           8.49             6.41
    2 01001        1930     0     0     0           8.64             6.36
    3 01001        1940     0     0     0           8.39             6.66
    4 01001        1950     0     0     1           7.78             7.14
    5 01001        1960     0     0     1           7.12             7.26
    6 01003        1920     0     0     0           8.35             7.10
    # ℹ 11 more variables: agriculture_share_1920 <dbl>,
    #   agriculture_share_1930 <dbl>, manufacturing_share_1920 <dbl>,
    #   manufacturing_share_1930 <dbl>, ln_avg_farm_value_1920 <dbl>,
    #   ln_avg_farm_value_1930 <dbl>, white_share_1920 <dbl>,
    #   white_share_1930 <dbl>, white_share_1920_sq <dbl>,
    #   white_share_1930_sq <dbl>, county_has_no_missing <lgl>

## Question 1

We will perform the basic 2x2 DID using just the years 1940 and 1960. We
will use as outcomes `ln_agriculture` and `ln_manufacturing`.

First, for `ln_agriculture`, we will manually calculate the means and
form the difference-in-differences.

Second, run the “classic” version using an indicator for treatment,
`tva`, and indicator for being the post-period, `post`, and the product
of the two. I recommend the package `fixest` for regression analysis.
I’ll be using it in the solutions.

Second, we will see in the 2x2 DID case, using county and time fixed
effects is equivalent:

## Question 2

Moretti and Kline were nervous that the parallel trends assumption is a
bit of a strong assumption in the context. Why might that be in the
context of the Tennessee Valley Authority?

Answer: The TVA was built in the Tenneessee area precisely because the
area was not developing a strong manufacturing base. It is unlikely in
the absence of treatment that counties in the TVA area were going to
grow in manufacturing the same as outside counties

Let’s run a placebo analysis to test for this using 1920 as the
pre-treatment period and 1930 as the post-treatment period. What does
this tell us about the plausability of a parallel trends type
assumption?

## Question 3

Let’s put this analysis together and run an event-study regression using
the full dataset

To do this, create a set of dummy variables that interact year with
treatment status. Estimate the TWFE model with these dummy variables.

## Question 4

We see some evidence of pre-trends for `ln_manufacturing` which makes us
concerned about the plausability of parallel counterfactual trends in
the post-period. Let’s show this visually by extending a linear
regression through the pre-period estimates.

This exercise, assumes that changes in outcomes in the pre-period will
extend linearly into the future. However, this is a strong assumption;
instead we will use Jon Roth and Ashesh Rambachan’s work. First, we will
calculate the “the largest violations of parallel trends in the
pre-treatment period”. We measure a violation of parallel trends as the
change in pre-trend estimates $\hat{\delta}_t - \hat{\delta}_{t-1}$. In
our case, we only have two pre-period estimates so it’s the max.

Lets use the `HonestDiD` package to assess robustness to violations of
parallel trends. The function
`HonestDiD::createSensitivityResults_relativeMagnitudes` will calculate
the largest violation of parallel trends and then intuitively gauge “if
we have violations of similar magnitude, could our results go away”. We
can control the “magnitude” of violations by a value of $\bar{M}$ with a
value of 1 being equal to the largest violation and 0 being no bias. The
code is kind of complicated, so I include it here:

## Question 5

Let’s use some controls to weaken the assumption to conditional parallel
trends. In particular, we are going to use a few covariates:
`agriculture_share_1920`, `agriculture_share_1930`,
`manufacturing_share_1920`, and `manufacturing_share_1930`.

What happens if we add those controls in linearly to our original
estimate?

*Answer:* The covariates are dropped because they are collinear with the
county fixed effects.

The term $X_i \beta$ just causes a level shift in outcomes. This is not
what we want. We really want to allow for the *trends* in outcomes to
vary by covariate values. The simplest way to do this is to change our
model to interact covariates with indicators for each year
$X_i * 1(t = s) \beta$ for each year $s$. This is often written more
simply as $X_i \beta_t$ which lets $beta$ vary by year.

If you take first-differences, you end up with $$
 X_i \beta_t - X_i \beta_{t-1} = X_i (\beta_t - \beta_{t-1}),
$$ which says changes in outcome over time depend on your value of
$X_i$.

## Question 6

This question shows different weighs to incorporate covariates in a 2x2
difference-in-differences estimator. The goal is to relax our parallel
trends assumption to be conditional on X: $$
  E(Y_{i1}(0) - Y_{i1}(0) | D = 1, X = x) = E(Y_{i1}(0) - Y_{i1}(0) | D = 0, X = x).
$$

In words, this assumption says “take treated and control units with the
same value of $X$. These units on average have the same counterfactual
trend”. Full details to help with this question are given below in the
appendix notes. This question will walk you through three different
covariates-based estimators of ATTs: outcome regression, inverse
propensity of treatment weighting, and a doubly-robust combination of
the two.

Note: Some of the data contains missing values for the covariates.
Subset the data using `county_has_no_missing == TRUE` (for later).

``` r
# Drop counties with missing covariates
df <- filter(df, county_has_no_missing == TRUE)

# First-differenced data
first_diff = df |>
  arrange(county_code, year) |>
  filter(year == 1940 | year == 1960) |>
  mutate(
    D_ln_manufacturing = ln_manufacturing - lag(ln_manufacturing, 1),
    D_ln_agriculture = ln_agriculture - lag(ln_agriculture, 1),
    .by = "county_code"
  ) |> 
  filter(year == 1960)
```

### Part 1: Difference-in-Differences

Take first-differences of the outcome variable to form $\Delta Y$.
Create a new dataset that collapses the dataset using first-differences
for the outcome variables (each county should be a single row in the
dataset).

In part a, estimate the normal difference-in-differences estimate.
Additionally, run a second model that linearly controls for
`agriculture_share_1920`, `agriculture_share_1930`,
`manufacturing_share_1920`, and `manufacturing_share_1930`.

``` r
setFixest_fml(
  ..X = ~ agriculture_share_1920 + agriculture_share_1930 + manufacturing_share_1920 + manufacturing_share_1930
)
```

### Part 2: Outcome Regression

Including covariates linearly is very simple and intuitively it allows
for $X_i$-specific trends. However, this assumes that treatment effects
can not vary by the value of $X$. For example, say $X$ is a dummy
variable for age. Then you are allowing for gender-specific trends, but
you are not allowing for treatment effects to vary by age. Note, this
problem is only with continuous covariates in X_i, we won’t estimate the
ATT (see Angrist 1998 or Słoczyński 2022).

Instead, we want to use outcome regression when doing covariate
adjustment in the outcome model. First, regress `D_ln_y` on the four
covariates *using just the untreated observations* (`tva == 0`). This
estimates $E(\Delta y | X, D = 0)$.

Second, predict out of sample this model for the full dataset. Let’s
call this `D_ln_y0_hat`. Last, take the difference between `D_ln_y` and
the predicted `D_ln_y0_hat` and average this for the treated group
(`tva == 1`). This is our outcome regression estimate.

### Part 3: Inverse Probability of Treatment Weighting

Now, lets use a propensity score method. Estimate a logistic regression
of $D$ on the covariates $X$ using the full sample. Predict fitted
propensity scores of this model.

Form the weights $w_1$ and $w_0$ as written in the appendix and form the
IPTW estimate.

``` r
logit = feglm(
  tva ~ ..X,
  data = first_diff, family = binomial()
)
ps = predict(logit, newdata = first_diff)
```

> \[!WARNING\]  
> The weights are the ones proposed originally in Abadie (2005). They
> are based on Horvitz-Thompson weights (1952, JASA). These are
> sensitive when there is problems with the overlap conditions.
> Sant’Anna and Zhao (2020) (amongst others) suggest using Hajek
> weights, normalizing the Horvitz-Thompson weights by the sample mean
> of $w$. This is the default with `drdid::ipwdid`.
>
> For $w_0$, the Hajek weights are
> $\frac{1}{\mathbb{P}_n(D = 1)} \frac{(1-D) \hat{p}(X)}{1 - \hat{p}(X)} / \mathbb{E}_n(\frac{(1-D) \hat{p}(X)}{1 - \hat{p}(X)})$.
> The Hajek weights are unchanged for $w_1$ since
> $w_1 = \frac{D}{\mathbb{P}_n(D = 1)} / \mathbb{E}(\frac{D}{\mathbb{P}_n(D = 1)}) = w_1$.
>
> (h/t to Pedro Sant’Anna for bringing this up)

### Part 4: Doubly-Robust DID Estimator

From the previous questions, you have all the parts to estimate the
doubly-robust DID estimator. Do this.

## Question 7

Now, let’s try using the `DRDID` package to do this more simply.

Note: DRDID requires the `idname` to be a numeric, so you need to create
a new variable for this.

## Question 8

We are going to now use `did` to estimate an event study. As a default,
`did` calls `DRDID` under the hood. Let’s see this using `did::att_gt`.
We need to create a variable for “treatment timing groups”, i.e. what
year a county starts treatment. The package takes the convention that
group = 0 for never-treated group.