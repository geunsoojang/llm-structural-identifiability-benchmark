using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -S(t)*(betaI*I(t) + betaU*U(t))/N,
    E'(t) = S(t)*(betaI*I(t) + betaU*U(t))/N - k*E(t),
    I'(t) = k*rho*E(t) - (gamma+alpha)*I(t),
    U'(t) = k*(1-rho)*E(t) - gamma*U(t),
    H'(t) = alpha*I(t) - gammaH*H(t) - delta*H(t),
    D'(t) = delta*H(t),
    R'(t) = gamma*I(t) + gamma*U(t) + gammaH*H(t),
    y1(t) = k*rho*E(t),
    y2(t) = alpha*I(t),
    y3(t) = N
)

known_states = [S, E, I, U, H, D, R]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model10a_known_initial.txt")

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
            println("LIYANAGE2026 Model10a_known_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, known_ic = known_states, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, known_ic = known_states, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
