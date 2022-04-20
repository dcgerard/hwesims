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
simplots_qq = ./output/sims/qq_ll_nind100_dr0.pdf \
              ./output/sims/qq_ll_nind100_dr100.pdf \
              ./output/sims/qq_ll_nind100_dr50.pdf \
              ./output/sims/qq_ll_nind1000_dr0.pdf \
              ./output/sims/qq_ll_nind1000_dr100.pdf \
              ./output/sims/qq_ll_nind1000_dr50.pdf \
              ./output/sims/qq_ll_nind25_dr0.pdf \
              ./output/sims/qq_ll_nind25_dr100.pdf \
              ./output/sims/qq_ll_nind25_dr50.pdf \
              ./output/sims/qq_nind100_dr0.pdf \
              ./output/sims/qq_nind100_dr100.pdf \
              ./output/sims/qq_nind100_dr50.pdf \
              ./output/sims/qq_nind1000_dr0.pdf \
              ./output/sims/qq_nind1000_dr100.pdf \
              ./output/sims/qq_nind1000_dr50.pdf \
              ./output/sims/qq_nind25_dr0.pdf \
              ./output/sims/qq_nind25_dr100.pdf \
              ./output/sims/qq_nind25_dr50.pdf

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

## F1 Simulation Plots
f1simplots = ./output/f1sims/f1_dr_box.pdf \
             ./output/f1sims/f1_mse.pdf

## read-counts used from Shirasawa et al (2017)
count_shir = ./output/shir/shir_size.csv \
             ./output/shir/shir_ref.csv

## Final figures from Shirasawa data
figs_shir = ./output/shir/shir_gamprob.pdf \
            ./output/shir/shir_pbox.pdf \
            ./output/shir/shir_rmhist.pdf

## Raw data from Delomas et al (2021)
sturg_dat = ./data/sturg/2n_3n_Chinook_readCounts.rda \
            ./data/sturg/8n_12n_sturgeon_readCounts.rda \
            ./data/sturg/10n_sturgeon_readCounts.rda \
            ./data/sturg/white_sturgeon_genos.zip

## Get nmat for sturgeon data
sturg_n = ./output/sturg/nmat_updog.RDS \
          ./output/sturg/nmat_delo.RDS \
          ./output/sturg/sturg_updog.RDS

## Final plots for sturgeon data
sturg_plots = ./output/sturg/sturg_hist.pdf \
              ./output/sturg/sturg_qq.pdf \
              ./output/sturg/pvalue_pairs.pdf

## Bootstrap simulation plots
boot_plots = ./output/boot/boot_qq.pdf

## McAllister and Miller (2016) raw data
raw_mcadat = ./data/mca/McAllister.Miller.all.mergedRefGuidedSNPs.vcf.gz \
             ./data/mca/McAllister_Miller_Locality_Ploidy_Info.csv

## McAllister and Miller (2016) filtered data
filtered_mcadat = ./data/mca/mca_small.vcf

## read-counts used from McAllister and Miller (2016)
count_mcadat = ./output/mca/mca_refmat.csv \
               ./output/mca/mca_sizemat.csv

.PHONY : all
all : tetra sims sturg shir boot uncert f1sims intro mca

# Analyses to highlight difficulty in tetraploids
.PHONY : tetra
tetra : ./output/tetra/iso_dr.pdf \
        ./output/tetra/s1_iterate.pdf \
        ./output/tetra/jiang_diff.pdf \
        ./output/tetra/naive_diff.pdf

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

./output/tetra/naive_diff.pdf : ./analysis/tetra/naive_true.R
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

$(simplots_pw) : ./analysis/sims/sims_plots_power.R ./output/sims/simdf.csv ./output/boot/boot_sims.csv
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

## Data analysis of Sturgeon data from Delomas et al (2021)
.PHONY : sturg
sturg : $(sturg_plots) ./output/sturg/chisq_stats.pdf

$(sturg_dat) :
	mkdir -p ./data/sturg
	wget --directory-prefix=data/sturg --no-clobber https://datadryad.org/stash/downloads/file_stream/711274
	mv ./data/sturg/711274 ./data/sturg/10n_sturgeon_readCounts.rda
	wget --directory-prefix=data/sturg --no-clobber https://datadryad.org/stash/downloads/file_stream/711272
	mv ./data/sturg/711272 ./data/sturg/2n_3n_Chinook_readCounts.rda
	wget --directory-prefix=data/sturg --no-clobber https://datadryad.org/stash/downloads/file_stream/711273
	mv ./data/sturg/711273 ./data/sturg/8n_12n_sturgeon_readCounts.rda
	wget --directory-prefix=data/sturg --no-clobber https://datadryad.org/stash/downloads/file_stream/711275
	mv ./data/sturg/711275 ./data/sturg/white_sturgeon_genos.zip

$(sturg_n) : ./analysis/sturg/sturg_nmat.R $(sturg_dat)
	mkdir -p ./output/rout
	mkdir -p ./output/sturg
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

./output/sturg/pdf.csv : ./analysis/sturg/sturg_hwep.R $(sturg_n)
	mkdir -p ./output/rout
	mkdir -p ./output/sturg
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(sturg_plots) : ./analysis/sturg/sturg_plot.R ./output/sturg/pdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sturg
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/sturg/chisq_stats.pdf : ./analysis/sturg/sturg_intuit.R ./output/sturg/pdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sturg
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

## Bootstrap simulations
.PHONY : boot
boot : $(boot_plots)

./output/boot/boot_sims.csv : ./analysis/boot/boot_sims.R
	mkdir -p ./output/rout
	mkdir -p ./output/boot
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(boot_plots) : ./analysis/boot/boot_plots.R ./output/boot/boot_sims.csv
	mkdir -p ./output/rout
	mkdir -p ./output/boot
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

## Sims under genotype uncertainty
.PHONY : uncert
uncert : ./output/uncert/uncert_hist.pdf

./output/uncert/uncert_sims.csv : ./analysis/uncert/uncert.R
	mkdir -p ./output/rout
	mkdir -p ./output/uncert
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/uncert/uncert_hist.pdf : ./analysis/uncert/uncert_plots.R ./output/uncert/uncert_sims.csv
	mkdir -p ./output/rout
	mkdir -p ./output/uncert
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

## F1 simulations to estimate double reduction
.PHONY : f1sims
f1sims: $(f1simplots)

./output/f1sims/f1simsout.csv : ./analysis/f1sims/f1sims.R
	mkdir -p ./output/rout
	mkdir -p ./output/f1sims
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(f1simplots) : ./analysis/f1sims/f1plots.R ./output/f1sims/f1simsout.csv ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/f1sims
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

## More extensive null simulations for main manuscript

.PHONY : intro
intro : ./output/intro/t1e.pdf

./output/intro/null_sims.RDS : ./analysis/intro/t1e.R
	mkdir -p ./output/rout
	mkdir -p ./output/intro
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

./output/intro/t1e.pdf : ./analysis/intro/t1e_plot.R ./output/intro/null_sims.RDS
	mkdir -p ./output/rout
	mkdir -p ./output/intro
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout
