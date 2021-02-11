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

.PHONY : all
all : tetra

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
