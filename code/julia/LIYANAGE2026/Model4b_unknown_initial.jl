using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/(S(t)+E(t)+I(t)+R(t)),
    E'(t) = beta*S(t)*I(t)/(S(t)+E(t)+I(t)+R(t)) - k*E(t),
    I'(t) = k*E(t) - (gamma+delta)*I(t),
    R'(t) = gamma*I(t),
    D'(t) = delta*I(t),
    y1(t) = k*E(t),
    y2(t) = delta*I(t)
)

known_states = [S, E, I, R, D]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model4b_unknown_initial.txt")

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

open(out_file, "w") do io
    redirect_stdout(io) do
        redirect_stderr(io) do
            println("LIYANAGE2026 Model4b_unknown_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
