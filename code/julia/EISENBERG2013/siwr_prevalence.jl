using StructuralIdentifiability
using Logging

# Nondimensional SIWR model from Eisenberg et al. 2013.
ode = @ODEmodel(
    s'(t) = mu - beta_W*s(t)*w(t) - beta_I*s(t)*i(t) - mu*s(t),
    i'(t) = beta_W*s(t)*w(t) + beta_I*s(t)*i(t) - gamma*i(t) - mu*i(t),
    w'(t) = xi*(i(t) - w(t)),
    r'(t) = gamma*i(t) - mu*r(t),

    y1(t) = k*i(t)
)

known_states = [s, i, w, r]
result_dir = joinpath(pwd(), "result")
mkpath(result_dir)

function print_classification(result)
    for (quantity, classification) in result
        println(quantity, " => ", classification)
    end
end

function print_functions(functions)
    for f in functions
        println(f)
    end
end

function run_case(label, filename; known_ic = nothing)
    out_file = joinpath(result_dir, filename)
    open(out_file, "w") do io
        redirect_stdout(io) do
            redirect_stderr(io) do
                println(label)
                println()

                println("assess_identifiability(ode)")
                elapsed = @elapsed begin
                    if known_ic === nothing
                        result = assess_identifiability(ode, loglevel = Logging.Warn)
                    else
                        result = assess_identifiability(ode, known_ic = known_ic, loglevel = Logging.Warn)
                    end
                    print_classification(result)
                end
                println()
                println("elapsed_seconds = ", elapsed)

                println()
                println("find_identifiable_functions(ode)")
                if known_ic === nothing
                    funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
                else
                    funcs = find_identifiable_functions(ode, known_ic = known_ic, loglevel = Logging.Warn)
                end
                print_functions(funcs)
            end
        end
    end
    println("saved: ", out_file)
end

run_case("siwr_prevalence unknown initial conditions", "siwr_prevalence_unknown_initial.txt")
run_case("siwr_prevalence known initial conditions", "siwr_prevalence_known_initial.txt", known_ic = known_states)