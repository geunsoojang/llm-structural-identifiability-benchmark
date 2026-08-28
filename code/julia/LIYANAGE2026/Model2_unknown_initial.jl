using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/N,
    E'(t) = beta*S(t)*I(t)/N - k*E(t),
    I'(t) = k*rho*E(t) - gamma*I(t),
    A'(t) = k*(1-rho)*E(t) - gamma*A(t),
    R'(t) = gamma*I(t) + gamma*A(t),
    y1(t) = k*rho*E(t)
)

known_states = [S, E, I, A, R]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model2_unknown_initial.txt")

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
            println("LIYANAGE2026 Model2_unknown_initial")
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
