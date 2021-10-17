
ci.vi <- function(fit, b0, a=0.95, size=3, offset=0.5, add_line=T,
	lty.col=1, lty.wd=2, ...) 
{
    m <- fit$m
    s <- fit$s
    a <- 1 - a
    width <- qnorm(1 - a/2)
    for (i in which(b0 != 0)) {
	xs <- seq(m[i] - s[i] * width, m[i] + s[i] * width, by=0.005)
	ys <- dnorm(xs, m[i], s[i])
	polygon(i + ys * size - min(ys) * size + offset, xs, ...) 
	# polygon(i - ys * size + min(ys) * size - offset, xs, ...) 
	if (add_line) {
	    lines(c(i, i) + offset, range(xs), col=lty.col, lwd=lty.wd)
	}
    }
}


x <- rbeta(100, 0.5, 1)
x <- sort(x)

cols <- c(rgb(1, 0, 0, 0.5), rgb(0, 1, 0, 0.5))[1 + (x < 0.05)]

pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/pvals.pdf",
    width=6, height=4)
par(mar=c(1,4,1,1))
barplot(x, col=cols, ylim=c(0, 1), ylab="p-vlaue")
abline(h=0.05, lwd=3, lty=2, col="green")
dev.off()


library(glmnet)
library(survival.svb)

n <- 200                        # number of sample
p <- 1000                       # number of features
s <- 10                         # number of non-zero coefficients
censoring_lvl <- 0.4            # degree of censoring

# generate some test data
set.seed(1)
b <- sample(c(runif(s, -2, 2), rep(0, p-s)))
X <- matrix(rnorm(n * p), nrow=n)
Y <- log(1 - runif(n)) / -exp(X %*% b)
delta  <- runif(n) > censoring_lvl              # 0: censored, 1: uncensored
Y[!delta] <- Y[!delta] * runif(sum(!delta))     # rescale censored data
     
 
f <- survival.svb::svb.fit(Y, delta, X)
f$beta_hat <- f$m * f$g

cex <- b
cex[which(b == 0)] <- 0.5
cex[which(b != 0)] <- 1.5


pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/true_beta.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
dev.off()

pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/est_beta.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
points(f$beta_hat, col="blue", pch=20, cex=cex)
dev.off()


pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/est_beta_ci.pdf",
    width=6, height=4)
par(mar=c(4,4,1,1))
plot(b, pch=8, ylim=c(-2, 2), cex=cex, ylab=expression(beta), las=1)
points(f$beta_hat, col="blue", pch=20, cex=cex)
ci.vi(f, f$g > .5, border=NA, lty.col="blue", lwd=1, col=rgb(0, 0, 1, 0.2), size=8)
dev.off()


pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/inc_probs.pdf",
    width=6, height=4)
par(mar=c(4,4,3,1))
plot(f$g, pch=1, cex=1.5, ylab=expression(gamma), main="Inclusion probabilities", lwd=1)
points(which(!!b), !!b[which(!!b)], pch=3, col="darkorchid1", cex=1, lwd=2)
legend("topright", legend=c("Actual"), pch=3, col="darkorchid1", cex=1, lwd=2, lty=NA)
dev.off()



y <- survival::Surv(matrix(Y), matrix(delta+0))

# let's look at lambda
l <- cv.glmnet(X, y, family="cox")


pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/lrp/pdf",
    width=6, height=4)
par(mar=c(4,4,3,1))
matplot(l$lambda, t(l$glmnet.fit$beta), type="l", lwd=3, log="x", las=1,
	xlab=expression(lambda), main="LASSO regularisation path", 
	ylab=expression(beta))
dev.off()

fit <- list()
lambda <- c(0.25, 0.5, 0.75, 1, 1.5, 2, 4, 5)
for (i in seq_along(lambda)) {
    fit[[i]] <- survival.svb::svb.fit(Y, delta, X, lambda=lambda[i])
}

B <- matrix(ncol=1000, nrow=0)
for (i in seq_along(lambda)) {
    fi <- fit[[i]]
    B <- rbind(B, fi$m * fi$g)
}


pdf("~/phd/pres/211015_An_intro_to_spike_and_slab_priors/tex/figures/ssrp.pdf",
    width=6, height=4)
par(mar=c(4,4,3,1))
matplot(lambda, B, type="l", lwd=3, main="S+S regularisation path",
	xlab=expression(lambda), ylab=expression(beta), las=1)
dev.off()

