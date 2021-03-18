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

## read-counts used from Shirasawa et al (2017)
count_shir = ./output/shir/shir_size.csv \
             ./output/shir/shir_ref.csv

## Final figures from Shirasawa data
figs_shir = ./output/shir/shir_gamprob.pdf \
            ./output/shir/shir_pbox.pdf \
            ./output/shir/shir_rmhist.pdf

## Get nmat for sturgeon data
sturg_n = ./output/sturg/nmat_updog.RDS \
          ./output/sturg/nmat_delo.RDS \
          ./output/sturg/sturg_updog.RDS

## Final plots for sturgeon data
sturg_plots = ./output/sturg/sturg_hist.pdf \
              ./output/sturg/sturg_qq.pdf \
              ./output/sturg/sturg_weirdn.pdf

## Bootstrap simulation plots
boot_plots = ./output/boot/boot_qq.pdf

.PHONY : all
all : tetra sims sturg shir boot

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

## Data analysis of Sturgeon data from Delomas et al (2020)
.PHONY : sturg
sturg : $(sturg_plots)

$(sturg_n) : ./analysis/sturg/sturg_nmat.R
	mkdir -p ./output/rout
	mkdir -p ./output/sturg
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(sturg_plots) : ./analysis/sturg/sturg_hwep.R
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
