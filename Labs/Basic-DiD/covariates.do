********************************************************************************
* name: covariates.do
* author: scott cunningham (baylor) 
* description: illustrating heterogeneous treatment effects with respect to covariates in a panel
* last updated: may 28, 2024
********************************************************************************

clear
capture log close
set seed 20200403

********************************************************************************
* Define dgp
********************************************************************************
cap program drop dgp
program define dgp

	* 1,000 workers (25 per state), 40 states, 4 groups (250 per group), 30 years
	* First create the states
	quietly set obs 40
	gen state = _n

	* Generate 1000 workers. These are in each state. So 25 per state.
	quietly expand 25
	bysort state: gen worker=runiform(0,5)
	label variable worker "Unique worker fixed effect per state"
	quietly egen id = group(state worker)

	* Generate Covariates (Baseline values)
	gen age = rnormal(35, 10)
	gen gpa = rnormal(2.0, 0.5)

	* Center Covariates (Baseline)
	sum age, meanonly
	qui replace age = age - r(mean)
	sum gpa, meanonly
	qui replace gpa = gpa - r(mean)

	* Generate Polynomial and Interaction Terms (Baseline)
	gen age_sq = age^2
	gen gpa_sq = gpa^2
	gen interaction = age * gpa
	
	* Treatment probability increases with age and decrease with gpa
	gen propensity = 0.3 + 0.3 * (age > 0) + 0.2 * (gpa > 0)
	gen treat = runiform() < propensity

	* Generate the years
	quietly expand 2
	sort state
	bysort state worker: gen year = _n
	gen n = year

	qui replace year = 1990 if year == 1
	qui replace year = 1991 if year == 2
	
	* Post-treatment
	gen post = 0  
	qui replace post = 1 if year == 1991


	* Generate Baseline Earnings with control group making 10,000 more at baseline
	qui gen     baseline = 40000 + 1000 * age + 500 * gpa if treat==1
	qui replace baseline = 50000 + 1000 * age + 500 * gpa if treat==0
	
	* Generate Potential Outcomes with Baseline and Year Difference
	gen          e = rnormal(0, 1500)
	qui gen 	  y0 = baseline + 1000 + 100 * age + 1000 * gpa + e if year == 1990
	qui replace y0 = baseline + 1000 + 200 * age + 2000 * gpa + e if year == 1991
	* ^ NOTE: 
	* The change in coefficients on age and gpa generate trends in outcomes.
	* If two units have the same age and same gpa, then they will have the same change in y0.

	* Covariate-based treatment effect heterogeneity
	gen 	y1 = y0
	qui replace y1 = y0 + 1000 + 100 * age + 500 * gpa if year == 1991

	* Treatment effect
	gen delta = y1 - y0
	label var delta "Treatment effect for unit i (unobservable in the real world)"
	
	sum delta if post == 1, meanonly
	gen ate = `r(mean)'
	sum delta if treat==1 & post==1, meanonly
	gen att = `r(mean)'

	* Generate observed outcome based on treatment assignment
	gen 	earnings = y0
	qui replace earnings = y1 if post == 1 & treat == 1
end



********************************************************************************
* Generate a sample
********************************************************************************
clear
quietly dgp
sum att ate

* Regression breaks
regress earnings i.post i.treat i.post#i.treat i.post#c.age i.post#c.gpa i.post#c.age_sq i.post#c.gpa_sq, robust

* DRDID works
drdid earnings age gpa age_sq gpa_sq, time(year) ivar(id) tr(treat) all




********************************************************************************
* Monte-carlo simulation
********************************************************************************
cap program drop sim
program define sim, rclass
	clear
	quietly dgp
	
	* DRDID
	quietly drdid earnings age gpa age_sq gpa_sq, time(year) ivar(id) tr(treat) all
	
	return scalar dripw = e(b)[1,1]
	return scalar regadjust = e(b)[1,3]
	return scalar ipw = e(b)[1,4]
	
	* OLS
	quietly regress earnings i.post i.treat i.post#i.treat i.post#c.age i.post#c.gpa i.post#c.age_sq i.post#c.gpa_sq, robust
	return scalar ols = _b[1.post#1.treat]
end

simulate dripw = r(dripw) regadjust = r(regadjust) ipw = r(ipw) ols = r(ols), reps(50): sim
sum

kdensity ols,  xtitle(Estimated ATT) xline(1262, lwidth(medthick) lpattern(dash) lcolor(blue) extend) xlabel(1262 1910) xline(1910, lwidth(med) lpattern(solid) lcolor(red) extend) subtitle(Estimated with OLS) ytitle("") title("Density of ATT estimates from OLS") note("")

kdensity dripw,  xtitle(Estimated ATT) xline(1262, lwidth(medthick) lpattern(dash) lcolor(blue) extend) xlabel(1262 1279.5) xline(1279.5, lwidth(med) lpattern(solid) lcolor(red) extend) subtitle(Estimated with OLS) ytitle("") title("Density of ATT estimates from Double Robust IPW") note("")

kdensity regadjust,  xtitle(Estimated ATT) xline(1262, lwidth(medthick) lpattern(dash) lcolor(blue) extend) xlabel(1262 1270.46) xline(1270.46, lwidth(med) lpattern(solid) lcolor(red) extend) subtitle(Estimated with OLS) ytitle("") title("Density of ATT estimates from Outcome Regression") note("")

kdensity ipw,  xtitle(Estimated ATT) xline(1262, lwidth(medthick) lpattern(dash) lcolor(blue) extend) xlabel(1262 1246) xline(1246, lwidth(med) lpattern(solid) lcolor(red) extend) subtitle(Estimated with OLS) ytitle("") title("Density of ATT estimates from IPW") note("")


