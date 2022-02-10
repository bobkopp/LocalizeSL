**As of 2022, the ProjectSL/LocalizeSL is no longer in development. The primary Rutgers Earth System Science & Policy Lab platform for sea-level rise projections is now the Framework for Assessing Changes To Sea-level (FACTS).**

For most users, the IPCC AR6 sea level projections, developed using FACTS, are the most suitable global source of local sea-level projections. Datasets can be downloaded [from Zenodo](https://zenodo.org/communities/ipcc-ar6-sea-level-projections). The primary AR6 sea level projection data set is available at [doi:10.5281/zenodo.5914710](https://doi.org/10.5281/zenodo.5914710).

The [NASA/IPCC Sea Level Projection Viewer](https://sealevel.nasa.gov/ipcc-ar6-sea-level-projection-tool) provides a graphical interface to the AR6 sea-level projection dataset.

The archived version of LocalizeSL is available at [doi:10.5281/zenodo.6029806](https://doi.org/10.5281/zenodo.6029806).

---


# LocalizeSL: Offline sea-level localization code

README file last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 26 July 2019

## Citation

This code was originally developed to accompany the results of

	R. E. Kopp, R. M. Horton, C. M. Little, J. X. Mitrovica, M. Oppenheimer,
	D. J. Rasmussen, B. H. Strauss, and C. Tebaldi (2014). Probabilistic 21st
	and 22nd century sea-level projections at a global network of tide	gauge
	sites. Earth's Future 2: 287–306, doi:10.1002/2014EF000239. 

Please cite that paper when using any sea-level rise projections generated with this code.

Additional features have subsequently been added to this  paper. Features related to sea-level rise allowances were developed for 

	M. K. Buchanan, R. E. Kopp, M. Oppenheimer, and C. Tebaldi (2016).
	Allowances for evolving coastal flood risk under uncertain local sea-level
	rise. Climatic Change 137, 347-362. doi:10.1007/s10584-016-1664-7.

Features related to developing discrete sea-level rise scenarios conditional on ranges of global mean sea level were developed for

	W.V. Sweet, R. E. Kopp, C. P. Weaver, J. Obeysekera, R. Horton, E. R. Thieler,
	and C. Zervas (2017). Global and Regional Sea Level Rise Scenarios for the
	United States. Technical Report NOS CO-OPS 083. National Oceanic and
	Atmospheric Administration.
	
Features related to the substitution of output from a physical Antarctic ice-sheet model into the projections framework were developed for

	R. E. Kopp, R. M. DeConto, D. A. Bader, R. M. Horton, C. C. Hay, S. Kulp,
	M. Oppenheimer, D. Pollard, and B. H. Strauss (2017). Implications of
	Antarctic ice-cliff collapse and ice-shelf hydrofracturing mechanisms for
	sea-level projections. Earth’s Future 5, 1217-1233. doi: 10.1002/2017EF000663. 
	
Features related to the use of scenarios other than the RCPs (e.g., temperature-based scenarios) were developed for 

	D. J. Rasmussen, K. Bittermann, M. K. Buchanan, S. Kulp, 
	B. H. Strauss, R. E. Kopp, and M. Oppenheimer (2018). Extreme
	sea level implications of 1.5 °C, 2.0 °C, and 2.5 °C temperature
	stabilization targets in the 21st and 22nd centuries. 
	Environmental Research Letters 13, 034040. doi: 10.1088/1748-9326/aaac87.
	
Additional projections using structured expert judgement-based estimates of ice-sheet contributions at narrowly defined time points were developed for 
	
	J. L. Bamber, M. Oppenheimer, R. E. Kopp, W. Aspinall and 
	R. M. Cooke (2019). Ice sheet contributions to future sea level 
	rise from structured expert judgement. Proceedings of the 
	National Academy of Sciences. doi: 10.1073/pnas.1817205116.
	
Please cite the appropriate papers if making use of these features.

## Overview

This code requires MATLAB with the Statistics Toolbox.

This MATLAB code is intended to help end-users who wish to work with the sea-level rise projections of Kopp et al. (2014) in greater detail than provided by the supplementary tables accompanying that table but without re-running the full global analysis using the [supplementary code accompanying the paper](http://github.com/bobkopp/ProjectSL). Key functionality these routines provide include:

1. Local sea-level rise projections at decadal time points and arbitrary quantiles
2. Localized Monte Carlo samples, disaggregatable by contributory process
3. Localized variance decomposition plots 

The IFILES directory contains the ~300 MB core files, which store 10,000+ Monte Carlo samples per emissions scenario for each of the processes contributing to global sea-level change, along with metadata. The code loads these samples without regenerating them and then localizes them. (Note that this files is stored in the Github archive using Git Large File Storage; if you do not have git-lfs set up, cloning the archive will only get you a pointer to this file, which you can download using the Github web interface.)

Functions are stored in the MFILES directory. Example scripts are stored in the scripts directory.

The most important function is **LocalizeStoredProjections**:
 	[sampslocrise,sampsloccomponents,siteids,sitenames,targyears,scens,cols] =
	LocalizeStoredProjections(focussites,storefile)

LocalizeStoredProjections takes as input two parameters. STOREFILE is the path of the core file. FOCUSSITES is the PSMSL ID or IDs of the site(s) of interest. (Please see psmsl.org or the supplementary tables of Kopp et al. (2017) to identify the IDs corresponding to your site of interest. Specify 0 if you want GSL samples returned in the same format.)

LocalizeStoredProjections outputs two M x N cell arrays of localized Monte Carlo samples, SAMPSLOCRISE and SAMPSLOCCOMPONENTS. In each cell array, the m rows correspond to the sites specified in FOCUSSITES and the N columns to different RCPs (specifically, RCP 8.5, RCP 6.0, RCP 4.5, and RCP 2.6). 

The individual cells of SAMPSLOCRISE are P x Q arrays, with the P rows being 10,000 Monte Carlo samples and the Q columns corresponding to decadal time points. The individual cells of SAMPSLOCRISE are P x Q arrays, with the P rows being 10,000 Monte Carlo samples and the Q columns corresponding to decadal time points. The individual cells of SAMPSLOCCOMPONENTS are P x R x Q arrays. The 1st and 3rd dimensions correspond to the rows and columns of SAMPSLOCRISE; the R columns represent 24 different factors contributing to sea-level rise. Specifically, these factors are:

	1 - GIC: Alaska
	2 - GIC: Western Canada/US
	3 - GIC: Arctic Canada North
	4 - GIC: Arctic Canada South
	5 - GIC: Greenland peripheral glaciers
	6 - GIC: Iceland
	7 - GIC: Svalbard
	8 - GIC: Scandinavia
	9 - GIC: Russian Arctic
	10 - GIC: North Asia
	11 - GIC: Central Europe
	12 - GIC: Caucasus
	13 - GIC: Central Asia
	14 - GIC: South Asia West
	15 - GIC: South Asia East
	16 - GIC: Low Latitude
	17 - GIC: Southern Andes
	18 - GIC: New Zealand
	19 - Greenland Ice Sheet
	20 - West Antarctic Ice Sheet
	21 - East Antarctic Ice Sheet
	22 - Land water storage
	23 - Oceanographic processes (thermal expansion and ocean dynamics)
	24 - GIA, tectonics, and other background processes
	
The other outputs of LocalizeStoredProjections are identifying information that can be passed out to the output commands. SITEIDS returns the PSMSL site IDs of selected sites; SITENAMES the names of those sites; TARGYEARS the years of the output; SCENS the RCPs; and COLS are column labels.

Several other provided functions produce output, with detailed parameter specification described in the headers.

**PlotSLRProjection** generates a time series plot.
**PlotSLRProjectionVariance** generates a variance decomposition plot.
**WriteTableMC** outputs Monte Carlo samples.
**WriteTableSLRProjection** outputs desired quantiles of the projections.

Example scripts that serve the most common uses of LocalizeSL are provided in **scripts/generic**.  Example scripts associated with various publications are also provided in the scripts directory.

----

    Copyright (C) 2019 by Robert E. Kopp


    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
