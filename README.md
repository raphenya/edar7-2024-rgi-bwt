# edar7-2024-rgi-bwt

This repository contains more details for RGI-BWT - The 7th Environmental Dimension of Antimicrobial Resistance conference (EDAR7) poster presented by A.R Raphenya.


# Abstract Title:

Resistance Gene Identifier (RGI) - Prediction of antimicrobial resistance genes in metagenomic sequencing data

# Author(s) Information:

Amogelang R. Raphenya, Brian Alcock, Dirk Hackenberger & Andrew G. McArthur

# Abstract:

The determinants of antimicrobial resistance (AMR) are at the center of health and disease in the biosphere. There is evidence that the AMR genes spread from one environment to the next due to pressures of microbial competition and anti-infective usage. There is a need to keep track of AMR determinants that pose significant health risks to all aspects of one health as a whole. There is rapid adoption of next-generation sequencing in both people and animal health, thus we can leverage these data for AMR surveillance by developing prediction software that uses reference data that is continuously updated in the AMR context. We developed the Resistance Gene Identifier (RGI) software which uses the actively maintained reference database the Comprehensive Antibiotic Resistance Database (CARD; https://card.mcmaster.ca) to predict AMR determinants.

We used metagenomic samples from soil and clinic that are enriched and whole genome sequencing (WGS). The reads were aligned to CARD canonical and CARD variants data using RGI’s metagenome module called RGI bwt to predict AMR determinants in the samples. All the read data went through quality checks i.e. trimming, removing duplicates, and removing low-quality reads.

The RGI bwt can predict the same AMR determinants before and after de novo assembly. The RGI bwt can also predict AMR determinants with low-quality data but more CARD variants are needed to map reads for WGS as compared to the targeted capture or enriched.

The RGI bwt provides an option to skip assembly, which makes it feasible to process large amounts of data to predict AMR determinants quickly. Mining AMR genes from the GenBank to produce CARD variants is an important step, but this only makes us aware of clinical AMR and less of the environment. RGI bwt is suited to be used for AMR surveillance.