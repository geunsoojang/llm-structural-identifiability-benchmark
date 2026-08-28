using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    Sh'(t) = -a*b*Sh(t)*Iv(t)/Nh - beta*Sh(t)*(alpha*Eh(t) + Ih1(t) + tau*Ih2(t))/Nh,
    Eh'(t) = theta*(a*b*Sh(t)*Iv(t)/Nh + beta*Sh(t)*(alpha*Eh(t) + Ih1(t) + tau*Ih2(t))/Nh) - kappa_h*Eh(t),
    Ih1'(t) = kappa_h*Eh(t) - gamma_h1*Ih1(t),
    Ih2'(t) = gamma_h1*Ih1(t) - gamma_h2*Ih2(t),
    Ah'(t) = (1 - theta)*(a*b*Sh(t)*Iv(t)/Nh + beta*Sh(t)*(alpha*Eh(t) + Ih1(t) + tau*Ih2(t))/Nh) - gamma_h*Ah(t),
    Rh'(t) = gamma_h2*Ih2(t) + gamma_h*Ah(t),
    Sv'(t) = -a*c*Sv(t)*(rho*Eh(t) + Ih1(t))/Nh - mu_v*Sv(t),
    Ev'(t) = a*c*Sv(t)*(rho*Eh(t) + Ih1(t))/Nh - (kappa_v + mu_v)*Ev(t),
    Iv'(t) = kappa_v*Ev(t) - mu_v*Iv(t),
    C'(t) = kappa_h*Eh(t),

    y1(t) = kappa_h*Eh(t),
    y2(t) = Nh,
    y3(t) = Nv
)

known_states = [Sh, Eh, Ih1, Ih2, Ah, Rh, Sv, Ev, Iv, C]
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

run_case("m4_zika_host_vector_incidence unknown initial conditions", "m4_zika_host_vector_incidence_unknown_initial.txt")
run_case("m4_zika_host_vector_incidence known initial conditions", "m4_zika_host_vector_incidence_known_initial.txt", known_ic = known_states)