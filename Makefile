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

.PHONY : all
all : tetra sims

# Analyses to highlight difficulty in tetraploids
.PHONY : tetra
tetra : ./output/tetra/iso_dr.pdf \
        ./output/tetra/s1_iterate.pdf

./output/tetra/iso_dr.pdf : ./analysis/dr_tetra.R
	mkdir -p ./output/rout
	mkdir -p ./output/tetra
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

./output/tetra/s1_iterate.pdf : ./analysis/gamfreq.R
	mkdir -p ./output/rout
	mkdir -p ./output/tetra
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

# Simulation study
.PHONY : sims
sims : $(simplots_qq) $(simplots_dr) $(simplots_pw) $(simplots_in) $(simplots_rm)

./output/sims/simdf.csv : ./analysis/sims.R
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) '--args nc=$(nc)' $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_qq) : ./analysis/sims_plots_qq.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_dr) : ./analysis/sims_plots_dr.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_pw) : ./analysis/sims_plots_power.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout

$(simplots_in) : ./analysis/sims_plots_inferred.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout


$(simplots_rm) : ./analysis/sims_plots_rm.R ./output/sims/simdf.csv
	mkdir -p ./output/rout
	mkdir -p ./output/sims
	$(rexec) $< ./output/rout/$(basename $(notdir $<)).Rout
