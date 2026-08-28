using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -S*(betaI*I + betaU*U)/N,
    E'(t) = S*(betaI*I + betaU*U)/N - k*E,
    I'(t) = k*rho*E - gamma*I,
    U'(t) = k*(1-rho)*E - gamma*U,
    R'(t) = gamma*I + gamma*U,
    y1(t) = k*rho*E
)

known_states = [S, E, I, U, R]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model9_unknown_initial.txt")

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
            println("LIYANAGE2026 Model9_unknown_initial")
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
