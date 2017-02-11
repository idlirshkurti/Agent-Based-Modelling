# ----------------------------------------------------------------- #
# -------------------- AGENT BASED MODELLING ---------------------- #
# ----------------------------------------------------------------- #

# Packages required for this code to run
packages <- c("ggplot2", "FNN", "utils")
lapply(packages, require, character.only = TRUE)

n <- 1000
a <- 0.01
i <- c(1:n) # order of agents

# Define the x-y locations of the agents and the objects
x <- runif(n,0,1)
y <- runif(n,0,1)
x_obj <- runif(n,-10,10); y_obj <- runif(n,-10,10)
objects <- data.frame(x = x_obj, y = y_obj)

nn <- 5 # The number of nearest neighbours used in the algorithm

# Pre-define a data frame with the initial starting points of each agent
# at time t = 0 and positions = 0 for the remaining time points. These
# positions will be changed in the loop below. 
dfx <- as.data.frame(matrix(0, n, 102))
dfy <- as.data.frame(matrix(0, n, 102))
dfx[,c(1, 2)] <- cbind(i, x)
dfy[,c(1, 2)] <- cbind(i, y)

# Initial empty data frame which will later contain the accumulated wealth of each agent
wealth <- as.data.frame(matrix(0, n, 101))

# Dimension names for the data frames 
names<-NULL
for(t in 1:102){
	if(t==1){
		names[t] <- as.character("Individual")
	}else{
names[t]<-as.character(paste("time =", t - 2))
}}

dimnames(dfx)[[2]] <- names
dimnames(dfy)[[2]] <- names
dimnames(wealth)[[2]] <- names[-1]

# Initial positions of the agents
init_plot <- ggplot(data = data.frame(x = dfx[,2], y = dfy[,2]), aes(x = x, y = y)) 
init_plot <- init_plot + geom_point(shape=1) 
init_plot <- init_plot + xlim(0, 1) + ylim(0, 1)
init_plot <- init_plot + labs(x = "Final x position",  y = "Final y position", 
	title = "Initial Positions of Agents")
pdf("Initial Agents.pdf", 7, 5)
plot(init_plot)
dev.off()

# Initial positions of the objects
init_obj <- ggplot(data = data.frame(x = x_obj, y = y_obj), aes(x = x, y = y)) 
init_obj <- init_obj + geom_point(shape=1) 
init_obj <- init_obj + xlim(-10, 10) + ylim(-10, 10)
init_obj <- init_obj + labs(x = "Final x position",  y = "Final y position", 
	title = "Initial Positions of Objects")
pdf("Initial Objects.pdf", 7, 5)
plot(init_obj)
dev.off()

# Create a factor vector 'z' of length 2000 with levels "Agents" and "Objects"
z <- as.factor(c(rep(1,n),rep(2,n)))
levels(z) <- c("Agents", "Objects")

# Create an initial dataset with the x and y coords of objects and agents together
initial_df <- data.frame(x = c(dfx[,2],x_obj) , y = c(dfy[,2], y_obj), z = z)

# Initial positions of the agents and objects
initial <- ggplot(data = initial_df, aes(x = x, y = y)) 
initial <- initial + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
initial <- initial + xlim(-10, 10) + ylim(-10, 10)
initial <- initial + labs(x = "X - position",  y = "Y - position", 
	title = " Initial Positions of Objects and Agents")
initial <- initial + theme(plot.title = element_text(size = rel(2)))
pdf("Initial Agents-Objects.pdf", 7, 5)
plot(initial)
dev.off()

# (zoomed-in) Initial positions of the agents and objects
initial_zoom <- ggplot(data = initial_df, aes(x = x, y = y)) 
initial_zoom <- initial_zoom + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
initial_zoom <- initial_zoom + xlim(-1, 2) + ylim(-1, 2)
initial_zoom <- initial_zoom + labs(x = "X - position",  y = "Y - position", 
	title = " Initial Positions of Objects and Agents")
initial_zoom <- initial_zoom + theme(plot.title = element_text(size = rel(2)))
pdf("Initial Agents-Objects(zoomed).pdf", 7, 5)
plot(initial_zoom)
dev.off()

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

# Get a vector (tot_wealth) of the total accumulated wealth of all agents combined
# from time t = 0 to time t = 100
tot_wealth <- NULL
for (j in 1:101){
	tot_wealth[j] <- sum(wealth[,j])
}

# Create a final dataset with the x and y coords of objects and agents together
final_df <- data.frame(x = c(dfx[,102],x_obj) , y = c(dfy[,102], y_obj), z = z)

# Final positions of the agents
final_plot <- ggplot(data = data.frame(x = dfx[,102], y = dfy[,102]), aes(x = x, y = y)) 
final_plot <- final_plot + geom_point(shape=1) 
final_plot <- final_plot + xlim(-3, 3) + ylim(-3, 3)
final_plot <- final_plot + labs(x = "Final x position",  y = "Final y position", 
	title = "Final Positions of Agents")
pdf("Final Agents.pdf", 7, 5)
plot(final_plot)
dev.off()

# Final positions of the agents and objects
final <- ggplot(data = final_df, aes(x = x, y = y)) 
final <- final + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
final <- final + xlim(-10, 10) + ylim(-10, 10)
final <- final + labs(x = "Final x position",  y = "Final y position", 
	title = " Final Positions of Objects and Agents")
final <- final + theme(plot.title = element_text(size = rel(2)))
pdf("Final Agents-Objects.pdf", 7, 5)
plot(final)
dev.off()

# (zoomed-in) Final positions of the agents and objects
final_zoom <- ggplot(data = final_df, aes(x = x, y = y)) 
final_zoom <- final_zoom + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
final_zoom <- final_zoom + xlim(-2, 2) + ylim(-2, 2)
final_zoom <- final_zoom + labs(x = "Final x position",  y = "Final y position", 
	title = " Final Positions of Objects and Agents")
final_zoom <- final_zoom + theme(plot.title = element_text(size = rel(2)))
pdf("Final Agents-Objects(zoomed).pdf", 7, 5)
plot(final_zoom)
dev.off()

# Accumulated wealth plot over time
pl1 <- ggplot(as.data.frame(tot_wealth), aes(x = c(1:101) , y = tot_wealth))
pl1 <- pl1 + labs(x = "Time",  y = "Wealth", 
	title = "Accumulated Wealth Over Time")
pl1 <- pl1 + geom_line(colour = "deepskyblue4")
pl1 <- pl1 +  theme(plot.title = element_text(size = rel(2)))
pdf("Accumulated Wealth.pdf", 7, 5)
plot(pl1)
dev.off()

# Note: All plots will be saved in the current working directory.
# To open the current working directory and check the plots 
# first define and then run the following function

opendir <- function(dir = getwd()){
    if (.Platform['OS.type'] == "windows"){
        shell.exec(dir)
    } else {
        system(paste(Sys.getenv("R_BROWSER"), dir))
    }
}

opendir() # Opens the current working directory







