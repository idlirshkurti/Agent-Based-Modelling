# ------------------ Start time-iterations (approx. 10 min) -------------------- #

pb <- txtProgressBar(1, 100, style=3)
ptm <- proc.time()

for(k in 1:100){

	# Get the 5 Nearest Neighbours on the x - axis
	fx <- get.knn(data = dfx[,c(k+1)], k=nn, algorithm=c("kd_tree"))$nn.index 
	# Find the mean distance between each agent and the nearest 5 neighbours in x - axis
	x_f <- NULL 
		for(j in 1:n){
			x_f[j] <- mean(dfx[j,c(k+1)] - dfx[fx[j,],c(k+1)])
		}

	# Random movement of agents in the x - axis
	d1x <- runif(n, -1, 1)
	new_x <- dfx[,c(k+1)] + d1x

	# Agents regroup in the x - axis
	dfx[,c(k+2)] <- 0.5*(new_x + x_f)

	# Get the 5 Nearest Neighbours in using the y coordinates
	fy <- get.knn(data = dfy[,c(k+1)], k=nn, algorithm=c("kd_tree"))$nn.index 
	# Find the mean distance between each agent and the nearest 5 neighbours in y - axis
	y_f <- NULL
		for(j in 1:n){
			y_f[j] <- mean(dfy[j,c(k+1)] - dfy[fy[j,],c(k+1)])
		}

	# Random movement in the y - axis
	d1y <- runif(n, -1, 1) 
	new_y <- dfy[,c(k+1)] + d1y

	# Agents regroup in in the y - axis
	dfy[,c(k+2)] <- 0.5*(new_y + y_f)

	# Wealth count update step
	for(l in 1:n){
		agent_coord <- c(new_x[l], new_y[l])
		dat <- rbind(agent_coord, objects)
		distances <- dist(dat)[1:n]   # calculates geometric distances
		# Increase wealth of each agent only if the distance between agent
		# and object is less than a = 0.01
		wealth[l, k+1] <- wealth[l, k] + length(which(distances <= a)) 
	}

	setTxtProgressBar(pb, k)
	
	if (k == 100){
		time_taken <- proc.time() - ptm
		cat(paste("Time taken = ", round(as.numeric(time_taken[3])/60,2), "minutes"))
	}
}

# --------------------- End time - iterations ----------------------------- #
