using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/N - ell*beta*S(t)*H(t)/N - beta_prime*S(t)*P(t)/N,
    E'(t) = beta*S(t)*I(t)/N + ell*beta*S(t)*H(t)/N + beta_prime*S(t)*P(t)/N - kappa*E(t),
    I'(t) = kappa*rho1*E(t) - (gamma_a + gamma_i + delta_i)*I(t),
    P'(t) = kappa*rho2*E(t) - (gamma_a + gamma_i + delta_p)*P(t),
    A'(t) = kappa*(1 - rho1 - rho2)*E(t) - gamma_a*A(t),
    H'(t) = gamma_i*(I(t) + P(t)) - (gamma_r + delta_h)*H(t),
    R'(t) = gamma_a*(I(t) + P(t) + A(t)) + gamma_r*H(t),
    F'(t) = delta_i*I(t) + delta_p*P(t) + delta_h*H(t),

    y1(t) = I(t) + P(t) + H(t),
    y2(t) = delta_i*I(t) + delta_p*P(t) + delta_h*H(t),
    y_N(t) = N
)

known_states = [S, E, I, P, A, H, R, F]
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

run_case("seipahrf_published_outputs unknown initial conditions", "seipahrf_published_outputs_unknown_initial.txt")
run_case("seipahrf_published_outputs known initial conditions", "seipahrf_published_outputs_known_initial.txt", known_ic = known_states)