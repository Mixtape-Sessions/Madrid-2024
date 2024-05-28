********************************************************************************
* name: covariates.do
* author: scott cunningham (baylor) 
* description: illustrating heterogeneous treatment effects with respect to covariates in a panel
* last updated: may 28, 2024
********************************************************************************

clear
capture log close
set seed 20200403

* 1,000 workers (25 per state), 40 states, 4 groups (250 per group), 30 years
* First create the states
set obs 40
gen state = _n

* Generate 1000 workers. These are in each state. So 25 per state.
expand 25
bysort state: gen worker=runiform(0,5)
label variable worker "Unique worker fixed effect per state"
egen id = group(state worker)

* Treatment group is upper half
gen treat = 0
replace treat = 1 if id >= 500

* Generate Covariates (Baseline values)
gen age = rnormal(35, 10)
gen gpa = rnormal(2.0, 0.5)

* Center Covariates (Baseline)
su age
replace age = age - r(mean)
su gpa
replace gpa = gpa - r(mean)

* Generate Polynomial and Interaction Terms (Baseline)
gen age_sq = age^2
gen gpa_sq = gpa^2

* Generate the years
expand 2
sort state
bysort state worker: gen year = _n
gen n = year

replace year = 1990 if year == 1
replace year = 1991 if year == 2

* Post-treatment
gen post = 0  
replace post = 1 if year == 1991

* Generate Potential Outcomes with Baseline and Year Difference
gen		y0 = 40000 + 100 * age + 1000 * gpa + rnormal(0,1500) if year==1990 & treat==1
replace	y0 = 40000 + 200 * age + 2000 * gpa + rnormal(0,1500) if year==1991 & treat==1

replace	y0 = 50000 + 100 * age + 1000 * gpa + -1 + rnormal(0,1500) if year==1990 & treat==0
replace	y0 = 50000 + 200 * age + 2000 * gpa + -2 + rnormal(0,1500) if year==1991 & treat==0
replace y0=0 if y0<0

* Covariate heterogeneity
gen 	y1 = y0 
replace y1 = y0 + 1000 + 1000 * age + 4000 * gpa if year == 1991
replace y1=0 if y1<0

* Summarizing individual treatment effect, ATE and ATT
gen delta = y1 - y0

sum delta
gen ate = `r(mean)'
sum delta if treat==1 & post==1
gen att = `r(mean)'

* Generate observed outcome based on treatment assignment
gen 	earnings = y0
replace earnings = y1 if post == 1 & treat == 1

* Regression
regress earnings age gpa  post##treat, robust

* Doubly-robust DID
drdid earnings age gpa  if year == 1990 | year == 1991, time(year) ivar(id) tr(treat) all



