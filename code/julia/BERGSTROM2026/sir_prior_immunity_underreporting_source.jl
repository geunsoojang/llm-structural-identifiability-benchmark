using StructuralIdentifiability
using Logging

# Source: Bergstrom et al. 2026, deterministic reported/unreported SIR model.
# The paper's central feature is parameter-dependent initial conditions; the
# baseline StructuralIdentifiability.jl call below treats ICs generically.
ode = @ODEmodel(
    S'(t) = -(beta_r*Ir(t) + beta_u*Iu(t))*S(t)/n,
    Ir'(t) = p*(beta_r*Ir(t) + beta_u*Iu(t))*S(t)/n - gamma*Ir(t),
    Iu'(t) = (1 - p)*(beta_r*Ir(t) + beta_u*Iu(t))*S(t)/n - gamma*Iu(t),
    Rr'(t) = gamma*Ir(t),
    Ru'(t) = gamma*Iu(t),

    y1(t) = p*(beta_r*Ir(t) + beta_u*Iu(t))*S(t)/n
)

known_states = [S, Ir, Iu, Rr, Ru]
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

run_case("sir_prior_immunity_underreporting_source unknown initial conditions", "sir_prior_immunity_underreporting_source_unknown_initial.txt")
run_case("sir_prior_immunity_underreporting_source known initial conditions", "sir_prior_immunity_underreporting_source_known_initial.txt", known_ic = known_states)