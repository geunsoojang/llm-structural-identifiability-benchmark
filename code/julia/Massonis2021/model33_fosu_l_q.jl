using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
# The Appendix result and the source model use alpha1 in the I outflow.
# This also matches R'(t), where alpha1*I(t) is the corresponding inflow.
ode = @ODEmodel(
    S'(t) = mu*N - beta1*S(t)*I(t) - (gamma + eta)*S(t) + delta*L(t) + xi*E(t),
    L'(t) = eta*S(t) - (gamma + delta)*L(t),
    E'(t) = beta1*S(t)*I(t) - (gamma + theta2 + epsilon + xi)*E(t),
    I'(t) = epsilon*E(t) - (gamma + theta1 + alpha1)*I(t),
    Q'(t) = theta1*I(t) + theta2*E(t) - (gamma + alpha2)*Q(t),
    R'(t) = alpha1*I(t) + alpha2*Q(t) - gamma*R(t),

    y1(t) = L(t),
    y2(t) = Q(t),
    y_mu(t) = mu,
    y_N(t) = N
)

known_states = [S, L, E, I, Q, R]

println("Massonis SEIR model 33 Fosu outputs L,Q: unknown initial conditions")
unknown_ic_result = assess_identifiability(ode, loglevel = Logging.Warn)
show(stdout, "text/plain", unknown_ic_result)
println()

println("Massonis SEIR model 33 Fosu outputs L,Q: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
