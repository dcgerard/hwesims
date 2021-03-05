# ADJUST THESE VARIABLES AS NEEDED TO SUIT YOUR COMPUTING ENVIRONMENT
# -------------------------------------------------------------------
# This variable specifies the number of threads to use for the
# parallelization. This could also be specified automatically using
# environment variables. For example, in SLURM, SLURM_CPUS_PER_TASK
# specifies the number of CPUs allocated for each task.
nc = 6

# R scripting front-end. Note that makeCluster sometimes fails to
# connect to a socker when using Rscript, so we are using the "R CMD
# BATCH" interface instead.
rexec = R CMD BATCH --no-save --no-restore

# AVOID EDITING ANYTHING BELOW THIS LINE
# --------------------------------------

## Plots comparing double reduction estimates
simplots_dr = ./output/sims/alphahat_dr0.pdf \
              ./output/sims/alphahat_dr50.pdf \
              ./output/sims/alphahat_dr100.pdf

## Plots checking distributional assumptions of p-values
simplots_qq = ./output/sims/qq_nind100.pdf \
              ./output/sims/qq_nind1000.pdf \
              ./output/sims/qq_ll_nind100.pdf \
              ./output/sims/qq_ll_nind1000.pdf

## Plots on Type I error and power from simulations
simplots_pw = ./output/sims/power100.pdf \
              ./output/sims/power1000.pdf \
              ./output/sims/t1e100.pdf \
              ./output/sims/t1e1000.pdf

## Plots on Type I error of random mating test
simplots_rm = ./output/sims/rm_t1e100.pdf \
              ./output/sims/rm_t1e1000.pdf

## Inferred alpha plots
simplots_in = ./output/sims/inferred_alpha.pdf

## McAllister and Miller (2016) raw data
raw_mcadat = ./data/mca/McAllister.Miller.all.mergedRefGuidedSNPs.vcf.gz \
             ./data/mca/McAllister_Miller_Locality_Ploidy_Info.csv

## McAllister and Miller (2016) filtered data
filtered_mcadat = ./data/mca/mca_small.vcf

## read-counts used from McAllister and Miller (2016)
count_mcadat = ./output/mca/mca_refmat.csv \
               ./output/mca/mca_sizemat.csv

## read-counts used from Shirasawa et al (2017)
count_shir = ./output/shir/shir_size.csv \
             ./output/shir/shir_ref.csv

## Final figures from Shirasawa data
figs_shir = ./output/shir/shir_gamprob.pdf \
            ./output/shir/shir_pbox.pdf \
            ./output/shir/shir_rmhist.pdf

## Raw Berdugo-Cely et al (2017) data
raw_pot = ./data/pot/s1.doc \
          ./data/pot/s2.xlsx \
          ./data/pot/s3.xlsx \
          ./data/pot/s4.doc \
          ./data/pot/s5.doc

.PHONY : all
all : tetra sims mca shir pot

# Analyses to highlight difficulty in tetraploids
.PHONY : tetra
tetra : ./output/tetra/iso_dr.pdf \
        ./output/tetra/s1_iterate.pdf \
        ./output/tetra/jiang_diff.pdf

./output/tetra/iso_dr.pdf : ./analysis/tetra/dr_tetra.R
	mkdir -p ./output/rout
	mkdir -p ./output/tetra
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/tetra/s1_iterate.pdf : ./analysis/tetra/gamfreq.R
	mkdir -p ./output/rout
	mkdir -p ./output/tetra
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/tetra/jiang_diff.pdf : ./analysis/tetra/jiang_freq.R
	mkdir -p ./output/rout
	mkdir -p ./output/tetra
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

# Simulation study
.PHONY : sims
sims : $(simplots_qq) $(simplots_dr) $(simplots_pw) $(simplots_in) $(simplots_rm)

./output/sims/simdf.csv : ./analysis/sims/sims.R
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_qq) : ./analysis/sims/sims_plots_qq.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_dr) : ./analysis/sims/sims_plots_dr.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_pw) : ./analysis/sims/sims_plots_power.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_in) : ./analysis/sims/sims_plots_inferred.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout


