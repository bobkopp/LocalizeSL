The scripts in this directory are updated from

	W.V. Sweet, R. E. Kopp, C. P. Weaver, J. Obeysekera, R. Horton, E. R. Thieler,
	and C. Zervas (2017). Global and Regional Sea Level Rise Scenarios for the
	United States. Technical Report NOS CO-OPS 083. National Oceanic and
	Atmospheric Administration.

In particular, we introduce two innovations:

1. Rather than filtering a base set of gridded projections based on Kopp et al,. 2014, assumptions, we also filter a set of projections that incorporates Bamber et al. (2019) ice sheets, with the cross-temporal correlation estimated based on DeConto and Pollard (2016). This means we have a larger set of initial scenarios from which to derive targeted scenarios, and the temporal evolution is more realistic. High-end end-of-century outcomes, most likely associated with late-century acceleration in ice sheet losses, no longer imply unrealistic mid-century sea levels. 

2.  Because we have broadened the set of underlying prior scenarios, we can redefine the windows used to filter projections by 2100 targets and remove the 2050 window for the Low scenario. Projections are now filtered solely on 2100 projections, to be consistent with 30 ± 1, 50 ± 1, 100 ± 1, 150 ± 2, 200 ± 5, and 250 ± 10 cm.

3. Background rates are updated based on additional years of tide-gauge data and the use of the Dangendorf et al. (2019) GMSL curve rather than Church and White (2013) curve.