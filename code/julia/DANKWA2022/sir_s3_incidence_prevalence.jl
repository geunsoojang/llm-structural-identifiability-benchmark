using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -b*S(t)*In(t)/(S(t) + In(t) + R(t)),
    In'(t) = b*S(t)*In(t)/(S(t) + In(t) + R(t)) - g*In(t),
    R'(t) = g*In(t),
    y1(t) = b*S(t)*In(t)/(S(t) + In(t) + R(t)),
    y2(t) = In(t)/(S(t) + In(t) + R(t))
)

known_states = [S, In, R]
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
                println("DANKWA2022 ", label)
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

run_case("sir_s3_incidence_prevalence unknown initial conditions", "sir_s3_incidence_prevalence_unknown_initial.txt")
run_case("sir_s3_incidence_prevalence known initial conditions", "sir_s3_incidence_prevalence_known_initial.txt", known_ic = known_states)
