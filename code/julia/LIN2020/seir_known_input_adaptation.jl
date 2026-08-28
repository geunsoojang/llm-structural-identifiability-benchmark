using StructuralIdentifiability
using Logging

# Adaptation: governmental action, individual reaction, and zoonotic forcing are
# treated as known input functions ga(t), ir(t), and zoonotic(t).
ode = @ODEmodel(
    S'(t) = -beta0*ga(t)*ir(t)*S(t)*I(t)/N(t) - zoonotic(t),
    E'(t) = beta0*ga(t)*ir(t)*S(t)*I(t)/N(t) + zoonotic(t) - sigma*E(t),
    I'(t) = sigma*E(t) - gamma*I(t),
    R'(t) = gamma*I(t),
    N'(t) = 0,
    D'(t) = d_severe*gamma*I(t),
    C'(t) = sigma*E(t),

    y1(t) = C(t)
)

known_states = [S, E, I, R, N, D, C]
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

run_case("seir_known_input_adaptation unknown initial conditions", "seir_known_input_adaptation_unknown_initial.txt")
run_case("seir_known_input_adaptation known initial conditions", "seir_known_input_adaptation_known_initial.txt", known_ic = known_states)