$(simplots_rm) : ./analysis/sims/sims_plots_rm.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

## Analyze McAllister and Miller (2016) data
.PHONY : mca
mca : ./output/mca/mca_nmat.csv

$(raw_mcadat) :
	mkdir -p ./data/mca
	wget --directory-prefix=data/mca --no-clobber https://datadryad.org/stash/downloads/file_stream/9026
	wget --directory-prefix=data/mca --no-clobber https://datadryad.org/stash/downloads/file_stream/9027
	mv ./data/mca/9026 ./data/mca/McAllister.Miller.all.mergedRefGuidedSNPs.vcf.gz
	mv ./data/mca/9027 ./data/mca/McAllister_Miller_Locality_Ploidy_Info.csv

$(filtered_mcadat) : ./analysis/mca/mca_filter.R $(raw_mcadat)
	mkdir -p ./output/rout
	mkdir -p ./data/mca
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(count_mcadat) : ./analysis/mca/mca_extract.R $(filtered_mcadat)
	mkdir -p ./output/rout
	mkdir -p ./output/mca
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/mca/mca_updog.RDS : ./analysis/mca/mca_updog.R $(count_mcadat)
	mkdir -p ./output/rout
	mkdir -p ./output/mca
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

./output/mca/mca_nmat.csv : ./analysis/mca/mca_geno.R ./output/mca/mca_updog.RDS
	mkdir -p ./output/rout
	mkdir -p ./output/mca
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

## Data analysis using Shirasawa data
.PHONY : shir
shir : $(figs_shir)

./data/shir/KDRIsweetpotatoXushu18S1LG2017.vcf : 
	mkdir -p ./data/shir
	wget --directory-prefix=data/shir --no-clobber ftp://ftp.kazusa.or.jp/pub/sweetpotato/GeneticMap/KDRIsweetpotatoXushu18S1LG2017.vcf.gz
	7z e ./data/shir/KDRIsweetpotatoXushu18S1LG2017.vcf.gz -o./data/shir

$(count_shir) : ./analysis/shir/shir_filter.R ./data/shir/KDRIsweetpotatoXushu18S1LG2017.vcf
	mkdir -p ./output/rout
	mkdir -p ./output/shir
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/shir/shir_updog.RDS : ./analysis/shir/shir_updog.R $(count_shir)
	mkdir -p ./output/rout
	mkdir -p ./output/mca
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

./output/shir/shir_nmat.csv : ./analysis/shir/shir_geno.R ./output/shir/shir_updog.RDS
	mkdir -p ./output/rout
	mkdir -p ./output/shir
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(figs_shir) : ./analysis/shir/shir_hwep.R ./output/shir/shir_nmat.csv
	mkdir -p ./output/rout
	mkdir -p ./output/shir
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout


## Data analysis using Berdugo-Cely et al data (https://doi.org/10.1371/journal.pone.0173039)
.PHONY : pot
pot : $(raw_pot)

$(raw_pot) :
	mkdir -p ./data/pot
	wget --directory-prefix=data/pot --no-clobber https://doi.org/10.1371/journal.pone.0173039.s002 
	wget --directory-prefix=data/pot --no-clobber https://doi.org/10.1371/journal.pone.0173039.s003
	wget --directory-prefix=data/pot --no-clobber https://doi.org/10.1371/journal.pone.0173039.s004
	wget --directory-prefix=data/pot --no-clobber https://doi.org/10.1371/journal.pone.0173039.s005
	wget --directory-prefix=data/pot --no-clobber https://doi.org/10.1371/journal.pone.0173039.s006
	mv ./data/pot/journal.pone.0173039.s002 ./data/pot/s1.doc
	mv ./data/pot/journal.pone.0173039.s003 ./data/pot/s2.xlsx
	mv ./data/pot/journal.pone.0173039.s004 ./data/pot/s3.xlsx
	mv ./data/pot/journal.pone.0173039.s005 ./data/pot/s4.doc
	mv ./data/pot/journal.pone.0173039.s006 ./data/pot/s5.doc

