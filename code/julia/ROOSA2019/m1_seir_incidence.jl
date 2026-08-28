using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/N,
    E'(t) = beta*S(t)*I(t)/N - k*E(t),
    I'(t) = k*E(t) - gamma*I(t),
    R'(t) = gamma*I(t),
    C'(t) = k*E(t),

    y1(t) = k*E(t),
    y2(t) = N
)

known_states = [S, E, I, R, C]
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

run_case("m1_seir_incidence unknown initial conditions", "m1_seir_incidence_unknown_initial.txt")
run_case("m1_seir_incidence known initial conditions", "m1_seir_incidence_known_initial.txt", known_ic = known_states)