library(glmnet)
library(survival.svb)


# ----------------------------------------
# Generate some test data
# ----------------------------------------
set.seed(12)
n <- 200                        # number of sample
p <- 1000                       # number of features
s <- 10                         # number of non-zero coefficients
censoring_lvl <- 0.25           # degree of censoring

b <- sample(c(runif(s, 0.5, 2)*sample(c(-1,1), s, replace=T), rep(0, p-s)))
X <- matrix(rnorm(n * p), nrow=n)
Y <- log(1 - runif(n)) / -exp(X %*% b)
delta  <- runif(n) > censoring_lvl              # 0: censored, 1: uncensored
Y[!delta] <- Y[!delta] * runif(sum(!delta))     # rescale censored data
     

cex <- b
cex[which(b == 0)] <- 0.5
cex[which(b != 0)] <- 1.5

pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/true_beta.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
dev.off()


# ----------------------------------------
# LASSO
# ----------------------------------------
y <- survival::Surv(matrix(Y), matrix(delta+0))
l <- cv.glmnet(X, y, family="cox")

# cross-validated value of beta
l.beta <- l$glmnet.fit$beta[, 33]
l.cex <- l.beta
l.cex[which(l.beta == 0)] <- 0.5
l.cex[which(l.beta != 0)] <- 1.5


pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/lasoo_est.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
points(l.beta, type="p", lwd=1, las=1, pch=20, cex=l.cex, col="darkblue")
legend("topright", legend=c("True", "LASSO est."), pch=c(8, 20), col=c(1, "darkblue"), bty="n")
dev.off()


pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/lasso_reg_path.pdf",
    width=6, height=4)
par(mar=c(4,4,0.5,1))
matplot(l$lambda, t(l$glmnet.fit$beta), type="l", lwd=3, log="x", las=1,
	xlab=expression(lambda), main="", ylab=expression(beta))
dev.off()


# ----------------------------------------
# SpSL
# ----------------------------------------
ci.vi <- function(fit, b0, a=0.95, size=3, offset=0.5, add_line=T,
	lty.col=1, lty.wd=2, ...) 
{
    m <- fit$m
    s <- fit$s
    g <- fit$g

    for (i in which(b0 != 0)) 
    {
	if (g[i] <= a) next

	a.g <- 1 - a/g[i]
	width <- qnorm(1 - a.g/2)

	xs <- seq(m[i] - s[i] * width, m[i] + s[i] * width, by=0.005)
	ys <- dnorm(xs, m[i], s[i])
	polygon(i + ys * size - min(ys) * size + offset, xs, ...) 
	if (add_line) {
	    lines(c(i, i) + offset, range(xs), col=lty.col, lwd=lty.wd)
	}
    }
}


f <- survival.svb::svb.fit(Y, delta, X)
pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/spsl_beta.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
points(f$beta_hat, col="darkorange", pch=20, cex=cex)
ci.vi(f, f$g > .5, 0.99, border=NA, lty.col="darkorange", lwd=1, col=rgb(1, 0.54, 0, 0.2), size=8)
legend("topright", legend=c("True", "SpSL est."), pch=c(8, 20), col=c(1, "darkorange"), bty="n")
dev.off()


pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/spsl_inc_prob.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(f$g, cex=1.5, ylab=expression(gamma), lwd=1, pch=1, col="darkorange")
points(which(!!b), !!b[which(!!b)], pch=3, col="darkorchid1", cex=1, lwd=2)
legend("bottomright", legend=c("Actual", "SpSL"), pch=c(3, 1), col=c("darkorchid1", "darkorange"), 
       cex=1, lwd=2, lty=NA, bg="white")
dev.off()


fit <- list()
lambda <- c(0.25, 0.5, 0.75, 1, 1.5, 2, 4, 5)
for (i in seq_along(lambda)) {
    fit[[i]] <- survival.svb::svb.fit(Y, delta, X, lambda=lambda[i])
}


B <- matrix(ncol=1000, nrow=0)
for (i in seq_along(lambda)) {
    fi <- fit[[i]]
    B <- rbind(B, fi$beta_hat)
}


pdf("~/phd/pres/211129_Spike_and_Slab_in_Practice/tex/figures/spsl_reg_path.pdf",
    width=6, height=4)
par(mar=c(4,4,.2,1))
matplot(lambda, B, type="l", lwd=3, xlab=expression(lambda), ylab=expression(beta), las=1)
dev.off()


