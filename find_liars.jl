using Primes
using DataFrames
using CSV
using Plots
using PlotThemes
include("./witness.jl")


highest_tested = 15000

scores = DataFrame(number = 1:highest_tested, 
	times_testified = zeros(highest_tested), 
	times_lied = zeros(highest_tested),
	truth_score = zeros(highest_tested))  # initialize the scoring grid

bar_steps = 40
update_step = floor(highest_tested / bar_steps)  # step to print update on
update_count = 0

for n = 1:highest_tested
	# progress bar stoofs
	percent_done = trunc(100 * n / highest_tested, sigdigits=3)
	if n % update_step == 0 && update_count < bar_steps global update_count += 1 end
	bar = string("[ ", repeat("#", update_count), repeat("-", bar_steps - update_count), " ] ", percent_done, " %  ", "Number Reached: $n\r") 
	print(bar)

	n_is_prime = isprime(n)
	d = dressnumber(n)[1]

	# check which numbers are lying for all numbers less than n
	for a = 1:n-1
		scores[a, :times_testified] += 1
		# update the number of times a number has lied
		if getwitness(n, a, d) != n_is_prime
			scores[a, :times_lied] += 1
		end
	end
end
println()
println("All numbers tested")

for i = scores.number 
	scores[i, :truth_score] = 1 - (scores[i, :times_lied] / scores[i, :times_testified])
end

# save scores to a .csv file
ranked = sort(filter(num -> num.times_testified > highest_tested*0.6, scores), :truth_score)
output_file = "liars_upto_$highest_tested.csv"
output_file_2 = "liars_upto_$highest_tested" * "_ranked.csv"
CSV.write(output_file, scores)
CSV.write(output_file_2, ranked)

println("Scores stored in $output_file")


# make an ultra smexy lookin graph for displaying all that juicy data
theme(:gruvbox_dark)
plot(scores[:, :number], 
	scores[:, :truth_score],
	seriestype = :scatter,
	markerstrokewidth = 0,
	markersize = 2.5,
	title = "Truthfullness of numbers 1 to $highest_tested",
	label = "")
xlabel!("Number")
ylabel!("Truthfullness")
plot_output_file = "liars_upto_$highest_tested.png"
savefig(plot_output_file)

println("Plot stored in $plot_output_file")

println("Job Completed")
