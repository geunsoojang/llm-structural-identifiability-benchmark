using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -S(t)*(alpha*I(t) + beta*D(t) + gamma*A(t) + delta*R(t)),
    I'(t) = S(t)*(alpha*I(t) + beta*D(t) + gamma*A(t) + delta*R(t)) - (epsilon + zeta + lambda)*I(t),
    D'(t) = epsilon*I(t) - (eta + rho)*D(t),
    A'(t) = zeta*I(t) - (theta + mu + kappa)*A(t),
    R'(t) = eta*D(t) + theta*A(t) - (nu + xi)*R(t),
    T'(t) = mu*A(t) + nu*R(t) - (sigma + tau)*T(t),
    H'(t) = lambda*I(t) + rho*D(t) + kappa*A(t) + xi*R(t) + sigma*T(t),
    E'(t) = tau*T(t),
    G'(t) = epsilon*I(t) + theta*A(t),
    y1(t) = D(t),
    y2(t) = R(t),
    y3(t) = T(t),
    y4(t) = E(t),
    y5(t) = G(t)
)

known_states = [S, I, D, A, R, T, H, E, G]
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

run_case("sidarthe_reconstructed_surveillance unknown initial conditions", "sidarthe_reconstructed_surveillance_unknown_initial.txt")
run_case("sidarthe_reconstructed_surveillance known initial conditions", "sidarthe_reconstructed_surveillance_known_initial.txt", known_ic = known_states)