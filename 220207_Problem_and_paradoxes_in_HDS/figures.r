n <- 100
ps <- c(2, 10, 100, 1000)

p <- 2
set.seed(42)
x <- matrix(runif(n * p), nrow=n, ncol=p)
pdf(file="./tex/figures/2d_points.pdf", width=6, height=6)
    par(mar=c(3,3,1,1))
    plot(x, pch=20, cex=2, xlab="", ylab="", yaxt="n", xaxt="n", asp="1", 
	 xlim=c(0, 1), ylim=c(0, 1))
    axis(1, c(0, 1), cex=3)
    axis(2, c(0, 1), cex=3)
dev.off()

for (i in 1:5) {
pdf(file=sprintf("./tex/figures/2d_points_%d.pdf", i), width=6, height=6)
par(mar=c(3,3,1,1))
plot(x, pch=20, cex=2, xlab="", ylab="", yaxt="n", xaxt="n", asp="1", 
     xlim=c(0, 1), ylim=c(0, 1))
axis(1, c(0, 1), cex=3)
axis(2, c(0, 1), cex=3)
    for (i in 1:i) {
	from <- cbind(x[i, 1], x[setdiff(1:100, i), 1])
	to   <- cbind(x[i, 2], x[setdiff(1:100, i), 2])
	matplot(t(from), t(to), type="l", add=T, lty=1, col=1, lwd=.1)
	points(x[i, 1], x[i, 2], col="red", pch=20, cex=3)
    }
dev.off()
}

cols <- c("deepskyblue", "darkorchid", "springgreen", "orange")
xlims <- c(3, 5, 8, 15)
for (i in 1:4) {
    p <- ps[i]
    x <- matrix(runif(n * p), nrow=n, ncol=p)
    X <- x %*% t(x)
    xs <- outer(diag(X), diag(X), FUN=function(x, y) x + y)
    ds <- sqrt(xs - 2*X)[upper.tri(diag(n))]
    pdf(file=sprintf("./tex/figures/distances_%d.pdf", i), width=4.5, height=3)
	par(mar=c(3, 4, 3, 1))
	hist(ds, xlim=c(0, xlims[i]), main=sprintf("p = %d", p), col=cols[i])
    dev.off()
}

pdf(file="./tex/figures/distances_all.pdf", width=9, height=6)
for (i in 4:1) {
    p <- ps[i]
    par(mar=c(3, 4, 3, 1))
    x <- matrix(runif(n * p), nrow=n, ncol=p)
    X <- x %*% t(x)
    xs <- outer(diag(X), diag(X), FUN=function(x, y) x + y)
    ds <- sqrt(xs - 2*X)[upper.tri(diag(n))]
    hist(ds, xlim=c(0, 15), main="", add=i<4, col=cols[i])
}
legend("topright", legend=sprintf("p = %d", ps), fill=cols)
dev.off()

# volume of a ball
vp <- function(p, r=1) {
    pi^(p/2) / gamma(p/2 + 1) * r^p
}

pdf(file="./tex/figures/volume_ball.pdf", width=6, height=4)
par(mar=c(3, 4, 1, 1))
plot(1:50, vp(1:50, r=1), type="b", lwd=5, xaxt="n", ylab="Volume")
axis(1, c(1, 25, 50))
dev.off()


pdf(file="./tex/figures/mass_crust.pdf", width=6, height=4)
par(mar=c(3, 4, 1, 1))
plot(1 - 0.99^(1:500), type="l", lwd=2, xlab="p", ylab="")
dev.off()


n <- 1000
ps <- c(5, 20, 250, 500)

for (i in 1:4) {
    p <- ps[i]
    x <- matrix(rnorm(n * p, 0 , 1), ncol=p)
    x.svd <- eigen(cov(x))
    pdf(file=sprintf("./tex/figures/eigen_%d.pdf", i), width=4.5, height=3)
	par(mar=c(3, 4, 3, 1))
	hist(x.svd$values, xlim=c(0, 5), main=sprintf("p = %d", p), col=cols[i])
    dev.off()
}


hist(rep(c(-50, -20, 1), 50), xlim=c(0, 5), breaks=50, main=sprintf("p = %d", p), col=cols[i])
