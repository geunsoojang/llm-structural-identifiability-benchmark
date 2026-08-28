using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
ode = @ODEmodel(
    S'(t) = b*N - S(t)*(lambda*I(t) + lambda*eps_a*eps_q*Q(t) + lambda*eps_a*A(t) + lambda*eps_j*J(t) + d1),
    I'(t) = k1*A(t) - (gamma1 + mu2 + d2)*I(t),
    R'(t) = gamma1*I(t) + gamma2*J(t) - d3*R(t),
    A'(t) = S(t)*(lambda*I(t) + lambda*eps_a*eps_q*Q(t) + lambda*eps_a*A(t) + lambda*eps_j*J(t)) - (k1 + mu1 + d4)*A(t),
    Q'(t) = mu1*A(t) - (k2 + d5)*Q(t),
    J'(t) = k2*Q(t) + mu2*I(t) - (gamma2 + d6)*J(t),

    y1(t) = Q(t),
    y2(t) = J(t),
    y_b(t) = b,
    y_N(t) = N
)

known_states = [S, I, R, A, Q, J]

println("Massonis SIR model 26 Gallina outputs Q,J: unknown initial conditions")
unknown_ic_result = assess_identifiability(ode, loglevel = Logging.Warn)
show(stdout, "text/plain", unknown_ic_result)
println()

println("Massonis SIR model 26 Gallina outputs Q,J: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
